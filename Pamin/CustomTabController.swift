//
//  CustomTabController.swift
//  Pamin
//
//  Created by Pedro Figueirêdo on 19/12/16.
//  Copyright © 2016 Lavid. All rights reserved.
//

import Foundation
import UIKit

class CustomTabController: UITabBarController {
    
    @objc var filtro: Int = 0
    
    override func viewDidLoad() {
        
        if UserDefaults.standard.object(forKey: "telaOrigem") != nil {
            self.selectedIndex = UserDefaults.standard.object(forKey: "telaOrigem") as! Int
        }
    }
}
