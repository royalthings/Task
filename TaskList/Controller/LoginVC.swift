//
//  LoginVC.swift
//  TaskList
//
//  Created by Дмитрий Ага on 7/6/19.
//  Copyright © 2019 Дмитрий Ага. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var emailTextField: InsetTextField!
    
    @IBOutlet weak var passwordTextField: InsetTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    //MARK: - Actions
    @IBAction func signInBtnWasPressed(_ sender: Any) {
        //check textfields
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        if email.isEmpty || password.isEmpty {
            alertMassage(message: "Please enter your email and password!")
        }
        //login with email and password
        AuthServise.instance.loginUser(withEmail: email, andPassword: password) { [weak self] (success, loginError) in
            if success {
                self?.dismiss(animated: true, completion: nil)
            } else {
                print(String(describing: loginError?.localizedDescription))
                self?.alertMassage(message: "Please enter your correct email and password!")
            }
            //register new user
            AuthServise.instance.registerUser(withEmail: email, andPassword: password, userCreationComplete: { (success, registrationError) in
                if success {
                    AuthServise.instance.loginUser(withEmail: email, andPassword: password, loginComplete: { (success, nil) in
                        
                    })
                } else {
                    print(String(describing: registrationError?.localizedDescription))
                    self?.alertMassage(message: "Please enter your correct email and password!")
                }
            })
            
        }
    }
    
    
    @IBAction func closeBtnWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: - Alert massage
    func alertMassage(message: String) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default) { (action) in
            
        }
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    

}
extension LoginVC: UITextFieldDelegate {
    
    
}
