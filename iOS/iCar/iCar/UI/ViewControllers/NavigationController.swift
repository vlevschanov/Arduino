//
//  NavigationController.swift
//  iCar
//
//  Created by Viktor Levshchanov on 4/17/17.
//  Copyright © 2017 Viktor Levshchanov. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    override var shouldAutorotate: Bool {
        return (topViewController?.shouldAutorotate)!
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return (topViewController?.supportedInterfaceOrientations)!
    }

}
