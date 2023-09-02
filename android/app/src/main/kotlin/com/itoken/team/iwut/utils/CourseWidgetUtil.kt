package com.itoken.team.iwut.utils

import android.view.View
import android.widget.RemoteViews
import com.itoken.team.iwut.MyApplication
import com.itoken.team.iwut.R
import com.itoken.team.iwut.model.Course

object CourseWidgetUtil {

    // 返回当前课程在列表中的index
    fun getCurrentCourseIndex(courseList: List<Course>): Int {
        for (i in courseList.indices) {
            if (courseList[i].isEnd) continue
            // 没有开始的，或者正在进行的
            return i
        }
        // 所有的都结束了，就返回size
        return courseList.size
    }

    fun setAllCourseOver(remoteViews: RemoteViews){
        remoteViews.setViewVisibility(R.id.widgetDate,View.GONE)
        remoteViews.setViewVisibility(R.id.splitLine,View.INVISIBLE)
        remoteViews.setViewVisibility(R.id.currentCourse,View.INVISIBLE)
        remoteViews.setViewVisibility(R.id.nextCourse,View.INVISIBLE)
        remoteViews.setTextViewText(R.id.noCourseText,MyApplication.context.resources.getString(R.string.noNextCourse))
        remoteViews.setViewVisibility(R.id.noCourse, View.VISIBLE)
    }

    fun setNoCourse(remoteViews: RemoteViews){
        remoteViews.setViewVisibility(R.id.widgetDate,View.GONE)
        remoteViews.setViewVisibility(R.id.splitLine,View.INVISIBLE);
        remoteViews.setViewVisibility(R.id.currentCourse,View.INVISIBLE)
        remoteViews.setViewVisibility(R.id.nextCourse,View.INVISIBLE)
        remoteViews.setTextViewText(R.id.noCourseText, MyApplication.context.resources.getString(R.string.noCourse))
        remoteViews.setViewVisibility(R.id.noCourse, View.VISIBLE)
    }

    fun setCurrentView(remoteViews: RemoteViews, course: Course) {
        if(course.hasMulti){
            remoteViews.setTextViewText(R.id.currentCourseMultiSectionStart, course.sectionStartString)
            remoteViews.setTextViewText(R.id.currentCourseMultiSectionEnd, course.sectionEndString)
            remoteViews.setViewVisibility(R.id.currentCourseMulti, View.VISIBLE)
            remoteViews.setViewVisibility(R.id.currentCourseSingle, View.GONE)
        }else{
            remoteViews.setTextViewText(R.id.currentCourseSingleSection, course.sectionStartString)
            remoteViews.setViewVisibility(R.id.currentCourseSingle, View.VISIBLE)
            remoteViews.setViewVisibility(R.id.currentCourseMulti, View.GONE)
        }
        remoteViews.setTextViewText(R.id.currentCourseName, course.name)
        remoteViews.setTextViewText(R.id.currentCourseRoom, course.room)
        remoteViews.setTextViewText(R.id.currentCourseTime, course.time)
        remoteViews.setViewVisibility(R.id.widgetDate,View.VISIBLE)
        remoteViews.setViewVisibility(R.id.currentCourse, View.VISIBLE)
        remoteViews.setViewVisibility(R.id.splitLine,View.INVISIBLE)
        remoteViews.setViewVisibility(R.id.noCourse,View.INVISIBLE)
    }

    fun setNoNextCourse(remoteViews: RemoteViews) {
        remoteViews.setViewVisibility(R.id.splitLine,View.INVISIBLE)
        remoteViews.setViewVisibility(R.id.nextCourse, View.INVISIBLE)
    }

    //setNextCourse()应在setCurrentView()后调用
    //否则splitLine将无法显现
    fun setNextCourse(remoteViews: RemoteViews, course: Course) {
        if(course.hasMulti){
            remoteViews.setTextViewText(R.id.nextCourseMultiSectionStart, course.sectionStartString)
            remoteViews.setTextViewText(R.id.nextCourseMultiSectionEnd, course.sectionEndString)
            remoteViews.setViewVisibility(R.id.nextCourseMulti, View.VISIBLE)
            remoteViews.setViewVisibility(R.id.nextCourseSingle, View.GONE)
        }else{
            remoteViews.setTextViewText(R.id.nextCourseSingleSection, course.sectionStartString)
            remoteViews.setViewVisibility(R.id.nextCourseSingle, View.VISIBLE)
            remoteViews.setViewVisibility(R.id.nextCourseMulti, View.GONE)
        }
        remoteViews.setTextViewText(R.id.nextCourseName, course.name)
        remoteViews.setTextViewText(R.id.nextCourseRoom, course.room)
        remoteViews.setTextViewText(R.id.nextCourseTime, course.time)
        remoteViews.setViewVisibility(R.id.splitLine,View.VISIBLE)
        remoteViews.setViewVisibility(R.id.nextCourse, View.VISIBLE)
    }
}