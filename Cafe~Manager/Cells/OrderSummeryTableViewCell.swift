//
//  OrderSummeryTableViewCell.swift
//  Cafe~Manager
//
//  Created by Dilan Pramodya on 2021-05-11.
//

import UIKit

class OrderSummeryTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var lblOrderID: UILabel!
    @IBOutlet weak var lblItems: UILabel!
    @IBOutlet weak var lblQty: UILabel!
    @IBOutlet weak var lblOrderTotal: UILabel!
    
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
    
    func confligCell(order: Order) {
        lblOrderID.text = order.orderID
        
        var foodName: String = ""
        var orderInfo: String = ""
        var totalAmount: Double = 0
        
        for orderItem in order.orderItems {
            print(orderItem.item_name)
            foodName += "\n\(orderItem.item_name)"
            orderInfo += "\n1 X \(orderItem.price) LKR"
            totalAmount += 1 + orderItem.price
        }
        
        lblItems.text = foodName
        lblQty.text = orderInfo
        lblOrderTotal.text = "Total: \(totalAmount)"
    }
}
