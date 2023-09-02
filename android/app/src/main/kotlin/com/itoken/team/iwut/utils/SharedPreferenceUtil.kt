package com.itoken.team.iwut.utils

import android.content.Context
import com.itoken.team.iwut.MyApplication

object SharedPreferenceUtil{
    private const val spFileName = "FlutterSharedPreferences"
    private const val cardIdKey = "flutter.cardID"
    private const val cardPwdKey = "flutter.cardPwd"
    private val sharedPreferences by lazy{MyApplication.context.getSharedPreferences(spFileName,Context.MODE_PRIVATE)}

    var cardID: String?
        get() = sharedPreferences.getString(cardIdKey,null)
        set(value) = sharedPreferences.edit().putString(cardIdKey,value).apply()
    var cardPwd: String?
        get() = sharedPreferences.getString(cardPwdKey,null)
        set(value) = sharedPreferences.edit().putString(cardPwdKey,value).apply()
}