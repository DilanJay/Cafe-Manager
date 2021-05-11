//
//  StoreViewController.swift
//  Cafe~Manager
//
//  Created by Dilan Pramodya on 2021-05-10.
//

import UIKit

class StoreViewController: UIViewController {
    
    @IBOutlet weak var preview: UIView!
    @IBOutlet weak var category: UIView!
    @IBOutlet weak var menu: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    
    let sessionManager = SessionManager()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func btnSignOut(_ sender: UIButton) {
        sessionManager.clearUserLoggedStatus()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectView(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            preview.alpha = 1
            category.alpha = 0
            menu.alpha = 0
        } else if sender.selectedSegmentIndex == 1 {
            preview.alpha = 0
            category.alpha = 1
            menu.alpha = 0
        } else {
            preview.alpha = 0
            category.alpha = 0
            menu.alpha = 1
        }

    }
}

