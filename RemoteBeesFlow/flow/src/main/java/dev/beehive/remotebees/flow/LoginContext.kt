package dev.beehive.remotebees.flow

import android.os.Parcelable
import kotlinx.android.parcel.Parcelize

@Parcelize
data class LoginContext (
    val email: String,
    val password: String
): Parcelable
