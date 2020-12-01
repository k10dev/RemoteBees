package dev.beehive.remotebees.app

import android.content.Context
import android.content.SharedPreferences

class AppPreferences(context: Context) {
    companion object {
        private const val KEY_FIRST_TIME_USED = "FIRST_TIME_USED"
    }

    private val preferences: SharedPreferences = context.getSharedPreferences("RemoteBeesPreferences", Context.MODE_PRIVATE)

    var firstTimeUsed: Boolean
        get() {
            return this.preferences.getBoolean(KEY_FIRST_TIME_USED, true)
        }
        set(value) {
            val editor = this.preferences.edit()
            editor.putBoolean(KEY_FIRST_TIME_USED, value)
            editor.apply()
        }
}
