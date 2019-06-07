//
//  FinancialHomeTableViewController.swift
//  SparkMediaSDKSampler
//
//  Created by Jonathan Field on 19/02/2017.
//  Copyright © 2017 JonathanField. All rights reserved.
//

import UIKit

class FinancialHomeTableViewController: UITableViewController, UISplitViewControllerDelegate {
    
    var themeColour: UIColor = UIColor(red:0.07, green:0.22, blue:0.51, alpha:1.0)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.themeColour = self.navigationBarColour()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        self.navigationController?.navigationBar.barTintColor = self.themeColour
        self.navigationController?.tabBarController?.tabBar.barTintColor = UIColor.white
        self.navigationController?.tabBarController?.tabBar.tintColor = self.themeColour
        
        self.splitViewController?.delegate = self
        self.splitViewController?.preferredDisplayMode = .allVisible
        
        let defaults = UserDefaults.standard
        let bankName = defaults.value(forKey: "bankName") as! String?
        if (bankName == nil) || bankName == "" {
            self.navigationItem.title = "ABC Bank"
        }
        else {
            self.navigationItem.title = bankName
            print("Not Blank or Nil")
        }
    }

    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let transactions = NSArray(contentsOf:Bundle.main.url(forResource: "financialTransactions", withExtension: "plist")!)
        return transactions!.count + 2
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "customerCell") as! FinancialCustomerTableViewCell
            let creditCardProvider = UserDefaults.standard.integer(forKey: "creditCardProvider")
            if (creditCardProvider == nil) || creditCardProvider == 0 {
                cell.creditCardProvider.image = UIImage(named: "provider-visa")
            }
            cell.backgroundColor = self.themeColour
            switch creditCardProvider {
            case 1:
                cell.creditCardProvider.image = UIImage(named: "provider-visa")
            case 2:
                cell.creditCardProvider.image = UIImage(named: "provider-mastercard")
            case 3:
                cell.creditCardProvider.image = UIImage(named: "provider-maestro")
            case 4:
                cell.creditCardProvider.image = UIImage(named: "provider-cirrus")
            case 5:
                cell.creditCardProvider.image = UIImage(named: "provider-american-express")
            default:
                cell.creditCardProvider.image = UIImage(named: "provider-visa")
            }
            return cell
        case 1:
            return self.tableView.dequeueReusableCell(withIdentifier: "accountActivityHeader")!
            //return self.tableView.dequeueReusableCell(withIdentifier: "accountActivityHeader")!
        default:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "accountActivityCell")! as! FinancialAccountActivityTableViewCell
            let transactions = NSArray(contentsOf:Bundle.main.url(forResource: "financialTransactions", withExtension: "plist")!)
            let transaction = transactions![indexPath.row - 2] as! NSDictionary
            cell.merchantName.text = transaction.value(forKey: "transactionMerchant") as? String
            cell.transactionDate.text = transaction.value(forKey: "transactionDate") as? String
            cell.transactionAmount.text = transaction.value(forKey: "transactionAmount") as? String
            cell.categoryImage.image = UIImage(named: transaction.value(forKey: "transactionImage") as! String)
            cell.categoryImage.layer.masksToBounds = true
            cell.categoryImage.layer.cornerRadius = 10
            cell.categoryImage.layer.borderColor = UIColor.lightGray.cgColor
            cell.categoryImage.layer.borderWidth = 0.35
            let outgoingTransaction = transaction.value(forKey: "transactionOutgoing") as! Bool
            if (outgoingTransaction == false) {
                cell.transactionAmount.textColor = UIColor.green
            }
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var rowHeight = 0
        switch indexPath.row {
        case 0:
            rowHeight = 85
        case 1:
            rowHeight = 60
        default:
            rowHeight = 60
        }
        return CGFloat(rowHeight)
    }
    
    @IBAction func homeButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func navigationBarColour() -> UIColor {
        var navigationBarColour = UIColor(red:0.00, green:0.44, blue:0.29, alpha:1.0)
        let themes = NSArray(contentsOf:Bundle.main.url(forResource: "financialThemes", withExtension: "plist")!)
        let themeId = UserDefaults.standard.integer(forKey: "themeId")
        if !(themeId == 0){
        for temp in themes! {
            let theme = temp as! NSDictionary
            print(theme)
            if Int(theme.value(forKey: "themeId") as! String) == themeId {
                let red = CGFloat(Float.init(theme.value(forKey: "red") as! String)!)
                let green = CGFloat(Float.init(theme.value(forKey: "green") as! String)!)
                let blue = CGFloat(Float.init(theme.value(forKey: "blue") as! String)!)
                let alpha = CGFloat(Float.init(theme.value(forKey: "alpha") as! String)!)
                navigationBarColour = UIColor(red: red , green: green, blue: blue, alpha: alpha)
                }
            }
        }
        return navigationBarColour
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
