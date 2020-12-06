/***************************************************************************
 * This source file is part of the RemoteBees open source project.         *
 *                                                                         *
 * Licensed under the MIT License. See LICENSE for license information     *
 ***************************************************************************/

package dev.beehive.remotebees.service.api.manager

import dev.beehive.remotebees.service.api.BeehiveService

interface ServiceManager {

    val beehiveService: BeehiveService

}
