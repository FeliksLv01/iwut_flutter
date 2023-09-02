package com.itoken.team.iwut.dao

import android.content.Context
import androidx.room.Database
import androidx.room.Room
import androidx.room.RoomDatabase
import com.itoken.team.iwut.model.Course

@Database(version = 1, entities = [Course::class])
abstract class AppDatabase : RoomDatabase() {

    abstract fun courseDao(): CourseDao

    companion object {
        private var instance: AppDatabase? = null

        fun getDataBase(context: Context): AppDatabase {
            instance?.let { return it }
            return Room.databaseBuilder(
                    context.applicationContext,
                    AppDatabase::class.java, "iwhut.db")
                    .setJournalMode(JournalMode.TRUNCATE)
                    .build().apply { instance = this }
        }
    }

}