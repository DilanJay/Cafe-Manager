//
//  PreviewViewController.swift
//  Cafe~Manager
//
//  Created by Dilan Pramodya on 2021-05-10.
//

import UIKit
import Firebase
import Loaf

class PreviewViewController: UIViewController {

    @IBOutlet weak var tblPreview: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let databaseReference = Database.database().reference()
    
    var categoryList: [Category] = []
    var foodItemList: [FoodItem] = []
    var filteredList: [FoodItem] = []
    var selectedCategoryIndex = 0
    var selectedFoodIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let collectionViewNib = UINib(nibName: CategoryCollectionViewCell.nibName, bundle: nil)
        collectionView.register(collectionViewNib, forCellWithReuseIdentifier: CategoryCollectionViewCell.reuseIdentifire)
        if let flowLayout = self.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 80, height: 30)
        }
        tblPreview.register(UINib(nibName: FoodItemTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: FoodItemTableViewCell.reuseIdentifier)
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        refreshCategory()
        refreshFood()
    }
    
}

extension PreviewViewController {
    func filterFood(category: Category) {
        filteredList = foodItemList.filter{$0.category == category.categoryName}
        tblPreview.reloadData()
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
                    self.collectionView.reloadData()
                }
            })
    }
    
    func refreshFood() {
        foodItemList.removeAll()
        filteredList.removeAll()
        
        databaseReference
            .child("foodItems")
            .observeSingleEvent(of: .value, with: {
                snapshot in
                if snapshot.hasChildren() {
                    guard let data = snapshot.value as? [String: Any] else {
                        NSLog("Can not parse data" )
                        return
                    }
                    for food in data {
                        if let foodInfo = food.value as? [String: Any] {
                            self.foodItemList.append(FoodItem(
                                                        foodID: food.key,
                                                        foodImage: foodInfo["image"] as! String,
                                                        foodName: foodInfo["name"] as! String,
                                                        description: foodInfo["description"] as! String,
                                                        price: foodInfo["price"] as! Double ,
                                                        discount: foodInfo["discount"] as! Int,
                                                        category: foodInfo["category"] as! String))
                        }
                    }
                    self.filteredList.append(contentsOf: self.foodItemList)
                    self.tblPreview.reloadData()
                }
            })
    }
}

extension PreviewViewController: UITabBarDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblPreview.dequeueReusableCell(withIdentifier: FoodItemTableViewCell.reuseIdentifier, for: indexPath) as! FoodItemTableViewCell
        cell.selectionStyle = .none
        //cell.delegate = self
        cell.confligCell(foodItem: filteredList[indexPath.row], index: indexPath.row)
        return cell
    } 

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedFoodIndex = indexPath.row
    }


}

extension PreviewViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.reuseIdentifire,
                                                                   for: indexPath) as? CategoryCollectionViewCell {
            cell.confligCell(category: categoryList[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCategoryIndex = indexPath.row
        UIView.transition(with: collectionView, duration: 0.3, options: .transitionCrossDissolve, animations: {self.collectionView.reloadData()}, completion: nil)

        
        filterFood(category: categoryList[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let cell: CategoryCollectionViewCell = Bundle.main.loadNibNamed(CategoryCollectionViewCell.nibName,
                                                                owner: self,
                                                                options: nil)?.first as? CategoryCollectionViewCell else {
            return CGSize.zero
        }
        cell.confligCell(category: categoryList[indexPath.row])
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        let size: CGSize = cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        return CGSize(width: size.width, height: 30)
    }
}
