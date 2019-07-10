//
//  AuthVC.swift
//  TaskList
//
//  Created by Дмитрий Ага on 7/6/19.
//  Copyright © 2019 Дмитрий Ага. All rights reserved.
//

import UIKit
import Firebase
//import FacebookCore
//import FacebookLogin
import FBSDKCoreKit
import FBSDKLoginKit
import InstagramLogin
import Alamofire


class AuthVC: UIViewController {

    var instagramLogin: InstagramLoginViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //MARK: - check user is login
        if Auth.auth().currentUser != nil {
            dismiss(animated: true, completion: nil)
        }
    }

    //MARK: - Actions
    //sign in with email and password
    @IBAction func signInWithEmailBtnWasPressed(_ sender: Any) {
        
        guard let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginVC") else { return }
        present(loginVC, animated: true, completion: nil)
    }
    //sign in with facebook
    @IBAction func facebookSignInBtnWasPressed(_ sender: Any) {
        let loginManager = LoginManager()
        
        
        loginManager.logIn(permissions: [ "public_profile", "email" ], from: self) { (loginResult, error) in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            guard let accessToken = AccessToken.current else {
                print("Failed to get access token")
                return
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            
            // Perform login by calling Firebase APIs
            
            AuthServise.instance.loginFacebookUser(withCredential: credential, loginComplete: { [weak self] (success, loginError) in
                if success {
                    self?.dismiss(animated: true, completion: nil)
                } else {
                    print(String(describing: loginError?.localizedDescription))
                }
            })
        }
    }
    //sign in with instagram
    @IBAction func instagramSignInBtnWasPressed(_ sender: Any) {
        
        
        
    }
}
