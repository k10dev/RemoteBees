/***************************************************************************
 * This source file is part of the RemoteBees open source project.         *
 *                                                                         *
 * Licensed under the MIT License. See LICENSE for license information     *
 ***************************************************************************/

import UIKit

extension UIViewController {
    class func fromStoryboard<T: UIViewController>(_ name: String) -> T {
        return UIStoryboard.makeViewController(fromStoryboard: name)
    }
}
