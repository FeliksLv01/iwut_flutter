package com.itoken.team.iwut

import android.annotation.SuppressLint
import android.content.Context
import io.flutter.app.FlutterApplication

class MyApplication : FlutterApplication() {

    companion object {
        const val WIFI_TAG = "WIFI_DEBUG"

        @SuppressLint("StaticFieldLeak")
        lateinit var context: Context
    }

    override fun onCreate() {
        super.onCreate()
        context = applicationContext
    }
}