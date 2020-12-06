/***************************************************************************
 * This source file is part of the RemoteBees open source project.         *
 *                                                                         *
 * Licensed under the MIT License. See LICENSE for license information     *
 ***************************************************************************/

import UIKit
import SwiftUI

extension UIColor {

    static var beehiveBrand: UIColor {
        return UIColor(red: 244.0/255.0, green: 178.0/255.0, blue: 70.0/255.0, alpha: 1.0)
    }

    static var lightGrey: UIColor {
        return UIColor(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, alpha: 1.0)
    }
}

extension Color {
    
    static var beehiveBrand: Color {
        return Color(UIColor.beehiveBrand)
    }

    static var lightGrey: Color {
        return Color(UIColor.lightGrey)
    }

}
