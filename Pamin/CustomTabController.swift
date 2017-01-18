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
    
    var indiceTela: Int = 0
    var filtro: Int = 0
    
    override func viewDidLoad() {
        self.selectedIndex = indiceTela
    }
}
