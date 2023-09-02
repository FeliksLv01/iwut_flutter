package com.itoken.team.iwut.utils

import android.content.Context
import com.itoken.team.iwut.MyApplication
import com.itoken.team.iwut.dao.AppDatabase
import com.itoken.team.iwut.model.Course
import org.joda.time.DateTime
import org.joda.time.Days
import org.joda.time.format.DateTimeFormat
import java.text.SimpleDateFormat
import java.util.*
import kotlin.collections.ArrayList
import kotlin.math.max
import kotlin.math.min

object CourseUtil {
    /***
     * @description: 返回今天是星期几
     * @return
     */
    val weekDay: String
        get() {
            val date = Date()
            val dateFm = SimpleDateFormat("EEEE", Locale.CHINA)
            return dateFm.format(date)
        }

    private val weekDayNumber: Int
        get() {
            val date = Date()
            val dateFm = SimpleDateFormat("u", Locale.CHINA)
            return dateFm.format(date).toInt()
        }

    /***
     * 获取这周是第几周
     * @return
     */
    val weekIndex: Int
        get() {
            val SHARED_PREFERENCES_NAME = "FlutterSharedPreferences"
            val sp =MyApplication.context.getSharedPreferences(SHARED_PREFERENCES_NAME, Context.MODE_PRIVATE)
            val termStart: String? = sp.getString("flutter.termStart", "")
            val now = DateTime.now()
            val start = DateTime.parse(termStart, DateTimeFormat.forPattern("yyyy-MM-dd HH:mm:ss.sss"))
            val days = Days.daysBetween(start, now).days
            var weekIndex: Int
            if (days < 0) weekIndex = 1 else {
                weekIndex = 1 + days / 7
                if (weekIndex > 20) weekIndex = 20
            }
            return weekIndex
        }

    /***
     * @description: 返回今天课表
     * @return
     */
    fun getTodayCourses(): List<Course> {
        val courseDao=AppDatabase.getDataBase(MyApplication.context).courseDao()
        val courses = courseDao.findTodayCourses(weekDayNumber, weekIndex) as ArrayList<Course>
        if (courses.size==0)return courses
        // 剔除冲突课程（暂时性处理）
        val nonConflictCourses = ArrayList<Course>()
        for(i in courses.size - 1 downTo 0){
            var isNonConflict = true
            for(j in i - 1 downTo 0){
                if(max(courses[i].sectionStart!!,courses[j].sectionStart!!) <= min(courses[i].sectionEnd!!,courses[j].sectionEnd!!))
                {
                    isNonConflict = false
                    break
                }
            }
            if(isNonConflict) nonConflictCourses.add(courses[i])
        }
        return nonConflictCourses.asReversed()
    }

}