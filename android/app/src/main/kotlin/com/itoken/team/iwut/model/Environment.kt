package com.itoken.team.iwut.model

import android.util.Log
import com.itoken.team.iwut.MyApplication
import com.itoken.team.iwut.extension.getParams
import com.itoken.team.iwut.utils.NetworkUtil

class Environment(url: String) {
    companion object{
        const val ERROR_STRING = "error_string"

        private fun getRealAcId(_switchIp: String): String{
            val networkUtil = NetworkUtil("http://172.30.16.34/srun_portal_pc.php?switchip=$_switchIp")
            val html = networkUtil.getResponseString()
            val itemPosition = html.indexOf("<input type=\"hidden\" name=\"ac_id\" value=")

            if(itemPosition < 0){ // 暂时处理
                Log.d(MyApplication.WIFI_TAG, "getRealAcId: item not found \n html:$html")
                return ERROR_STRING
            }

            /*左引号位置*/
            val leftQuotationMarkPosition: Int = itemPosition + 41
            /*右引号位置*/
            val rightQuotationMarkPosition = html.indexOf("\"", leftQuotationMarkPosition + 1)
            return html.substring(leftQuotationMarkPosition, rightQuotationMarkPosition)
        }
    }

    val mac = url.getParams("mac")
    val ip = url.getParams("ip")
    val switchIp = url.getParams("switchip")
    val acId by lazy {
        val realAcId = getRealAcId(switchIp)
        if(realAcId != ERROR_STRING){
            realAcId
        } else {
            url.getParams("ac_id")
        }
    }
}