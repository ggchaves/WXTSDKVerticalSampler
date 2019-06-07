//
//  RetailViewController.swift
//  SparkMediaSDKSampler
//
//  Created by Jonathan Field on 07/01/2017.
//  Copyright © 2017 JonathanField. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import Device_swift

class RetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISplitViewControllerDelegate {

    @IBOutlet weak var topBanner: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    let products = NSArray(contentsOf:Bundle.main.url(forResource: "retailItems", withExtension: "plist")!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.navigationItem.title = UserDefaults.standard.value(forKey: "retailStoreName") as! String?
        self.navigationController?.navigationBar.tintColor = UIColor.orange
        self.navigationController?.navigationBar.backgroundColor = UIColor.black
        self.splitViewController?.delegate = self
        self.splitViewController?.preferredDisplayMode = .allVisible
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let temporaryProduct = self.products?.object(at: indexPath.row) as! NSDictionary
        print(temporaryProduct)
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell") as! RetailItemTableViewCell
        cell.advertisingImage.image = UIImage(named: temporaryProduct.value(forKey: "productImage") as! String)
        // iPad Specific Configuration
        if UIScreen.main.traitCollection.userInterfaceIdiom == .pad {
//            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 600, height: 200))
//            label.center = cell.center
//            label.font = UIFont.systemFont(ofSize: 60)
//            label.text = temporaryProduct.value(forKey: "productName") as! String?
//            label.textColor = UIColor.white
//            label.textAlignment = .right
//            cell.addSubview(label)
            //cell.advertisingImage.contentMode = .scaleAspectFill
            //cell.price.textColor = UIColor.white
            //cell.itemDescription.textColor = UIColor.white
        }
        cell.itemDescription.text = temporaryProduct.value(forKey: "productName") as! String?
        cell.price.text = temporaryProduct.value(forKey: "productPrice") as! String?
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "showItemDetail", sender: self.products?.object(at: indexPath.row))
    }
    
    @IBAction func dismissRetailScenario(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let product = sender as! NSDictionary
        let nav = segue.destination as! UINavigationController
        let retailItemView = nav.viewControllers[0] as! RetailItemViewController
        retailItemView.product = product
        print(product)
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
 

}
