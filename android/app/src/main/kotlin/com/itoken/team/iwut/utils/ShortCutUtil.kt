package com.itoken.team.iwut.utils

import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.content.pm.ShortcutInfo
import android.content.pm.ShortcutManager
import android.graphics.drawable.Icon
import android.os.Build
import android.widget.Toast
import androidx.annotation.DrawableRes
import com.itoken.team.iwut.MainActivity

// 快捷方式工具类
object ShortCutUtil {

    fun createShortCut(
        context: Context,
        shortCutID: String,
        label: String,
        @DrawableRes logoID: Int,
        targetActivity: Class<*>
    ) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val shortCutManager =
                context.getSystemService(Context.SHORTCUT_SERVICE) as ShortcutManager
            if (shortCutManager.isRequestPinShortcutSupported) {
                val shortCutInfoIntent = Intent(context, targetActivity)
                shortCutInfoIntent.action = Intent.ACTION_VIEW
                val info = ShortcutInfo.Builder(context, shortCutID)
                    .setIcon(Icon.createWithResource(context, logoID))
                    .setShortLabel(label)
                    .setIntent(shortCutInfoIntent)
                    .build()
                val shortcutCallbackIntent = PendingIntent.getBroadcast(
                    context,
                    0,
                    Intent(context, MainActivity::class.java),
                    PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
                )
                shortCutManager.requestPinShortcut(info, shortcutCallbackIntent.intentSender)
            } else {
                Toast.makeText(context, "设备不支持在桌面创建快捷图表！", Toast.LENGTH_SHORT).show()
            }
        }
    }
}