package com.itoken.team.iwut.utils

import okhttp3.MediaType.Companion.toMediaTypeOrNull
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody.Companion.toRequestBody
import okhttp3.Response
import java.util.concurrent.TimeUnit

/**
 * postData为null则使用GET
 */
class NetworkUtil(private val url: String, private val postData: String? = null) {
    companion object{
        private const val MEDIA_TYPE = "application/x-www-form-urlencoded; charset=utf-8"
        private const val BASE_CONNECT_USER_AGENT = " iWut Android/2.4 "

        private var okHttpClient: OkHttpClient
        init {
            val builder = OkHttpClient.Builder()
            okHttpClient = builder.readTimeout(120, TimeUnit.SECONDS)
                .writeTimeout(120, TimeUnit.SECONDS)
                .connectTimeout(120, TimeUnit.SECONDS)
                .build()
        }
    }

    fun getResponseString(): String{
        val response = getResponse()
        return response?.body?.string() ?: ""
    }
    private fun getResponse(): Response? {
        try {
            val builder = Request.Builder().url(url)
            if(postData != null){
                val requestBody = postData.toRequestBody(MEDIA_TYPE.toMediaTypeOrNull())
                builder.post(requestBody)
            }
            builder.addHeader("User-Agent", BASE_CONNECT_USER_AGENT)
            return okHttpClient.newCall(builder.build()).execute()
        }catch (e: Exception){
            e.printStackTrace()
        }
        return null
    }
}