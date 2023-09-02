package com.itoken.team.iwut

import com.itoken.team.iwut.utils.ShortCutUtil
import com.itoken.team.iwut.utils.WifiUtil
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.*

class MainActivity : FlutterActivity() {
    companion object {
        private const val CHANNEL = "com.itoken.team.iwut.wifi_connect"
        private const val DO_PORTAL = "${CHANNEL}.wifiutil.doportal"
        private const val CREATE_SHORTCUT = "${CHANNEL}.wifiutil.addShortCut"
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    DO_PORTAL -> CoroutineScope(Dispatchers.IO).launch {
                        val res = WifiUtil.doPortal(WifiUtil.getSrunEnvironment())
                        withContext(Dispatchers.Main) {
                            result.success(res)
                        }
                    }
                    CREATE_SHORTCUT -> {
                        // 创建桌面快捷方式
                        ShortCutUtil.createShortCut(
                            context,
                            "wifi_login",
                            "校园网登录",
                            R.drawable.wifi,
                            WifiActivity::class.java
                        )
                    }
                }
            }
    }
}
