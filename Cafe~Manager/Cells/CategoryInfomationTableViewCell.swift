//
//  CategoryInfomationTableViewCell.swift
//  Cafe~Manager
//
//  Created by Dilan Pramodya on 2021-05-10.
//

import UIKit

class CategoryInfomationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    
    class var reuseIdentifire: String {
        return "CategoryInfomationIdentifire"
    }
    
    class var nibName: String {
        return "CategoryInfomationTableViewCell"
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configCell(category: Category ) {
        lblName.text = category.categoryName
    }
}
