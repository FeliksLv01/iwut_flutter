package com.itoken.team.iwut.utils

import android.util.Log
import android.widget.Toast
import com.itoken.team.iwut.MyApplication
import com.itoken.team.iwut.extension.*
import com.itoken.team.iwut.model.Environment
import java.io.BufferedReader
import java.io.InputStreamReader
import java.lang.Exception
import java.net.HttpURLConnection
import java.net.URL
import java.util.regex.Pattern

object WifiUtil {
    private const val AVAILABLE_TEST_URL = "http://www.hao123.com"
    private const val AVAILABLE_TEST_CONTENT = "hellofuture"
    private const val USER_AGENT_RED_MI =
        "Mozilla/5.0 (Linux; Android 5.1.1; Redmi 3 Build/LMY47V; wv) AppleWebKit/537.36 (KHTML like Gecko) Version/4.0 Chrome/51.0.2704.81 Mobile Safari/537.36"
    private const val PORTAL_POST_HEAD = "action=login&save_me=1&ajax=1"
    private const val PORTAL_URL = "http://172.30.16.34/include/auth_action.php"
    private const val LOGIN_SUCCESS = "登录成功"
    private const val LOGIN_FAILED = "登录失败\n请进入掌上吾理登录界面检查账号密码是否正确"

    /**
     * 返回一个包含登录校园网所需的参数的集合，即[Environment]
     * 若返回null则表明当前无网络或网络已连接
     */
    suspend fun getSrunEnvironment(): Environment? {
        var url = AVAILABLE_TEST_URL
        while (true) {
            url = getNextRedirectURL(url)
            Log.d(MyApplication.WIFI_TAG, "getSrunEnvironment redirectUrl: $url")
            if (url == AVAILABLE_TEST_CONTENT || url.isBlank()) {
                (if(url.isBlank()) "无可用网络" else "网络畅通").showToastOnUi()
                break
            }
            if (url.isFinalSrunUrl()) {
                Log.d(MyApplication.WIFI_TAG, "getSrunEnvironment finalUrl: $url")
                return Environment(url)
            }
        }
        return null
    }

    /**
     * 进行校园网登录操作
     * 若[environment]为null则返回true
     * 否则返回登录是否成功
     */
    suspend fun doPortal(environment: Environment?): Boolean {
        if (environment == null) return true
        "开始登录".showToastOnUi()
        val postData: String = PORTAL_POST_HEAD +
                "&username=" + SharedPreferenceUtil.cardID +
                "&password=" + SharedPreferenceUtil.cardPwd +
                "&user_ip=" + environment.ip +
                "&mac=" + environment.mac +
                "&nas_ip=" + environment.switchIp +
                "&ac_id=" + environment.acId
        val networkUtil = NetworkUtil(PORTAL_URL, postData = postData)
        val result = networkUtil.getResponseString()
        Log.d(MyApplication.WIFI_TAG, "doPortal: $result")
        (if(result.contains("login_ok")) LOGIN_SUCCESS else LOGIN_FAILED).showToastOnUi(Toast.LENGTH_LONG)
        return result.contains("login_ok")
    }

    // 获取下一个重定向地址
    private fun getNextRedirectURL(urlString: String): String {
        var connection: HttpURLConnection? = null
        var location: String? = null
        var resultData = ""
        try {
            val url = URL(urlString)
            connection = url.openConnection() as HttpURLConnection
            connection.apply {
                doInput = true
                doOutput = false
                useCaches = false
                connectTimeout = 10000
                readTimeout = 10000
                requestMethod = "GET"
                instanceFollowRedirects = false

                //使用默认认证算法
                setRequestProperty("User-Agent", USER_AGENT_RED_MI)
                setRequestProperty("Upgrade-Insecure-Requests", "1")
                setRequestProperty("Connection", "keep-alive")
            }

            val inputStreamReader = InputStreamReader(connection.inputStream)
            resultData = BufferedReader(inputStreamReader).use(BufferedReader::readText)
            val locationList: List<String>? =
                connection.headerFields["location"] ?: connection.headerFields["Location"]
            if (locationList != null && locationList.size == 1) {
                location = locationList[0]
            }

            Log.d(MyApplication.WIFI_TAG, "getNextRedirectURL location: $location")
            Log.d(MyApplication.WIFI_TAG, "getNextRedirectURL resultData: $resultData")

        } catch (e: Exception) {
            e.printStackTrace()
        } finally {
            connection?.disconnect()
        }

        if (location != null) {
            val returnResult = location.replace("/index_client_".toRegex(), "/index_")
            return checkIndexXXXHtmlUrl(returnResult)
        }
        if (resultData.contains("&arubalp=") && resultData.contains("http-equiv='refresh'")) {
            val positionStart =
                resultData.indexOf("url=", resultData.indexOf("http-equiv='refresh'")) + 4
            val positionEnd = resultData.indexOf("'>", positionStart)
            val redirectUrl = resultData.substring(positionStart, positionEnd)
            val returnResult = redirectUrl.replace("/index_client_".toRegex(), "/index_")
            return checkIndexXXXHtmlUrl(returnResult)
        }
        if (resultData.delBlank().contains("varurl=\"http://172")) {
            val noneBlankResultData = resultData.delBlank()
            val positionStart = noneBlankResultData.indexOf("varurl=\"http://172") + 8
            val positionEnd = noneBlankResultData.indexOf("\"", positionStart)
            val redirectUrl = noneBlankResultData.substring(positionStart, positionEnd)
                .replace("/index_client_".toRegex(), "/index_")
            return checkIndexXXXHtmlUrl(redirectUrl)
        }
        if (resultData.contains("location.href=\'http://172.30.16.34")) {
            return checkIndexXXXHtmlUrl(resultData, isNHDORM = true)
        }

        return resultData.delBlank()
    }

    private fun checkIndexXXXHtmlUrl(url: String, isNHDORM: Boolean = false): String {
        val pattern = Pattern.compile("index_(\\d*).html")
        val matcher = pattern.matcher(url)

        if (matcher.find()) {
            val acIdString = matcher.group(1)
            if (isNHDORM) { //南湖宿舍区重定向链接检测
                val newUrl = url.substring(0, url.indexOf("\'<"))
                return "http://172.30.16.34/ac_detect.php?cmd=login&ac_id=$acIdString&" + newUrl.getLastRight(
                    ".html?"
                )
            } else if (url.isPartSrunUrl()) {
                return "http://172.30.16.34/ac_detect.php?a=x&ac_id=$acIdString&" + url.getLastRight(
                    ".html?"
                )
            }
        }
        return url
    }
}