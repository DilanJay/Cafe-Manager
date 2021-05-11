//
//  PreviewViewController.swift
//  Cafe~Manager
//
//  Created by Dilan Pramodya on 2021-05-10.
//

import UIKit
import Firebase

class PreviewViewController: UIViewController {

    @IBOutlet weak var tblPreview: UITableView!
    var ref: DatabaseReference!
    
    var foodItem: [FoodItem] = []
    var selectedFoodItem: FoodItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tblPreview.register(UINib(nibName: "FoodItemTableViewCell", bundle: nil), forCellReuseIdentifier: "FoodCell")
        ref = Database.database().reference()
        getPreviewItemData()
    }
}

extension PreviewViewController {
    func getPreviewItemData() {
        ref.child("foodItems").observe(.value, with: {
            (snapshot) in

            if let data = snapshot.value {
                if let foodItems = data as? [String: Any] {
                    for item in foodItems {
                        if let foodInfo = item.value as? [String: Any] {
                            
                            let singleFoodItem = FoodItem(
                                foodID: "",
                                foodImage: foodInfo["image"] as! String,
                                foodName: foodInfo["name"] as! String,
                                description: foodInfo["description"] as! String,
                                price: foodInfo["price"] as! Double,
                                discount: foodInfo["discount"] as! Int,
                                category: foodInfo["category"] as! String)
                            
                            self.foodItem.append(singleFoodItem)
                        }
                    }
                    self.tblPreview.reloadData()
                }
            }
        })
    }
}

extension PreviewViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblPreview.dequeueReusableCell(withIdentifier: "FoodCell", for: indexPath) as! FoodItemTableViewCell
        cell.setUpView(foodItem: foodItem[indexPath.row])
        return cell
    }
}
