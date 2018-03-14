//
//  IntroViewController.swift
//  
//
//  Created by Steven Schmatz on 3/14/18.
//

import UIKit
import Firebase
import FirebaseDatabase
import FBSDKCoreKit
import FBSDKLoginKit

class IntroViewController: UIViewController, FBSDKLoginButtonDelegate {
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "logo"))
        self.view.addSubview(imageView)
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        let loginButton = FBSDKLoginButton()
        self.view.addSubview(loginButton)
        loginButton.removeConstraints(loginButton.constraints)
        loginButton.pinToBottomEdgeOfSuperview(withOffset: 100)
        loginButton.pinToSideEdgesOfSuperview(withOffset: 50)
        loginButton.size(toHeight: 50)
        loginButton.delegate = self
        
        logoImageView.size(toWidthAndHeight: 175)
        logoImageView.centerInSuperview()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        
        self.present(RootViewController(), animated: true, completion: nil)
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        //
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
