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
        instagramLogin = InstagramLoginViewController(clientId: InstagramIDS.INSTAGRAM_CLIENT_ID, redirectUri: InstagramIDS.INSTAGRAM_REDIRECT_URI)
        instagramLogin.delegate = self
        instagramLogin.scopes = [.all]
        
        instagramLogin.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(dismissLoginViewController))
        instagramLogin.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshPage))
        present(UINavigationController(rootViewController: instagramLogin), animated: true, completion: nil)
  
    }
    func showAlertView(title: String, message: String) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        present(alertView, animated: true)
    }
    
    @objc func dismissLoginViewController() {
        instagramLogin.dismiss(animated: true)
    }
    
    @objc func refreshPage() {
        instagramLogin.reloadPage()
    }
    
    
}

extension AuthVC: InstagramLoginViewControllerDelegate {
    func instagramLoginDidFinish(accessToken: String?, error: InstagramError?) {
        dismissLoginViewController()
        
        if accessToken != nil {
            guard let token = accessToken else { return }
             
            
            
            Alamofire.request("https://api.instagram.com/v1/users/self/?access_token=\(token)", method: .get).responseJSON { response in
                switch response.result {
                case .success(let value):
                    print(value)
                    
                    guard let json = response.result.value as? [String: Any] else { return }
                    
                    guard let data = json["data"] as? [String: Any] else { return }
                    
                    guard let id = data["id"] as? String else { return }
                    
                    guard let userName = data["username"] as? String else { return }
                    
                    print(id)
                    print(userName)
                    

                    
                    AuthServise.instance.loginInstagramUser(withCustomToken: token, loginComplete: { [weak self] (success, loginError) in
                        if success {
                            self?.dismiss(animated: true, completion: nil)
                        } else {
                            print(String(describing: loginError?.localizedDescription))
                        }
                    })

                case .failure(let error):
                    print(error)
                }
            }
        } else {
            showAlertView(title: "\(error!.localizedDescription) 👎", message: "")
        }
        
        
        
    }
    
    
}
