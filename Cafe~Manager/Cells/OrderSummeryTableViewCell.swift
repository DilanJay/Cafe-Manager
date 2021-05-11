//
//  OrderSummeryTableViewCell.swift
//  Cafe~Manager
//
//  Created by Dilan Pramodya on 2021-05-11.
//

import UIKit

class OrderSummeryTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    class var reuseIdentifier: String {
        return "SummeryReuseIdentifire"
    }
    
    class var nibName: String {
        return "OrderSummeryTableViewCell"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
