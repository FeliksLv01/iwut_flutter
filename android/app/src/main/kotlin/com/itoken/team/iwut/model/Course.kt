package com.itoken.team.iwut.model

import androidx.room.Entity
import androidx.room.PrimaryKey
import com.itoken.team.iwut.common.SectionData
import java.text.SimpleDateFormat
import java.util.*

@Entity
data class Course(
        var name: String?,
        var teacher: String?,
        var room: String?,
        var weekStart:Int?,
        var weekEnd:Int?,
        var sectionStart:Int?,
        var sectionEnd:Int?,
        var weekDay:Int?,
        var boxColor:Int?,
        var priority:Int?) {

    @PrimaryKey(autoGenerate = true)
    var id:Int? = 0

    val time: String
        get() {
            return "${SectionData.getStartTime(sectionStart!!)}-${SectionData.getEndTime(sectionEnd!!)}"
        }

    //获取此门课课一共有几节
    private val sectionCount: Int
        get() = sectionEnd!! - sectionStart!! + 1

    val sectionStartString: String
        get() = SectionData.getStartSection(sectionStart!!)

    val sectionEndString: String
        get() = SectionData.getEndSection(sectionEnd!!)

    //是否有多节大课
    val hasMulti: Boolean
        get() = sectionCount > 1

    // 课有没有上完
    val isEnd: Boolean
        get() {
            val df = SimpleDateFormat("HH:mm", Locale.CHINA)
            val dt1 = df.parse(SectionData.getEndTime(sectionEnd!!))
            val c = Calendar.getInstance(Locale.CHINA)
            val dt2 = df.parse("${c.get(Calendar.HOUR_OF_DAY)}:${c.get(Calendar.MINUTE)}")
            if (dt2!!.time > dt1!!.time)//比较时间大小,dt1小于dt2
            {
                return true
            }
            return false
        }
}