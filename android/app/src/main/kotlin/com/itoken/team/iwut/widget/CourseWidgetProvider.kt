package com.itoken.team.iwut.widget

import android.app.AlarmManager
import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.widget.RemoteViews
import com.itoken.team.iwut.MainActivity
import com.itoken.team.iwut.MyApplication
import com.itoken.team.iwut.R
import com.itoken.team.iwut.model.Course
import com.itoken.team.iwut.utils.CourseUtil
import com.itoken.team.iwut.utils.CourseWidgetUtil
import es.antonborri.home_widget.HomeWidgetProvider
import kotlinx.coroutines.*

/**
 * Implementation of App Widget functionality.
 */
class CourseWidgetProvider : HomeWidgetProvider() {

    companion object {
        private fun updateAppWidget(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetIds: IntArray
        ) {
            CoroutineScope(Dispatchers.Main).launch {
                var courseList: List<Course>
                withContext(Dispatchers.IO) {
                    courseList = CourseUtil.getTodayCourses()
                }
                appWidgetIds.forEach { widgetId ->
                    val views = RemoteViews(context.packageName, R.layout.course_widget).apply {
                        setOnClickPendingIntent(
                            R.id.widget_container,
                            PendingIntent.getActivity(
                                context,
                                0,
                                Intent(context, MainActivity::class.java),
                                0
                            )
                        )
                        setTextViewText(
                            R.id.widgetDate,
                            "${CourseUtil.weekDay}（第${CourseUtil.weekIndex}周）  今天一共有${courseList.size}大节课"
                        )
                        courseDataAllocate(this, courseList)
                    }
                    appWidgetManager.updateAppWidget(widgetId, views)
                }
            }
        }

        private fun courseDataAllocate(remoteViews: RemoteViews, courseList: List<Course>) {
            val size: Int = courseList.size
            if (courseList.isEmpty()) {
                return CourseWidgetUtil.setNoCourse(remoteViews)
            }

            when (val currentIndex = CourseWidgetUtil.getCurrentCourseIndex(courseList)) {
                (size - 1) -> {
                    CourseWidgetUtil.setNoNextCourse(remoteViews)
                    CourseWidgetUtil.setCurrentView(remoteViews, courseList[currentIndex])
                }
                size -> {
                    CourseWidgetUtil.setAllCourseOver(remoteViews)
                }
                else -> {
                    CourseWidgetUtil.setCurrentView(remoteViews, courseList[currentIndex])
                    CourseWidgetUtil.setNextCourse(remoteViews, courseList[currentIndex + 1])
                }
            }
        }
    }

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        val myAppWidgetManager = AppWidgetManager.getInstance(MyApplication.context)
        val myAppWidgetIds = myAppWidgetManager.getAppWidgetIds(
            ComponentName(
                MyApplication.context,
                CourseWidgetProvider::class.java
            )
        )
        updateAppWidget(MyApplication.context, myAppWidgetManager, myAppWidgetIds)
        val intent = Intent(context, CourseWidgetProvider::class.java)
        intent.action = AppWidgetManager.ACTION_APPWIDGET_UPDATE
        val ids: IntArray = AppWidgetManager.getInstance(context.applicationContext)
            .getAppWidgetIds(ComponentName(context, javaClass))
        intent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, ids)
        val pending = PendingIntent.getBroadcast(context, 0, intent, 0)
        val alarm: AlarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        alarm.setExact(AlarmManager.RTC, System.currentTimeMillis(), pending)
    }

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        val myAppWidgetManager = AppWidgetManager.getInstance(MyApplication.context)
        val myAppWidgetIds = myAppWidgetManager.getAppWidgetIds(
            ComponentName(
                MyApplication.context,
                CourseWidgetProvider::class.java
            )
        )
        updateAppWidget(MyApplication.context, myAppWidgetManager, myAppWidgetIds)
        val intent = Intent(context, CourseWidgetProvider::class.java)
        intent.action = AppWidgetManager.ACTION_APPWIDGET_UPDATE
        val ids: IntArray = AppWidgetManager.getInstance(context.applicationContext)
            .getAppWidgetIds(ComponentName(context, javaClass))
        intent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, ids)
        val pending = PendingIntent.getBroadcast(context, 0, intent, 0)
        val alarm: AlarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        alarm.setExact(AlarmManager.RTC, System.currentTimeMillis(), pending)
    }

    override fun onEnabled(context: Context) {
        super.onEnabled(context)
        val appWidgetManager = AppWidgetManager.getInstance(MyApplication.context)
        val appWidgetIds = appWidgetManager.getAppWidgetIds(
            ComponentName(
                MyApplication.context,
                CourseWidgetProvider::class.java
            )
        )
        updateAppWidget(MyApplication.context, appWidgetManager, appWidgetIds)
    }

}