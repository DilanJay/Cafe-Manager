//
//  AccountViewController.swift
//  Cafe~Manager
//
//  Created by Dilan Pramodya on 2021-05-10.
//

import UIKit
import Firebase
import Loaf

class AccountViewController: UIViewController {

    @IBOutlet weak var txtFrom: UITextField!
    @IBOutlet weak var txtTo: UITextField!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var tblAccount: UITableView!
    
    let databaseReference = Database.database().reference()
    
    var orderList: [Order] = []
    var filterOrders: [Order] = []
    
    var orderTotal: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblAccount.register(UINib(nibName: OrderSummeryTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: OrderSummeryTableViewCell.reuseIdentifier)
        
//        self.tblAccount.estimatedRowHeight = 100
//        self.tblAccount.rowHeight = UITableView.automaticDimension
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchOrder()
    }
    
}

extension AccountViewController {
    func filteredOrders() {
        
    }
    
    func getOrderTotal() {
        self.orderTotal = 0
        for order in filterOrders {
            for item in order.orderItems {
                self.orderTotal += item.price
            }
        }
        lblPrice.text = "\(orderTotal) LKR"
    }
    
    func fetchOrder() {
        self.filterOrders.removeAll()
        self.orderList.removeAll()
        self.databaseReference
            .child("order")
            .observeSingleEvent(of: .value, with: {
                snapshot in
                if snapshot.hasChildren() {
                    guard let data = snapshot.value as? [String: Any] else {
                        Loaf("Cannot parse data ",  state: .error, sender: self).show()
                        return
                    }
                    for order in data {
                        if let orderInfo = order.value as? [String: Any] {
                            var singleOrder = Order(
                                orderID: order.key,
                                customer_name: orderInfo["customer_name"] as! String,
                                customer_email: orderInfo["customer_email"] as! String,
                                date: orderInfo["date"] as! Double,
                                status_code: orderInfo["status_code"] as! Int)
                            
                            if let orderItems = orderInfo["items"] as? [String: Any] {
                                for item in orderItems {
                                    if let singleItem = item.value as? [String: Any] {
                                        singleOrder.orderItems.append(OrderItem(
                                                                        item_name: singleItem["item_name"] as! String,
                                                                        price: singleItem["price"] as! Double))
                                    }
                                }
                            }
                            self.orderList.append(singleOrder)
                        }
                    }
                    self.filterOrders.append(contentsOf: self.orderList)
                    self.getOrderTotal()
                    self.tblAccount.reloadData()
                } else {
                    Loaf("Order found failed",  state: .error, sender: self).show()
                }
            })
    }
}

extension AccountViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterOrders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblAccount.dequeueReusableCell(withIdentifier: OrderSummeryTableViewCell.reuseIdentifier, for: indexPath) as! OrderSummeryTableViewCell
        cell.selectionStyle = .none
        cell.confligCell(order: filterOrders[indexPath.row ])
        return cell
    }
    
    
}
