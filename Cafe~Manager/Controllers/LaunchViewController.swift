//
//  LaunchViewController.swift
//  Cafe~Manager
//
//  Created by Dilan Pramodya on 2021-05-10.
//

import UIKit

class LaunchViewController: UIViewController {
    
    let sessionManager = SessionManager()
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if sessionManager.getLoggedStatus() {
            self.performSegue(withIdentifier: "LaunchToHome", sender: nil)
        } else {
            self.performSegue(withIdentifier: "LaunchToSignIn", sender: nil)
        }
    }
}
