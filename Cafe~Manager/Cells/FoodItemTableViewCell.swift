//
//  FoodItemTableViewCell.swift
//  Cafe~Manager
//
//  Created by Dilan Pramodya on 2021-05-10.
//

import UIKit
import Kingfisher

class FoodItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var foodName: UILabel!
    @IBOutlet weak var foodDescription: UILabel!
    @IBOutlet weak var foodPrice: UILabel!
    @IBOutlet weak var foodDiscount: UILabel!
    @IBOutlet weak var foodAvailableSwitch: UISwitch!
    
    var rowIndex = 0
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    class var reuseIdentifier: String {
        return "foodItemReuseIdentifier"
    }
    
    class var nibName: String {
        return "FoodItemTableViewCell"
    }
    
    func confligCell(foodItem: FoodItem, index: Int) {
        foodName.text = foodItem.foodName
        foodDescription.text = foodItem.description
        foodPrice.text = "LKR- \(foodItem.price)"
        foodImage.kf.setImage(with: URL(string: foodItem.foodImage))
        //foodAvailableSwitch.isOn = foodItem.isActive
        
        if foodItem.discount > 0 {
            foodDiscount.isHidden = false
            foodDiscount.text = "\(foodItem.discount)% OFF"
        } else {
            foodDiscount.isHidden = true
            foodDiscount.text = ""
        }
        
        self.rowIndex = index
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
