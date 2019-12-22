//
//  OrderTableViewController.swift
//  Restaurant
//
//  Created by Marc Batete on 11/20/19.
//  Copyright © 2019 Marc Batete. All rights reserved.
//

import UIKit

class OrderTableViewController: UITableViewController {
    //var order = Order() //932
    var menuItems = [MenuItem]()
    var orderMinutes: Int?
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            navigationItem.leftBarButtonItem = editButtonItem
        }
        
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            //933
            return menuItems.count
        }
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCellIdentifier", for: indexPath)
            
            configure(cell: cell, forItemAt: indexPath)
            
            return cell
        }
        
        override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true
        }
        
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                menuItems.remove(at: indexPath.row)//938
                tableView.deleteRows(at: [indexPath], with: .fade)
                updateBadgeNumber()
            }
        }
    @IBAction func unwindToOrderList(segue: UIStoryboardSegue) {
        print("we here maybe")
        if segue.identifier == "DismissConfirmation" {
            print("we here")
            menuItems.removeAll()
            print("we here")
             tableView.reloadData()
             updateBadgeNumber()
        }
    }
        
        func configure(cell: UITableViewCell, forItemAt indexPath: IndexPath) {
            let menuItem = menuItems[indexPath.row]//932
            
            cell.textLabel?.text = menuItem.name
            cell.detailTextLabel?.text = String(format: "$%.2f", menuItem.price)
            
            MenuController.shared.fetchImage(url: menuItem.imageURL) { (image) in
                guard let image = image else { return }
                
                DispatchQueue.main.async {
                    if let currentIndexPath = self.tableView.indexPath(for: cell),
                        currentIndexPath != indexPath {
                        return
                    }
                    
                    cell.imageView?.image = image
                }
            }
        }
        
        func updateBadgeNumber() {
            let badgeValue = menuItems.count > 0 ? "\(menuItems.count)" : nil
            navigationController?.tabBarItem.badgeValue = badgeValue
        }
        func uploadOrder() {
            
            let menuIds = menuItems.map { $0.id }
            MenuController.shared.submitOrder(menuIds: menuIds) { (minutes) in
                if let minutes = minutes {
                    DispatchQueue.main.async {
                        self.orderMinutes = minutes
                        self.performSegue(withIdentifier: "ConfirmationSegue", sender: nil)
                        
                    }
                }
            }
        }

        
    @IBAction func submitButtonTapped(_ sender: Any) {
        
        let orderTotal = menuItems.reduce(0.0) { (result, menuItem) -> Double in
            return result + menuItem.price
        }
        
        print("we in")
        let formattedOrder = String(format: "$%.2f", orderTotal)
        if orderTotal == 0 {
                    let alert1 = UIAlertController(title: "Fill out Order", message: "You are about to submit an emty order", preferredStyle: .alert)
            alert1.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alert1, animated: true, completion: nil)
        }else{
        let alert = UIAlertController(title: "Confirm Order", message: "You are about to submit your order with a total of \(formattedOrder)", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { (_) in
            print("here")
            self.uploadOrder()
        }))
        print("we in n in")
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
        }
    }
   
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "ConfirmationSegue" {
                let orderConfirmationViewController = segue.destination as! OrderConfirmationViewController
                orderConfirmationViewController.minutes = orderMinutes
            }
        }
    }


    extension OrderTableViewController: AddToOrderDelegate {
        
        func added(menuItem: MenuItem) {
            menuItems.append(menuItem)
            
            let count = menuItems.count
            let indexPath = IndexPath(row: count-1, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
            
            updateBadgeNumber()
        }
}
