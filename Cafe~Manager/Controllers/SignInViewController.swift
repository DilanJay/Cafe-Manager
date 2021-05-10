//
//  SignInViewController.swift
//  Cafe~Manager
//
//  Created by Dilan Pramodya on 2021-05-10.
//

import UIKit
import Firebase
import Loaf

class SignInViewController: UIViewController {
    
    var ref: DatabaseReference!
    
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
    }
    
    @IBAction func btnSignIn(_ sender: UIButton) {
        
        if !InputValidator.isValidEmai(email: txtEmail.text ?? "") {
            Loaf("Please enter a valid Email", state: .error, sender: self).show()
            return
        }
        
        if !InputValidator.isValidPassword(password: txtPassword.text ?? "", minLength: 8, maxLength: 30) {
            Loaf("Please enter a valid Password", state: .error, sender: self).show()
            return
        }
        authenticationUser(email: txtEmail.text!, password: txtPassword.text!)
    }
     
    func authenticationUser(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) {
            authResult, error in
            
            if let err = error {
                print(err.localizedDescription)
                Loaf("User name or Password is invalid!", state: .error, sender: self).show()
                return
            }
            
            if let email = authResult?.user.email {
                self.getUserDetails(email: email)
            } else {
                Loaf("User email not found!", state: .error, sender: self).show()
            }
        }
    }
    
    func getUserDetails(email: String) {
        ref.child("admin")
            .child(email
                    .replacingOccurrences(of: "@", with: "_")
                    .replacingOccurrences(of: ".", with: "_")).observe(.value, with: {
            (snapshot) in
            
                        if snapshot.hasChildren() {
                            if let data = snapshot.value {
                                if let userData = data as? [String: String] {
                                    
                                    let admin = Admin(
                                        userName: userData["name"]!,
                                        email: userData["email"]!,
                                        password: userData["password"]!,
                                        phoneNo: userData["phone"]!
                                    )
                                    
                                    let sessionManager = SessionManager()
                                    sessionManager.saveUserLogin(admin: admin)
                                    self.performSegue(withIdentifier: "SignInToHome", sender: nil)
                                }
                            }
                        } else {
                            Loaf("User  not found!", state: .error, sender: self).show()
                        }
        })
    }
}
