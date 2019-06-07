//
//  FinancialServiceMortgageTableViewController.swift
//  SparkMediaSDKSampler
//
//  Created by Jonathan Field on 09/04/2017.
//  Copyright © 2017 JonathanField. All rights reserved.
//

import UIKit
import PopupDialog
import EPSignature
import WebexSDK
import Alamofire

class FinancialServiceMortgageTableViewController: UITableViewController, WXTeamsCallingDelegate, EPSignatureDelegate {
    
    var themeColour: UIColor = UIColor(red:0.07, green:0.22, blue:0.51, alpha:1.0)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Mortgage Calculator"
        self.themeColour = self.navigationBarColour()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        self.navigationController?.navigationBar.barTintColor = self.themeColour
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
        var rowHeight = 0
        switch indexPath.row {
        case 0:
            if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
            {
            rowHeight = 250
            }
            else {
               rowHeight = 175
            }
        case 1:
            rowHeight = 70
        case 2:
            rowHeight = 60
        default:
            rowHeight = 125
        }
        return CGFloat(rowHeight)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()

        switch indexPath.row {
        case 0:
            let mapViewCell = self.tableView.dequeueReusableCell(withIdentifier: "mapCell") as! FinancialServiceMortgageMapViewTableViewCell
            mapViewCell.selectionStyle = .none
            return mapViewCell
        case 1:
            let advisorCell = self.tableView.dequeueReusableCell(withIdentifier: "advisorCell")!
            advisorCell.backgroundColor = self.themeColour
            advisorCell.selectionStyle = .none
            return advisorCell
        case 2:
            return self.tableView.dequeueReusableCell(withIdentifier: "jointApplicationCell")!
        case 3:
            let depositCell = self.tableView.dequeueReusableCell(withIdentifier: "sliderCell") as! FinancialServicesMortgageSliderTableViewCell
            depositCell.sliderValue.text = "$10000"
            depositCell.sliderDescription.text = "Deposit Amount"
            depositCell.slider.minimumValue = 5000.0
            depositCell.slider.maximumValue = 200000.0
            depositCell.slider.value = 60000
            depositCell.sliderValue.textColor = self.themeColour
            depositCell.selectionStyle = .none
            return depositCell
        case 4:
            let repaymentsCell = self.tableView.dequeueReusableCell(withIdentifier: "sliderCell") as! FinancialServicesMortgageSliderTableViewCell
            repaymentsCell.sliderValue.text = "$500"
            repaymentsCell.sliderDescription.text = "Monthly Repayments"
            repaymentsCell.slider.minimumValue = 350.0
            repaymentsCell.slider.maximumValue = 25000
            repaymentsCell.slider.value = 500
            repaymentsCell.sliderValue.textColor = self.themeColour
            repaymentsCell.selectionStyle = .none
            return repaymentsCell
        case 5:
            let incomeCell = self.tableView.dequeueReusableCell(withIdentifier: "sliderCell") as! FinancialServicesMortgageSliderTableViewCell
            incomeCell.sliderValue.text = "$3000"
            incomeCell.sliderDescription.text = "Monthly Income"
            incomeCell.slider.minimumValue = 1000
            incomeCell.slider.maximumValue = 20000
            incomeCell.slider.value = 1000
            incomeCell.sliderValue.textColor = self.themeColour
            incomeCell.selectionStyle = .none
            return incomeCell
        default:
            print("default")
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
                // Prepare the popup assets
                let title = "Remote Mortgage Consultation"
                let message = "Are you ready to speak to advisor live over Video Chat?"
                
                // Create the dialog
                let popup = PopupDialog(title: title, message: message, image: UIImage(named: "financialServicesMortgage"))
                
                // Create buttons
                let buttonOne = CancelButton(title: "Cancel") {
                }
                
                let buttonTwo = DefaultButton(title: "Start Call") {
                    let defaults = UserDefaults.standard
                    
                    ALLoadingView.manager.showLoadingView(ofType: .messageWithIndicator)
                    ALLoadingView.manager.backgroundColor = UIColor.black
                    ALLoadingView.manager.messageText = "Connecting to Agent"
                    
                    SparkMediaHelper.retrieveGuestToken(name: defaults.string(forKey: "guestIdentificationString")!, token: { (token) in
                        let wxt = WXTKit(apiKey: token, authType: .guestId)
                        wxt.activate(authenticationStatus: { (authenticated) in
                            if authenticated {
                                wxt.videoCall(navigationController: self.navigationController!, recipient: defaults.string(forKey: "recipientUri")!, delegate: self)
                                ALLoadingView.manager.hideLoadingView()
                            }
                        })
                    })
                }
                
                popup.addButtons([buttonOne, buttonTwo])
                
                // Present dialog
                self.present(popup, animated: true, completion: nil)
        }
    }
    
    func callDidComplete() {
        print("Call did complete")
        let signatureVC = EPSignatureViewController(signatureDelegate: self, showsDate: true, showsSaveSignatureOption: true)
        signatureVC.subtitleText = "I agree to the terms and conditions"
        signatureVC.title = "Confidentiality Agreement"
        signatureVC.tintColor = self.themeColour
        let nav = UINavigationController(rootViewController: signatureVC)
        self.present(nav, animated: true, completion: nil)
    }
    
    func epSignature(_: EPSignatureViewController, didSign signatureImage: UIImage, boundingRect: CGRect) {
        print("Did Sign")
        self.dismiss(animated: true, completion: nil)
//        let headers: HTTPHeaders = [
//            "Content-Type": "application/json; charset=utf-8",
//            "Authorization": "Bearer \(UserDefaults.standard.string(forKey: "recipientUri")!)"
//        ]
//        
//        let parameters: Parameters = ["personId": UserDefaults.standard.string(forKey: "recipientUri")!, "text": "Wet Signature"]
//        
//        Alamofire.upload(multipartFormData: { (multipartFormData) in
//            multipartFormData.append(signatureImage, withName: "signature.jpg", fileName: "signature.jpg", mimeType: "image/jpg")
//        }, with: "https://api.ciscospark.com/v1/messages" , encodingCompletion: { (result) in
//            
//            switch result {
//            case .success(let upload, _, _):
//                
//                upload.responseJSON { response in
//                    print(response.request)  // original URL request
//                    print(response.response) // URL response
//                    print(response.data)     // server data
//                    print(response.result)   // result of response serialization
//                    if let JSON = response.result.value {
//                        print("JSON: \(JSON)")
//                    }
//                }
//                
//            case .failure(let encodingError):
//                print(encodingError)
//            }
//            
//        })

    }
    
    func callFailed(withError: String) {
        print("Call Failed with Error")
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
