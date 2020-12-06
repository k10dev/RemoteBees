/***************************************************************************
 * This source file is part of the RemoteBees open source project.         *
 *                                                                         *
 * Licensed under the MIT License. See LICENSE for license information     *
 ***************************************************************************/

package dev.beehive.remotebees.service.internal.couchbase

import android.content.Context
import com.couchbase.lite.CouchbaseLite
import com.couchbase.lite.Database
import com.couchbase.lite.DatabaseConfiguration
import com.couchbase.lite.MutableDocument

class CouchbaseLiteDb(
    private val context: Context
    , private val name: String
    , private val localeIdentifier: String
) {
    private data class PreferencesDocument(
        val localeIdentifier: String
    )

    val database: Database

    init {
        CouchbaseLite.init(this.context)
        this.database = Database(name, DatabaseConfiguration())

        val prefs: PreferencesDocument = this.getPreferences() ?: {
            val newPrefs = PreferencesDocument(localeIdentifier = this.localeIdentifier)
                this.savePreferences(newPrefs)
                newPrefs
        }()

        if (this.localeIdentifier != prefs.localeIdentifier) {
            this.clearUserDocuments()
            this.savePreferences(PreferencesDocument(localeIdentifier = localeIdentifier))
        }
    }

    @Throws
    fun clearUserDocuments() {
        this.database.inBatch {
    //        this.getDocument("<DocumentName>")?.let(this::delete)
            // Add more later
        }
    }

    @Throws
    private fun savePreferences(prefs: PreferencesDocument) {
        val data = DictionaryEncoder().encode(prefs) ?: return
        val document = MutableDocument("PreferencesDocument", data)
        this.database.save(document)
    }

    @Throws
    private fun getPreferences(): PreferencesDocument? {
        val document = this.database.getDocument("PreferencesDocument") ?: return null
        val data = document.toMap()
        return DictionaryDecoder().decode(type = PreferencesDocument::class.java, value = data)
    }

}
