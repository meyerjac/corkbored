//
//  appTabController.swift
//  corkbored
//
//  Created by Jackson Meyer on 2/8/18.
//  Copyright © 2018 Jackson Meyer. All rights reserved.
//

import UIKit

class appTabController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBar.barTintColor = UIColor(red: 66/255, green: 165/255, blue: 245/255, alpha:1.0)
        
        let tabBarFrame = CGRect(x: self.tabBar.frame.origin.x, y: self.tabBar.frame.origin.y, width: self.view.frame.width - 100, height: self.tabBar.frame.height)
        self.tabBar.frame = tabBarFrame
        self.tabBar.isTranslucent = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
