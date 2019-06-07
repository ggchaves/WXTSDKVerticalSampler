//
//  InsuranceHomeTableViewController.swift
//  SparkMediaSDKSampler
//
//  Created by Jonathan Field on 25/06/2017.
//  Copyright © 2017 JonathanField. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class InsuranceHomeTableViewController: UITableViewController, MKMapViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorColor = .orange
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 32.0/255.0, green: 33.0/255.0, blue: 35.0/255.0, alpha: 1.0)

        self.title = "Claims"
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
        return 6
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var rowHeight: CGFloat = 0.0
        switch indexPath.row {
        case 0:
            rowHeight = 245.0
        case 2:
            rowHeight = 145.0
        default:
            rowHeight = 52.0
        }
        return rowHeight
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        switch indexPath.row {
        case 0:
            var mapCell = self.tableView.dequeueReusableCell(withIdentifier: "insuranceMapCell") as! InsuranceMapCell
            return mapCell
        case 1:
            cell = self.tableView.dequeueReusableCell(withIdentifier: "insuranceCustomerCell") as! InsuranceCustomerCell
        case 2:
            cell = self.tableView.dequeueReusableCell(withIdentifier: "insuranceClaimDetails") as! InsuranceClaimDetailCell
        case 3:
            cell = self.tableView.dequeueReusableCell(withIdentifier: "insuranceUpdateLocation") as! InsuranceUpdateLocationCell
        case 4:
            cell = self.tableView.dequeueReusableCell(withIdentifier: "insuranceVideoClaimAppraisal") as! InsuranceVideoClaimCell
        case 5:
            cell = self.tableView.dequeueReusableCell(withIdentifier: "insuranceCustomerName") as! InsuranceToolbarCell
        default:
            cell = UITableViewCell()
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Open Claims"
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 25))
        returnedView.backgroundColor = UIColor.black
        
        let label = UILabel(frame: CGRect(x: 10, y: 5, width: view.frame.size.width, height: 25))
        label.text = "Open Claims"
        label.textColor = .white
        returnedView.addSubview(label)
        
        return returnedView
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
