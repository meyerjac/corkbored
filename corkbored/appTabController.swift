//
//  appTabController.swift
//  corkbored
//
//  Created by Jackson Meyer on 2/8/18.
//  Copyright © 2018 Jackson Meyer. All rights reserved.
//

import UIKit

class appTabController: UITabBarController {

    @IBOutlet var splashScreen: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        launchSplashScreen()
        delay()
    }
    
    func launchSplashScreen() {
        splashScreen.bounds.size.width = view.bounds.width
        splashScreen.bounds.size.height = view.bounds.height
        splashScreen.center = view.center
        
        view.addSubview(splashScreen)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func delay() {
        let when = DispatchTime.now() + 5 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            // Your code with delay
            
            self.splashScreen.alpha = 0
            
        }
    }
}
