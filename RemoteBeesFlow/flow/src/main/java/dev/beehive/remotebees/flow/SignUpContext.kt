/***************************************************************************
 * This source file is part of the RemoteBees open source project.         *
 *                                                                         *
 * Licensed under the MIT License. See LICENSE for license information     *
 ***************************************************************************/

package dev.beehive.remotebees.flow

import android.os.Parcelable
import kotlinx.android.parcel.Parcelize

@Parcelize
data class SignUpContext (
    val firstName: String,
    val lastName: String,
    val email: String,
    val password: String
): Parcelable
