//
//  UIViewController+Extension.swift
//  RemoteBees
//

import UIKit

extension UIViewController {
    class func fromStoryboard<T: UIViewController>(_ name: String) -> T {
        return UIStoryboard.makeViewController(fromStoryboard: name)
    }
}
