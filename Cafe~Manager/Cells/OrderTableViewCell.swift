//
//  OrderTableViewCell.swift
//  Cafe~Manager
//
//  Created by Dilan Pramodya on 2021-05-11.
//

import UIKit

class OrderTableViewCell: UITableViewCell {

    @IBOutlet weak var lblOrderID: UILabel!
    @IBOutlet weak var lblCusName: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    class var reuseIdentifier: String {
        return "OrderReuseIdentifire"
    }
    
    class var nibName: String {
        return "OrderTableViewCell"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    func confligCell(order: Order) {
        switch order.status_code {
        case 0:
            lblStatus.text = " NEW "
        case 1:
            lblStatus.text = " PREPARATION "
        case 2:
            lblStatus.text = " READY "
        case 3:
            lblStatus.text = " ARRVING "
        case 4:
            lblStatus.text = " DONE "
        case 5:
            lblStatus.text = " CANCEL "
        default:
            return
        }
        lblOrderID.text = order.orderID
        lblCusName.text = order.customer_name
    }
}
