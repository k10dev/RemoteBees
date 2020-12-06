/***************************************************************************
 * This source file is part of the RemoteBees open source project.         *
 *                                                                         *
 * Licensed under the MIT License. See LICENSE for license information     *
 ***************************************************************************/

package dev.beehive.remotebees.service.internal.couchbase

import com.inmotionsoftware.httpservice.coder.EncoderException
import com.inmotionsoftware.httpservice.coder.URIJsonAdapter
import com.inmotionsoftware.httpservice.coder.URLJsonAdapter
import com.inmotionsoftware.httpservice.coder.UUIDJsonAdapter
import com.squareup.moshi.JsonAdapter
import com.squareup.moshi.Moshi
import com.squareup.moshi.adapters.Rfc3339DateJsonAdapter
import com.squareup.moshi.kotlin.reflect.KotlinJsonAdapterFactory
import java.util.*

class DictionaryEncoder {

    private val moshi: Moshi

    init {
        val builder = Moshi.Builder()
        builder.add(KotlinJsonAdapterFactory())
            .add(Date::class.java, Rfc3339DateJsonAdapter().nullSafe())
            .add(UUIDJsonAdapter())
            .add(URLJsonAdapter())
            .add(URIJsonAdapter())
        this.moshi = builder.build()
    }

    @Throws(EncoderException::class)
    fun <T:Any> encode(value: T): Map<String, Any>? {
        val adapter: JsonAdapter<T> = this.moshi.adapter(value.javaClass)
        return adapter.toJsonValue(value) as? Map<String, Any>
    }

}
