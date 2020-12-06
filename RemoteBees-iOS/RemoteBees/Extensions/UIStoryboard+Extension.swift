/***************************************************************************
 * This source file is part of the RemoteBees open source project.         *
 *                                                                         *
 * Licensed under the MIT License. See LICENSE for license information     *
 ***************************************************************************/

import UIKit

extension UIStoryboard {
    class func makeViewController<T: UIViewController>(fromStoryboard name: String = "Main") -> T {
        let storyboard: UIStoryboard = UIStoryboard(name: name, bundle: nil)
        let id = String(describing: T.self)
        return storyboard.instantiateViewController(withIdentifier: id) as! T
    }

    class func makeInitialViewController<T: UIViewController>(fromStoryboard name: String = "Main") -> T {
        let storyboard: UIStoryboard = UIStoryboard(name: name, bundle: nil)
        return storyboard.instantiateInitialViewController() as! T
    }
}
