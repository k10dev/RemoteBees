/***************************************************************************
 * This source file is part of the RemoteBees open source project.         *
 *                                                                         *
 * Licensed under the MIT License. See LICENSE for license information     *
 ***************************************************************************/

package dev.beehive.remotebees.flow

import android.os.Parcelable
import com.inmotionsoftware.promisekt.Promise

interface AsyncJobItems: Parcelable {
    fun jobItems(): Promise<List<JobItem>>
}
