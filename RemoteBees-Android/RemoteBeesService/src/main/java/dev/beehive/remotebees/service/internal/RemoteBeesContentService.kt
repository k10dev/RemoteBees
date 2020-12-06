/***************************************************************************
 * This source file is part of the RemoteBees open source project.         *
 *                                                                         *
 * Licensed under the MIT License. See LICENSE for license information     *
 ***************************************************************************/

package dev.beehive.remotebees.service.internal

import android.graphics.Bitmap
import android.graphics.BitmapFactory
import com.inmotionsoftware.httpservice.HTTPService
import com.inmotionsoftware.httpservice.cache.CacheAge
import com.inmotionsoftware.httpservice.cache.CacheCriteria
import com.inmotionsoftware.httpservice.cache.CachePolicy
import com.inmotionsoftware.httpservice.concurrent.DispatchExecutor
import com.inmotionsoftware.httpservice.get
import com.inmotionsoftware.promisekt.Promise
import com.inmotionsoftware.promisekt.map
import dev.beehive.remotebees.service.api.ContentService
import java.net.URL

internal class RemoteBeesContentService(config: Config)
    : HTTPService(config = config)
    , ContentService
{

    override fun getContent(url: URL): Promise<ByteArray?> {
        val criteria = CacheCriteria(policy=CachePolicy.useAge, age= CacheAge.immortal.interval)
        val p: Promise<Result?> = this.get(route=url.toString(), cacheCriteria=criteria)
        return p.map { result -> result?.body }
    }

    override fun getImage(url: URL): Promise<Bitmap?> {
        return this.getContent(url = url)
                    .map(on = DispatchExecutor.global) {
                        val data = it ?: return@map null
                        BitmapFactory.decodeByteArray(data, 0, data.size)
                    }
    }

}
