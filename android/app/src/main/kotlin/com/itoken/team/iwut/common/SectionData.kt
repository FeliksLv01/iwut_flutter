package com.itoken.team.iwut.common

object SectionData {

    fun getStartTime(section: Int) = when (section) {
        1 -> "08:00"
        3 -> "09:55"
        4 -> "10:45"
        6 -> "14:00"
        7 -> "14:50"
        9 -> "16:45"
        11 -> "19:00"
        12 -> "19:50"
        else -> "00:00"
    }

    fun getEndTime(section: Int) = when (section) {
        2 -> "09:35"
        4 -> "11:30"
        5 -> "12:20"
        7 -> "15:35"
        8 -> "16:25"
        10 -> "18:20"
        12 -> "20:35"
        13 -> "21:25"
        else -> "00:00"
    }

    //获取开始时间对应的是第几大节课
    fun getStartSection(section: Int) = when (section) {
        1 -> "01"
        3 -> "03"
        4 -> "04"
        6 -> "06"
        7 -> "07"
        9 -> "09"
        11 -> "11"
        12 -> "12"
        else -> "00"
    }

    //获取结束时间对应的是第几大节课
    fun getEndSection(section: Int) = when (section) {
        2 -> "02"
        4 -> "04"
        5 -> "05"
        7 -> "07"
        8 -> "08"
        10 -> "10"
        12 -> "12"
        13 -> "13"
        else -> "00"
    }
}