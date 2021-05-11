//
//  CategoryCollectionViewCell.swift
//  Cafe~Manager
//
//  Created by Dilan Pramodya on 2021-05-11.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var lblCategoryName: UILabel!
    
    class var reuseIdentifire: String {
        return "CategoryCollectionViewCell"
    }

    class var nibName: String {
        return "CategoryCollectionViewCell"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func confligCell(category: Category) {
        lblCategoryName.text = category.categoryName
    }
}
