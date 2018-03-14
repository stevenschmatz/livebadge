//
//  ItemViewController.swift
//  SXSW
//
//  Created by Stuart Olivera on 3/13/18.
//  Copyright © 2018 Stuart Olivera. All rights reserved.
//

import UIKit

class ItemViewController : UIViewController {
    @IBAction func done(_ sender: Any) {
        self.dismiss(animated: true)
        (UIApplication.shared.keyWindow?.rootViewController as! RootViewController).scrollView.setContentOffset(CGPoint(x:0, y:0), animated: true)
    }

    override func viewDidLoad() {
    }
}
