/***************************************************************************
 * This source file is part of the RemoteBees open source project.         *
 *                                                                         *
 * Licensed under the MIT License. See LICENSE for license information     *
 ***************************************************************************/

package dev.beehive.remotebees.flow

import android.os.Parcelable
import kotlinx.android.parcel.Parcelize
import java.util.*

@Parcelize
data class JobItem (
    val id: Int,
    val url: String,
    val title: String,
    val companyName: String,
    val category: String,
    val publicationDate: String,
    val salary : String
): Parcelable
