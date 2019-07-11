 //
//  AuthService.swift
//  TaskList
//
//  Created by Дмитрий Ага on 7/6/19.
//  Copyright © 2019 Дмитрий Ага. All rights reserved.
//

import Foundation
import Firebase
 
 class AuthServise {
    
    static let instance = AuthServise()
    
    func registerUser(withEmail email: String, andPassword password: String, userCreationComplete: @escaping (_ status: Bool, _ error: Error?) -> ()) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            guard let user = user else {
                userCreationComplete(false, error)
                return
            }
            let userData = ["provider": user.user.providerID, "email": user.user.email]
            DataService.instance.createDBUser(uid: user.user.uid, userData: userData as Dictionary<String, Any>)
            userCreationComplete(true, nil)
        }
        
    }
    
    func loginUser(withEmail email: String, andPassword password: String, loginComplete: @escaping (_ status: Bool, _ error: Error?) -> ()) {
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                loginComplete(false, error)
                return
            }
            loginComplete(true, nil)
        }
    }
    
    func loginFacebookUser(withCredential credential: AuthCredential, loginComplete: @escaping (_ status: Bool, _ error: Error?) -> ()) {
        
        Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil {
                loginComplete(false, error)
                return
            }
            loginComplete(true, nil)
            let userData = ["provider": "Facebook", "email": user!.user.email]
            DataService.instance.createDBUser(uid: user!.user.uid, userData: userData as Dictionary<String, Any>)
        }
        
    }
    
    func loginInstagramUser(withUserName userName: String, andUserID id: String, loginComplete: @escaping (_ status: Bool, _ error: Error?) -> ()) {
        
        let userData = ["provider": "Instagram", "userNmae": userName]
        DataService.instance.createDBUser(uid: id, userData: userData as Dictionary<String, Any>)
        
    }
    
 }

 
 
 
 
 
 
 
 
 
 
 
