//
//  MenuItemDetailViewController.swift
//  Restaurant
//
//  Created by Marc Batete on 11/20/19.
//  Copyright © 2019 Marc Batete. All rights reserved.
//

import UIKit
protocol AddToOrderDelegate {
    func added(menuItem: MenuItem)
}
class MenuItemDetailViewController: UIViewController {

   @IBOutlet weak var imageView: UIImageView!
       @IBOutlet weak var titleLabel: UILabel!
       @IBOutlet weak var priceLabel: UILabel!
       @IBOutlet weak var descriptionLabel: UILabel!
       @IBOutlet weak var addToOrderButton: UIButton!
       
       var menuItem: MenuItem!
       var delegate: AddToOrderDelegate?
       
       override func viewDidLoad() {
           super.viewDidLoad()
           
           addToOrderButton.layer.cornerRadius = 5.0
           updateUI()
           setUpDelegate()
       }

       @IBAction func orderButtonTapped(_ sender: UIButton) {
           UIView.animate(withDuration: 0.2) {
               self.addToOrderButton.transform = CGAffineTransform(scaleX: 3.0, y: 3.0)
               self.addToOrderButton.transform = CGAffineTransform.identity
           }
           
           delegate?.added(menuItem: menuItem)//934
       }
       
       func updateUI() {
           titleLabel.text = menuItem.name
           priceLabel.text = String(format: "$%.2f", menuItem.price)
           descriptionLabel.text = menuItem.description
           
           MenuController.shared.fetchImage(url: menuItem.imageURL) { (image) in
               guard let image = image else { return }
               
               DispatchQueue.main.async {
                   self.imageView.image = image
               }
           }
       }
       
       func setUpDelegate() {
           if let navController = tabBarController?.viewControllers?.last as? UINavigationController,
               let orderTableViewController = navController.viewControllers.first as? OrderTableViewController {
               delegate = orderTableViewController
           }
       }
}
