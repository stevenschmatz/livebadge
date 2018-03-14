//
//  RootViewController.swift
//  SXSW
//
//  Created by Steven Schmatz on 3/14/18.
//  Copyright © 2018 Stuart Olivera. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
    
    let scrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(scrollView)
        scrollView.frame = self.view.frame
        
        // Do any additional setup after loading the view, typically from a nib.
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let aViewController = storyboard.instantiateViewController(withIdentifier: "Camera")
        let bViewController = storyboard.instantiateViewController(withIdentifier: "Items")
        
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        
        let bounds = UIScreen.main.bounds
        let width = bounds.size.width
        let height = bounds.size.height;
        
        scrollView.contentSize = CGSize(width: 2*width, height: height)
        
        let viewControllers = [aViewController, bViewController]
        
        var idx:Int = 0;
        
        for viewController in viewControllers {
            // index is the index within the array
            // participant is the real object contained in the array
            addChildViewController(viewController);
            scrollView.addSubview(viewController.view)
            
            viewController.view.pinToLeftEdgeOfSuperview(withOffset: CGFloat(idx) * width)
            viewController.view.pinToTopEdgeOfSuperview()
            viewController.view.size(toWidth: width)
            viewController.view.size(toHeight: height)
            viewController.didMove(toParentViewController: self)
            
            idx = idx + 1
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
