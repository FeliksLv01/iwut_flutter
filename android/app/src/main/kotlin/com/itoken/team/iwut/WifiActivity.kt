package com.itoken.team.iwut

import android.app.Activity
import android.os.Bundle
import android.widget.Toast
import com.itoken.team.iwut.extension.showToast
import com.itoken.team.iwut.utils.SharedPreferenceUtil
import com.itoken.team.iwut.utils.WifiUtil
import kotlinx.coroutines.*

class WifiActivity : Activity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        if (SharedPreferenceUtil.cardPwd.isNullOrBlank() || SharedPreferenceUtil.cardID.isNullOrBlank()) {
            "请先进入掌上吾理登录界面填写账号与密码".showToast(Toast.LENGTH_LONG)
        } else {
            CoroutineScope(Dispatchers.IO).launch {
                WifiUtil.doPortal(WifiUtil.getSrunEnvironment())
            }
        }
    }

    override fun onResume() {
        super.onResume()
        finish()
    }
}