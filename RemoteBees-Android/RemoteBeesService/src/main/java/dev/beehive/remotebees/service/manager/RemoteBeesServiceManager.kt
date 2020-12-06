/***************************************************************************
 * This source file is part of the RemoteBees open source project.         *
 *                                                                         *
 * Licensed under the MIT License. See LICENSE for license information     *
 ***************************************************************************/

package dev.beehive.remotebees.service.manager

import dev.beehive.remotebees.service.api.BeehiveService
import dev.beehive.remotebees.service.api.manager.ServiceManager
import dev.beehive.remotebees.service.internal.RemotiveBeehiveService
import dev.beehive.remotebees.service.internal.couchbase.CouchbaseLiteDb
import java.lang.IllegalArgumentException

class RemoteBeesServiceManager(private val configuration: RemoteBeesServiceConfiguration): ServiceManager {
    private var couchbaseDb: CouchbaseLiteDb? = null

    init {
        val context = this.configuration.context.get() ?: throw IllegalArgumentException("Context is null")
        this.couchbaseDb = CouchbaseLiteDb(context, "RemoteBees", this.configuration.localeIdentifier)
    }

    override val beehiveService: BeehiveService
        get() = RemotiveBeehiveService(
                    config = this.configuration.remotive(),
                    couchbaseDb = this.couchbaseDb
                )
}
