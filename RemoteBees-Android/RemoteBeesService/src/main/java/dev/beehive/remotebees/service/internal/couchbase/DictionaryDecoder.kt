package dev.beehive.remotebees.service.internal.couchbase

import com.inmotionsoftware.httpservice.coder.DecoderException
import com.inmotionsoftware.httpservice.coder.URIJsonAdapter
import com.inmotionsoftware.httpservice.coder.URLJsonAdapter
import com.inmotionsoftware.httpservice.coder.UUIDJsonAdapter
import com.squareup.moshi.JsonAdapter
import com.squareup.moshi.Moshi
import com.squareup.moshi.adapters.Rfc3339DateJsonAdapter
import com.squareup.moshi.kotlin.reflect.KotlinJsonAdapterFactory
import java.lang.reflect.Type
import java.util.*

class DictionaryDecoder {

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

    @Throws(DecoderException::class)
    fun <T> decode(type: Class<T>, value: Map<String, Any>): T? {
        val adapter: JsonAdapter<T> = this.moshi.adapter(type)
        return adapter.fromJsonValue(value)
    }

    @Throws(DecoderException::class)
    fun <T> decode(type: Type, value: Map<String, Any>): T? {
        val adapters = this.moshi.adapter<T>(type)
        return adapters.fromJsonValue(value)
    }

    @Throws(DecoderException::class)
    inline fun <reified T> decode(value: Map<String, Any>): T? = this.decode(type = T::class.java, value = value)

}
