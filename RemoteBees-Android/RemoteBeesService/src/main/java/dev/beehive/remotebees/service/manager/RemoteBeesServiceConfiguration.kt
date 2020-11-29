package dev.beehive.remotebees.service.manager

import android.content.Context
import com.inmotionsoftware.httpservice.HTTPService
import com.inmotionsoftware.httpservice.HTTPServiceConsoleLogger
import com.inmotionsoftware.httpservice.HTTPServiceLogger
import com.inmotionsoftware.httpservice.TimeInterval
import com.inmotionsoftware.httpservice.cache.CacheStore
import com.inmotionsoftware.httpservice.cache.MemDiskLruCacheStore
import dev.beehive.remotebees.service.BuildConfig
import java.lang.ref.WeakReference
import java.net.URL

enum class RemoteBeesServiceEnvironment {
    Development,
    Staging,
    Production
    ;

    val remotiveUrl: URL
        get() = when (this) {
            Development, Staging, Production -> URL("https://remotive.io/")
        }
}

data class RemoteBeesServiceConfiguration(
    val context: WeakReference<Context>,
    val environment: RemoteBeesServiceEnvironment,
    val localeIdentifier: String,
    val requestTimeoutInterval: TimeInterval = 15,
    val enableHttpLogging: Boolean = BuildConfig.DEBUG,
    val logger: HTTPServiceLogger? = HTTPServiceConsoleLogger
)

// Extension

internal fun RemoteBeesServiceConfiguration.content(): HTTPService.Config {
    var httpServiceConfig = HTTPService.Config(baseUrl = null)

    val headers = HashMap<String, String>()
    headers["Cache-Control"] = "no-cache"
    httpServiceConfig.headers = headers

    httpServiceConfig.cacheStore = this.context.get()?.let(this::cacheStore)
    httpServiceConfig.requestTimeoutInterval = this.requestTimeoutInterval
    return httpServiceConfig
}

internal fun RemoteBeesServiceConfiguration.remotive(): HTTPService.Config {
    val httpServiceConfig =
        HTTPService.Config(baseUrl = URL("${this.environment.remotiveUrl}"))

    val headers = HashMap<String, String>()
    headers["Accept-Language"] = this.localeIdentifier
    headers["Cache-Control"] = "no-cache"
    httpServiceConfig.headers = headers

    httpServiceConfig.cacheStore = this.context.get()?.let(this::cacheStore)
    httpServiceConfig.isAlwaysTrustHost = BuildConfig.DEBUG
    httpServiceConfig.enableHttpLogging = if (BuildConfig.DEBUG) this.enableHttpLogging else false
    httpServiceConfig.requestTimeoutInterval = this.requestTimeoutInterval
    httpServiceConfig.logger = this.logger

    return httpServiceConfig
}

private fun RemoteBeesServiceConfiguration.cacheStore(context: Context): CacheStore {
    val cacheDir = context.cacheDir
    val diskCacheSize = 50 * 1024 * 1024
    val memCacheSize = 2 * 1024 * 1024
    return MemDiskLruCacheStore(cacheDir, diskCacheSize.toLong(), memCacheSize)
}
