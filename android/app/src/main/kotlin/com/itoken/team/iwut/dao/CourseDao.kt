package com.itoken.team.iwut.dao

import androidx.room.Dao
import androidx.room.Query
import com.itoken.team.iwut.model.Course

@Dao
interface CourseDao {

    @Query("SELECT * FROM Course")
    fun findAllCourses(): List<Course>

    @Query("SELECT * FROM Course WHERE weekDay=:weekDayNumber AND weekStart<=:weekIndex AND weekEnd>=:weekIndex ORDER BY sectionStart")
    fun findTodayCourses(weekDayNumber: Int, weekIndex: Int): List<Course>
}