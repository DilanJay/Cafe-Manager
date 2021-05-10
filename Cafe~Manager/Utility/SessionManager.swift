//
//  SessionManager.swift
//  Cafe~Manager
//
//  Created by Dilan Pramodya on 2021-05-10.
//

import Foundation

class SessionManager {
    func getLoggedStatus() -> Bool {
        return UserDefaults.standard.bool(forKey: "Logged_In")
    }
    
    func saveUserLogin(admin: Admin) {
        UserDefaults.standard.setValue(true, forKey: "Logged_In")
        UserDefaults.standard.setValue(admin.userName, forKey: "User_Name")
        UserDefaults.standard.setValue(admin.email, forKey: "User_Email")
        UserDefaults.standard.setValue(admin.phoneNo, forKey: "User_PhoneNo")
    }
    
    func getUserData() -> Admin {
        let admin = Admin(
            userName: UserDefaults.standard.string(forKey: "User_Name") ?? "",
            email: UserDefaults.standard.string(forKey: "User_Email") ?? "",
            password: "",
            phoneNo: UserDefaults.standard.string(forKey: "User_PhoneNo") ?? ""
        )
        
        return admin
    }
    
    func clearUserLoggedStatus() {
        UserDefaults.standard.setValue(false, forKey: "Logged_In")
    }
}
