//
//  EntityModel.swift
//  Cafe~Manager
//
//  Created by Dilan Pramodya on 2021-05-10.
//

import Foundation

struct Admin {
    var userName: String
    var email: String
    var password: String
    var phoneNo: String
}

struct FoodItem {
    var foodID: String
    var foodImage: String
    var foodName: String
    var description: String
    var price: Double
    var discount: Int
    var category: String
    //var isActive: Bool
}

struct Category {
    var categoryID: String
    var categoryName: String
}

struct Order {
    var orderID: String
    var customer_name: String
    var customer_email: String
    var date: Double
    var status_code: Int
    var orderItems: [OrderItem] = []
}

struct OrderItem {
    var item_name: String
    var price: Double
}
