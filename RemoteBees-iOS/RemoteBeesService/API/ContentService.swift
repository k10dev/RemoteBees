/***************************************************************************
 * This source file is part of the RemoteBees open source project.         *
 *                                                                         *
 * Licensed under the MIT License. See LICENSE for license information     *
 ***************************************************************************/

import UIKit
import PromiseKit

public protocol ContentService {

    func getContent(url: URL) -> Promise<Data?>

    func getImage(url: URL) -> Promise<UIImage?>

}
