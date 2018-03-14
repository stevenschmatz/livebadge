//
//  AViewController.swift
//  CustomScrollContainer
//
//  Created by Yan Saraev on 6/21/15.
//  Copyright (c) 2015 nt. All rights reserved.
//

import Foundation
import UIKit

class AViewController: UIViewController {
    override func viewDidLoad() {
        let label = UILabel()
        label.text = "Hello world"
        self.view.addSubview(label)
        label.centerInSuperview()
    }
    
}
