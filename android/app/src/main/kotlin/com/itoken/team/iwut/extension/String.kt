package com.itoken.team.iwut.extension

import android.widget.Toast
import com.itoken.team.iwut.MyApplication
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext

/**
 * 删去字符串中的\n,\r,\t和空格
 */
fun String.delBlank() = run {
    replace(" ".toRegex(), "")
        .replace("\n".toRegex(), "")
        .replace("\r".toRegex(), "")
        .replace("\t".toRegex(), "")
}

/**
 * 返回字符串中最后一个[left]子串右侧的字符串
 */
fun String.getLastRight(left: String): String {
    if(!this.contains(left)) return this
    val pos = this.lastIndexOf(left) + left.length
    if(pos > this.length) return this
    return this.substring(pos)
}

fun String.isPartSrunUrl(): Boolean = this.contains("cmd=login")
        && this.contains("mac=")
        && this.contains("ip=")

fun String.isFinalSrunUrl(): Boolean = this.isPartSrunUrl()
        && this.contains("&ac_id=")

/**
 * 返回url中对应的参数
 */
fun String.getParams(params: String): String{
    var start = this.indexOf("&$params=")
    if(start == -1) start = this.indexOf("?$params=")
    if(start == -1) return ""
    val end = this.indexOf("&",start + 1)
    return this.substring(start + params.length + 2,end)
}

suspend fun String.showToastOnUi(duration: Int = Toast.LENGTH_SHORT) =
    withContext(Dispatchers.Main){ Toast.makeText(MyApplication.context,this@showToastOnUi,duration).show() }

fun String.showToast(duration: Int = Toast.LENGTH_SHORT) = Toast.makeText(MyApplication.context,this,duration).show()