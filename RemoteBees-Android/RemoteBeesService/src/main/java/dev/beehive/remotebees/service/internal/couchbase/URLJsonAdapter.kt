package dev.beehive.remotebees.service.internal.couchbase

import com.squareup.moshi.*
import java.net.URL

class URLJsonAdapter {
    @FromJson
    fun fromJson(uri: String?): URL? {
        return uri?.let { URL(it) }
    }
    @ToJson
    fun toJson(value: URL?): String? {
        return value?.toString()
    }
}