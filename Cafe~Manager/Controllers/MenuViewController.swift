//
//  MenuViewController.swift
//  Cafe~Manager
//
//  Created by Dilan Pramodya on 2021-05-11.
//

import UIKit
import Firebase
import FirebaseStorage
import Loaf

class MenuViewController: UIViewController {

    @IBOutlet weak var txtFoodName: UITextField!
    @IBOutlet weak var txtDescription: UITextField!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var imgFood: UIImageView!
    @IBOutlet weak var txtCategory: UITextField!
    @IBOutlet weak var txtDiscount: UITextField!
    
    let databaseReference = Database.database().reference()
    var categoryList: [Category] = []
    var  selectedCategoryIndex = 0
    
    var categoryPicker = UIPickerView()
    
    var selectedImage: UIImage?
    var imagePicker: ImagePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.imagePickerClicked))
        self.imgFood.isUserInteractionEnabled = true
        self.imgFood.addGestureRecognizer(gesture)
        self.refreshCategory()
    }

    @IBAction func btnAddCategory(_ sender: UIButton) {
        let foodItem = FoodItem(
            foodID: "",
            foodImage: "",
            foodName: txtFoodName.text ?? "",
            description: txtDescription.text ?? "",
            price: Double(txtPrice.text ?? "") ?? 0,
            discount: Int(txtDiscount.text ?? "") ?? 0,
            category: categoryList[selectedCategoryIndex].categoryName)
        
        self.addFoodItem(foodItem: foodItem)
    }
    
    @objc func imagePickerClicked(_ sender: UIImageView) {
        self.imagePicker?.present(from: sender)
    }
}

extension MenuViewController {
    func addFoodItem(foodItem: FoodItem) {
        guard let image = self.selectedImage else {
            Loaf("Please add an image",  state: .error, sender: self).show()
            return
        }
        
        if let uploadData = image.jpegData(compressionQuality: 0.5) {
            
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpeg"
            
            Storage.storage().reference().child("foodItemImages").child(foodItem.foodName).putData(uploadData, metadata: metaData) {
                meta, error in
                
                if let error = error {
                    print(error.localizedDescription)
                    Loaf(error.localizedDescription,  state: .error, sender: self).show()
                    return
                }
                
                Storage.storage().reference().child("foodItemImages").child(foodItem.foodName).downloadURL(completion: {
                    (url, error) in
                    guard let downloadURL = url else {
                        if let error = error {
                            print(error.localizedDescription)
                            Loaf("Unable to get download URL, Error: " + error.localizedDescription,  state: .error, sender: self).show()
                        }
                        return
                    }
                    
                    Loaf("Image uploaded successfully", state: .success, sender: self).show()
                    
                    let data = [
                        "name" : foodItem.foodName,
                        "description" : foodItem.description,
                        "price" : foodItem.price,
                        "discount" : foodItem.discount,
                        "category" : foodItem.category,
                        "image" : downloadURL.absoluteString
                    ] as [String : Any]
                    
                    self.databaseReference
                        .child("foodItems")
                        .childByAutoId()
                        .setValue(data) {
                            error, ref in
                            if let error = error {
                                Loaf(error.localizedDescription, state: .error, sender: self).show()
                            } else {
                                Loaf("New item added successfully", state: .success, sender: self).show()
                            }
                        }
                })
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
                    self.setupCategoryPicker()
                }
            })
    }
}

extension MenuViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func setupCategoryPicker() {
        let pickerToolBar = UIToolbar()
        pickerToolBar.sizeToFit()
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: #selector(onPickerCancelled))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        pickerToolBar.setItems([space, cancelButton], animated: true)
        
        txtCategory.inputAccessoryView = pickerToolBar
        txtCategory.inputView = categoryPicker
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
    }
    
    @objc func onPickerCancelled() {
        self.view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryList[row].categoryName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txtCategory.text = categoryList[row].categoryName
        selectedCategoryIndex = row
    }
}

extension MenuViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        self.imgFood.image = image
        self.selectedImage = image
    }
}
