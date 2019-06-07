//
//  FinancialServicesTableViewController.swift
//  SparkMediaSDKSampler
//
//  Created by Jonathan Field on 15/03/2017.
//  Copyright © 2017 JonathanField. All rights reserved.
//

import UIKit

class FinancialServicesTableViewController: UITableViewController {
    
    var themeColour: UIColor = UIColor(red:0.07, green:0.22, blue:0.51, alpha:1.0)

    let services = NSArray(contentsOf:Bundle.main.url(forResource: "financialServices", withExtension: "plist")!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.themeColour = self.navigationBarColour()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        self.navigationController?.navigationBar.barTintColor = self.themeColour
        self.navigationController?.tabBarController?.tabBar.barTintColor = UIColor.white
        self.navigationController?.tabBarController?.tabBar.tintColor = self.themeColour

        
        let defaults = UserDefaults.standard
        let bankName = defaults.value(forKey: "bankName") as! String?
        if (bankName == nil) || bankName == "" {
            self.navigationItem.title = "ABC Bank"
        }
        else {
            self.navigationItem.title = bankName
            print("Not Blank or Nil")
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.services!.count + 1
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0 ? 260 : 70
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell: UITableViewCell = UITableViewCell()
        
        switch indexPath.row {
        case 0:
            let creditCardCell = self.tableView.dequeueReusableCell(withIdentifier: "creditCardCell") as! FinancialServicesCreditCardTableViewCell
            creditCardCell.backgroundColor = self.themeColour
            creditCardCell.selectionStyle = .none
            
            let creditCardProvider = UserDefaults.standard.integer(forKey: "creditCardProvider")
            switch creditCardProvider {
            case 1:
                creditCardCell.creditCardImage.image = UIImage(named: "fullCardVisa")
            case 2:
                creditCardCell.creditCardImage.image = UIImage(named: "fullCardMastercard")
            case 3:
                creditCardCell.creditCardImage.image = UIImage(named: "fullCardMaestro")
            case 4:
                creditCardCell.creditCardImage.image = UIImage(named: "fullCardCirrus")
            case 5:
                creditCardCell.creditCardImage.image = UIImage(named: "fullCardAmericanExpress")
            default:
                creditCardCell.creditCardImage.image = UIImage(named: "fullCardVisa")
            }
            
            return creditCardCell
        default:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "financialServiceCell") as! FinancialServiceTableViewCell
            let serviceName = (self.services?.object(at: indexPath.row - 1) as! NSDictionary).value(forKey: "financialServiceName") as! String
            let serviceImage = (self.services?.object(at: indexPath.row - 1) as! NSDictionary).value(forKey: "financialServiceImage") as! String
            cell.serviceName.text = serviceName
            cell.serviceImage.image = UIImage(named: serviceImage)
            
            let image: UIImage! = UIGraphicsGetImageFromCurrentImageContext()
            
            cell.serviceImage.image = cell.serviceImage.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            
            cell.serviceImage.tintColor = self.themeColour
            cell.selectionStyle = .blue
            
            return cell
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row ==  1 {
            self.performSegue(withIdentifier: "toMortgage", sender: self.services?.object(at: indexPath.row) as! NSDictionary)
        }
        else if (indexPath.row == 0) {
            return
        }
        else {
            let alertController = UIAlertController(title: "Temporarily Unavailable", message: "This service is currently not available", preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.default)
            {
                (result : UIAlertAction) -> Void in
                self.tableView.deselectRow(at: indexPath, animated: true)
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
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
 
    @IBAction func homeButtonPressed(_ sender: Any) {
        print("Dismiss")
        self.tabBarController?.dismiss(animated: true, completion: nil)
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

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let dvc = segue.destination as! FinancialServicesCallPreviewTableViewController
//        dvc.service = sender as! NSDictionary
    }
 

}
