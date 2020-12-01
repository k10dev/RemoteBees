package dev.beehive.remotebees.app

import android.app.Application
import android.os.Handler
import android.os.Looper
import androidx.core.os.ConfigurationCompat
import com.inmotionsoftware.logging.LogHandler
import com.inmotionsoftware.logging.LoggingSystem
import com.inmotionsoftware.logging.MultiplexLogHandler
import com.inmotionsoftware.logging.android.AndroidLogcatHandler
import com.inmotionsoftware.promisekt.PMKConfiguration
import com.inmotionsoftware.promisekt.Promise
import dev.beehive.remotebees.BuildConfig
import dev.beehive.remotebees.service.api.manager.ServiceManager
import dev.beehive.remotebees.service.manager.RemoteBeesServiceConfiguration
import dev.beehive.remotebees.service.manager.RemoteBeesServiceEnvironment
import dev.beehive.remotebees.service.manager.RemoteBeesServiceManager
import java.lang.ref.WeakReference
import java.util.*
import java.util.concurrent.Executor

open class AppProxy : Application() {

    companion object {
        lateinit var proxy: AppProxy
    }

    lateinit var serviceManager: ServiceManager
        private set

    lateinit var preferences: AppPreferences
        private set

    private val currentLocale: Locale
        get() {
            val locales = ConfigurationCompat.getLocales(resources.configuration)
            return if (locales.isEmpty) Locale.getDefault() else locales[0]
        }

    override fun onCreate() {
        super.onCreate()
        proxy = this

        // Setup main thread executor for PromiseKt
        val main = Executor { command -> Handler(Looper.getMainLooper()).post(command) }
        PMKConfiguration.Q = PMKConfiguration.Value(map = main, `return` = main)

        this.preferences = AppPreferences(context = this)

        // Setup KotlinLog factory
        LoggingSystem.bootstrap { label ->
            val handlers = mutableListOf<LogHandler>()

            if (BuildConfig.DEBUG) {
                handlers.add(AndroidLogcatHandler(label, AndroidLogcatHandler.MetadataContentType.Public))
            } else {
                handlers.add(AndroidLogcatHandler(label, AndroidLogcatHandler.MetadataContentType.Private))
            }

            MultiplexLogHandler(handlers)
        }

    }

    fun initialize(): Promise<Unit> {
        val serviceConfiguration =
            RemoteBeesServiceConfiguration(
                context = WeakReference(this.applicationContext),
                environment = RemoteBeesServiceEnvironment.Development,
                localeIdentifier = this.currentLocale.identifier
            )

        this.serviceManager = RemoteBeesServiceManager(configuration = serviceConfiguration)
        return Promise.value(Unit)
    }

}

///
/// Locale+Extension
///
val Locale.identifier: String
    get() { return this.toString() }