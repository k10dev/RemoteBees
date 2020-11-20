//
//  SplashScreenViewController.swift
//  RemoteBees
//

import UIKit

class SplashScreenViewController: UIViewController {
    
    class func instantiate() -> SplashScreenViewController {
        return SplashScreenViewController.fromStoryboard("Main")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
