//
//  FinancialServicesCallPreviewTableViewController.swift
//  SparkMediaSDKSampler
//
//  Created by Jonathan Field on 29/03/2017.
//  Copyright © 2017 JonathanField. All rights reserved.
//

import UIKit

class FinancialServicesCallPreviewTableViewController: UITableViewController {
    
    var service: NSDictionary! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
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
        return 3
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            return self.titleCell()
        }
        
        let cell = UITableViewCell()
        
        return cell
    }
    
    func titleCell() -> FinancialServicesTitleTableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "titleCell") as! FinancialServicesTitleTableViewCell
        cell.titleLabel.text = self.service.value(forKey: "financialServiceName") as! String?
        return cell
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
