package dev.beehive.remotebees.service.manager

import dev.beehive.remotebees.service.api.BeehiveService
import dev.beehive.remotebees.service.api.manager.ServiceManager
import dev.beehive.remotebees.service.internal.RemotiveBeehiveService
import dev.beehive.remotebees.service.internal.couchbase.CouchbaseLiteDb

class RemoteBeesServiceManager(private val configuration: RemoteBeesServiceConfiguration): ServiceManager {
    private var couchbaseDb: CouchbaseLiteDb? = null

    init {
        this.configuration.context.get()?.let {
            this.couchbaseDb = CouchbaseLiteDb(it, "RemoteBees", this.configuration.localeIdentifier)
        }
    }

    override val beehiveService: BeehiveService
        get() = RemotiveBeehiveService(
                    config = this.configuration.remotive(),
                    couchbaseDb = this.couchbaseDb
                )
}
