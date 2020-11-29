package dev.beehive.remotebees.flow

import android.os.Parcelable
import com.inmotionsoftware.promisekt.Promise

interface AsyncJobItems: Parcelable {
    fun jobItems(): Promise<List<JobItem>>
}
