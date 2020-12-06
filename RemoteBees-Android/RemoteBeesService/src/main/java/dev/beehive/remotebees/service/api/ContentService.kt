/***************************************************************************
 * This source file is part of the RemoteBees open source project.         *
 *                                                                         *
 * Licensed under the MIT License. See LICENSE for license information     *
 ***************************************************************************/

package dev.beehive.remotebees.service.api

import android.graphics.Bitmap
import com.inmotionsoftware.promisekt.Promise
import java.net.URL

interface ContentService {

    fun getContent(url: URL): Promise<ByteArray?>

    fun getImage(url: URL): Promise<Bitmap?>

}
