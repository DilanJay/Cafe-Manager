//
//  OrderViewController.swift
//  Cafe~Manager
//
//  Created by Dilan Pramodya on 2021-05-10.
//

import UIKit
import Firebase
import Loaf

class OrderViewController: UIViewController {
    
    var orders: [Order] = []
    var filteredOrder: [Order] = []

    @IBOutlet weak var tblOrder: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    let databaseReference = Database.database().reference()

    override func viewDidLoad() {
        super.viewDidLoad()
        tblOrder.register(UINib(nibName: OrderTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: OrderTableViewCell.reuseIdentifier)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.fetchOrder()
    }

    @IBAction func segmentedControl(_ sender: UISegmentedControl) {
        filterOrders(status: sender.selectedSegmentIndex)
    }
}

extension OrderViewController {
    func filterOrders(status: Int) {
        filteredOrder.removeAll()
        filteredOrder = self.orders.filter {$0.status_code == status}
        tblOrder.reloadData()
    }
    
    func fetchOrder() {
        self.filteredOrder.removeAll()
        self.orders.removeAll()
        self.databaseReference
            .child("order")
            .observe(.value, with: {
                snapshot in
                self.filteredOrder.removeAll()
                self.orders.removeAll()
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
                            self.orders.append(singleOrder)
                        }
                    }
                    self.filteredOrder.append(contentsOf: self.orders)
                    self.segmentedControl(self.segmentControl)
                    
                } else {
                    Loaf("Order found failed",  state: .error, sender: self).show()
                }
            })
    }
}

extension OrderViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredOrder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblOrder.dequeueReusableCell(withIdentifier: OrderTableViewCell.reuseIdentifier, for: indexPath) as! OrderTableViewCell
        cell.selectionStyle = .none
        cell.confligCell(order: filteredOrder[indexPath.row])
        return cell
    }
}
