/***************************************************************************
 * This source file is part of the RemoteBees open source project.         *
 *                                                                         *
 * Licensed under the MIT License. See LICENSE for license information     *
 ***************************************************************************/

public protocol ServiceManager {
    
    var beehiveService: BeehiveService { get }

    var contentService: ContentService { get }

}
