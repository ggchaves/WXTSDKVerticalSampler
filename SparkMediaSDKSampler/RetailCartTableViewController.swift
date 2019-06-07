//
//  RetailCartTableViewController.swift
//  SparkMediaSDKSampler
//
//  Created by Jonathan Field on 13/04/2017.
//  Copyright © 2017 JonathanField. All rights reserved.
//

import UIKit
import PassKit

class RetailCartTableViewController: UITableViewController, PKPaymentAuthorizationViewControllerDelegate, WXTeamsCallingDelegate {
    
    let cart = RetailCart.sharedInstance.cartContents
    var paymentsEnabled: Bool = false
    private let merchantID = "merchant.cisco.SparkMediaSDKSampler"
    
    var paymentRequest: PKPaymentRequest!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Shopping Cart"
        //self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func support(_ sender : UIButton){
        self.paymentsEnabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowsInSection = 0
        if section == 0 {
            rowsInSection = RetailCart.sharedInstance.cartContents.count
        } else {
            rowsInSection = 1
        }
        return rowsInSection
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 58 : 145
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()

        switch indexPath.section {
        case 0:
            let itemCell = self.tableView.dequeueReusableCell(withIdentifier: "itemCell") as! RetailCartItemTableViewCell
            let cartItem = self.cart.object(at: indexPath.row) as! RetailCartItem
            print("Cart Item: \n \(cartItem)")
            itemCell.quantity.text = "\(cartItem.quantity) x"
            itemCell.itemName.text = cartItem.productForCartItem().value(forKey: "productName") as! String
            let productCost = Int(cartItem.productForCartItem().value(forKey: "productPriceRaw") as! NSNumber)
            print("Item")
            print(cartItem.productForCartItem())
            itemCell.cost.text = "$\(productCost * cartItem.quantity)"
            itemCell.selectionStyle = .none
            return itemCell
        case 1:
            let paymentCell = self.tableView.dequeueReusableCell(withIdentifier: "totalCell") as! RetailCartTotalTableViewCell
            paymentCell.totalAmount.text = RetailCart.sharedInstance.cartTotalCost()
            paymentCell.selectionStyle = .none
            return paymentCell
        default:
            cell.textLabel?.text = ""
        }
        return cell
    }
 
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title = ""
        switch section {
        case 0:
            title = "Cart"
        case 1:
            title = "Payment Options"
        default:
            title = ""
        }
        return title
    }

    @IBAction func applePayButtonPressed(_ sender: UIButton) {
        if (paymentsEnabled) {
        print("Pressed")
        let paymentNetworks = [PKPaymentNetwork.amex, .visa, .masterCard, .discover, .chinaUnionPay, .JCB]
        if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: paymentNetworks) {
            self.paymentRequest = PKPaymentRequest()
            self.paymentRequest.currencyCode = "USD"
            self.paymentRequest.countryCode = "US"
            self.paymentRequest.merchantIdentifier = merchantID
            self.paymentRequest.supportedNetworks = paymentNetworks
            self.paymentRequest.merchantCapabilities = .capability3DS
            self.paymentRequest.requiredShippingAddressFields = .all
            self.paymentRequest.paymentSummaryItems = RetailCart.sharedInstance.paymentSummaryCartItems()
            
            let contact = PKContact()
            let name = NSPersonNameComponents()
            name.givenName = "Joe"
            name.familyName = "Fu"
            contact.name = name as PersonNameComponents
            contact.emailAddress = "joe@fu.com"
            contact.phoneNumber = CNPhoneNumber(stringValue: "+1 555-1234")
            
            let address = CNMutablePostalAddress()
            address.street = "Cisco - Building 21 771 Alder Dr"
            address.city = "Milpitas"
            address.state = "CA"
            address.postalCode = "95035"
            address.country = "United States"
            
            contact.postalAddress = address
            paymentRequest.shippingContact = contact
            paymentRequest.billingContact = contact
            
            paymentRequest.shippingMethods = self.shippingMethods()
            
            let applePay = PKPaymentAuthorizationViewController(paymentRequest: self.paymentRequest)
            applePay.delegate = self
            self.present(applePay, animated: true, completion: nil)
        } else {
            print("No payment method setup")
            let alertController = UIAlertController(title: "Apple Pay", message: "No Apply Payment Cards found on your device. Please add a Payment Card to Apple Pay to continue with Payment", preferredStyle: UIAlertControllerStyle.alert) //Replace UIAlertControllerStyle.Alert by UIAlertControllerStyle.alert
            let DestructiveAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive) {
                (result : UIAlertAction) -> Void in
            }
        
            let okAction = UIAlertAction(title: "Add Payment Card", style: UIAlertActionStyle.default) {
                (result : UIAlertAction) -> Void in
                PKPassLibrary().openPaymentSetup()
            }
            
            alertController.addAction(DestructiveAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            }
        } else {
            let alertController = UIAlertController(title: "Payment Processing Error", message: "Your account is currently blocked from making purchases. You can contact support directly through this app at no cost.", preferredStyle: UIAlertControllerStyle.alert) //Replace UIAlertControllerStyle.Alert by UIAlertControllerStyle.alert
            let DestructiveAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive) {
                (result : UIAlertAction) -> Void in
            }
            
            let okAction = UIAlertAction(title: "Call Support", style: UIAlertActionStyle.default) {
                (result : UIAlertAction) -> Void in
                let defaults = UserDefaults.standard
                SparkMediaHelper.retrieveGuestToken(name: defaults.string(forKey: "guestIdentificationString")!, token: { (token) in
                    let wxt = WXTKit(apiKey: token, authType: .guestId)
                    
                    ALLoadingView.manager.showLoadingView(ofType: .messageWithIndicator)
                    ALLoadingView.manager.backgroundColor = UIColor.black
                    ALLoadingView.manager.messageText = "Connecting to Agent"
                    
                    wxt.activate(authenticationStatus: { (authenticated) in
                        if authenticated {
                            wxt.videoCall(navigationController: self.navigationController!, recipient: defaults.string(forKey: "recipientUri")!, delegate: self)
                            ALLoadingView.manager.hideLoadingView()
                        }
                    })
                })
            }
            
            alertController.addAction(DestructiveAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func callDidComplete() {
        self.paymentsEnabled = true
    }
    
    func callFailed(withError: String) {
        self.paymentsEnabled = true
    }
    
    func shippingMethods() -> [PKShippingMethod] {
        let sameDayShipping = PKShippingMethod(label: "Same Day Shipping", amount: 9.99)
        sameDayShipping.identifier = "sameDay"
        sameDayShipping.detail = "Delivers Today"
        let nextBusinessDayShipping = PKShippingMethod(label: "Next Business Day Shipping", amount: 3.99)
        nextBusinessDayShipping.identifier = "nbDay"
        nextBusinessDayShipping.detail = "Delivers Tomorrow"
        let freeShipping = PKShippingMethod(label: "Free Shipping", amount: 0)
        freeShipping.identifier = "free"
        freeShipping.detail = "Delivers Next Week"
        return [sameDayShipping, nextBusinessDayShipping, freeShipping]
    }
    
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController,
                                                     didSelect shippingMethod: PKShippingMethod,
                                                     completion: @escaping (PKPaymentAuthorizationStatus, [PKPaymentSummaryItem]) -> Void) {
        completion(.success, RetailCart.sharedInstance.paymentSummaryCartItems(shippingType: shippingMethod.amount))
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        completion(PKPaymentAuthorizationStatus.success)
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true) { 
            
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return indexPath.section == 0 ? true : false
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            RetailCart.sharedInstance.cartContents.removeObject(at: indexPath.row)
            self.tableView.reloadData()
        }
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
