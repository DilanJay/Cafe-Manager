//
//  ForgotPasswordViewController.swift
//  Cafe~Manager
//
//  Created by Dilan Pramodya on 2021-05-10.
//

import UIKit
import Firebase
import Loaf

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)

    }
    
    @IBAction func btnSend(_ sender: UIButton) {
        
        Auth.auth().sendPasswordReset(withEmail: txtEmail.text!) { (error) in
            if error == nil {
                Loaf("Password reset link send to your Email address.", state: .success, sender: self).show()
            } else {
                Loaf("Invalid email address...or \(error?.localizedDescription ?? "")", state: .error, sender: self).show()
            }
        }
    }

    @IBAction func btnDone(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)

    }
}
