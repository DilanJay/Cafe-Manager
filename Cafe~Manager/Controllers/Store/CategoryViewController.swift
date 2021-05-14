//
//  CategoryViewController.swift
//  Cafe~Manager
//
//  Created by Dilan Pramodya on 2021-05-10.
//

import UIKit
import Firebase
import Loaf

class CategoryViewController: UIViewController {

    @IBOutlet weak var txtAddCategory: UITextField!
    @IBOutlet weak var tblCategory: UITableView!
    
    let databaseReference = Database.database().reference()
    
    var categoryList: [Category] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblCategory.register(UINib(nibName: CategoryInfomationTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: CategoryInfomationTableViewCell.reuseIdentifire)

        refreshCategory()
        
    }

    @IBAction func btnAdd(_ sender: UIButton) {
        if let category = txtAddCategory.text , category.isEmpty {
            Loaf("Please enter category name",  state: .error, sender: self).show()
            return
        }
        
        if let name  = txtAddCategory.text {
            addCategory(name: name)
        } else {
            Loaf("Pleace enter a category", state: .error, sender: self).show()

        }
    }
}

extension CategoryViewController {
    func addCategory(name: String) {
        databaseReference.child("categories")
            .childByAutoId()
            .child("name")
            .setValue(name) {
                error, ref in
                if let error = error{
                    Loaf(error.localizedDescription, state: .error, sender: self).show()
                } else {
                    Loaf("New category creted successfully", state: .success, sender: self).show()
                    self.refreshCategory()
                }
                
            }
        
    }
    
    func refreshCategory() {
        self.categoryList.removeAll()
        databaseReference.child("categories")
            .observeSingleEvent(of: .value, with: {
                snapshot in
                if snapshot.hasChildren() {
                    guard let data = snapshot.value as? [String: Any] else {
                        return
                    }
                    for category in data {
                        if let categoryInfo = category.value as? [String: String] {
                            self.categoryList.append(Category(categoryID: category.key, categoryName: categoryInfo["name"]!))
                        }
                    }
                    self.tblCategory.reloadData()
                }
            })
    }
    
    func removeCategory(category: Category) {
        databaseReference.child("categories")
            .child(category.categoryID)
            .removeValue() {
                error, databaseReference in
                if error != nil {
                    Loaf("Category not removed", state: .error, sender: self).show()
                } else {
                    Loaf("Category removed successfully", state: .success, sender: self).show()
                    self.refreshCategory()
                }
            }
    }
}

extension CategoryViewController:  UITabBarDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblCategory.dequeueReusableCell(withIdentifier: CategoryInfomationTableViewCell.reuseIdentifire , for: indexPath) as! CategoryInfomationTableViewCell
        cell.selectionStyle = .none
        cell.configCell(category: self.categoryList[indexPath.row])
                return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.removeCategory(category: categoryList[indexPath.row])
            refreshCategory()
        }
    }
    
}
