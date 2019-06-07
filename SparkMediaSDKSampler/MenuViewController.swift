
//
//  MenuTableViewController.swift
//  SparkMediaSDKSampler
//
//  Created by Jonathan Field on 30/11/2016.
//  Copyright © 2016 JonathanField. All rights reserved.
//

import UIKit
import PopupDialog
import Mixpanel
import Device_swift
import APFeedBack
import CollectionViewSlantedLayout
import AABlurAlertController

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    let scenarios = NSArray(contentsOf:Bundle.main.url(forResource: "scenarios", withExtension: "plist")!)
    var roundButton = UIButton()
    var feedbackButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.roundButton = UIButton(type: .custom)
        self.roundButton.setTitleColor(UIColor.orange, for: .normal)
        self.roundButton.addTarget(self, action: #selector(ButtonClick(_:)), for: UIControlEvents.touchUpInside)
        self.view.addSubview(roundButton)
        
        self.feedbackButton = UIButton(type: .custom)
        self.feedbackButton.setTitleColor(UIColor.orange, for: .normal)
        self.feedbackButton.addTarget(self, action: #selector(showFeedback(_:)), for: UIControlEvents.touchUpInside)
        self.view.addSubview(feedbackButton)
        
        //self.showFloatingSettingsButton()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override var preferredStatusBarUpdateAnimation : UIStatusBarAnimation {
        return UIStatusBarAnimation.slide
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

     //MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.scenarios!.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "scenarioCell", for: indexPath) as! MenuTableViewCell
        let scenario = self.scenarios?.object(at: indexPath.row) as! NSDictionary
        cell.scenarioImageView.image = UIImage(named: scenario.value(forKey: "scenarioImageName") as! String)
        cell.scenarioLabel.text = scenario.value(forKey: "scenarioName") as! String?
        cell.segueIdentifier = scenario.value(forKey: "scenarioSegueIdentifier") as! String
        cell.textLabel?.layer.cornerRadius = 10
        let additionalSeparatorThickness = CGFloat(6)
        let additionalSeperator = UIView(frame: CGRect(x: 0, y: cell.frame.size.height - additionalSeparatorThickness, width: cell.frame.size.width, height: additionalSeparatorThickness))
        additionalSeperator.backgroundColor = UIColor.black
        cell.addSubview(additionalSeperator)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var rowHeight = 0.0
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad && UIScreen.main.nativeBounds.size.height == 2732) {
            rowHeight = 560.0
        }
        else if (UIDevice.current.deviceType == .iPad2 || UIDevice.current.deviceType == .iPad3 || UIDevice.current.deviceType == .iPad3 || UIDevice.current.deviceType == .iPad4 || UIDevice.current.deviceType == .iPadAir || UIDevice.current.deviceType == .iPadAir2 || UIDevice.current.deviceType == .iPadMini || UIDevice.current.deviceType == .iPadMiniRetina || UIDevice.current.deviceType == .iPadMini3 || UIDevice.current.deviceType == .iPadMini4) {
            rowHeight = 350.0
        }
        else {
            rowHeight = 200.0
        }
        return CGFloat(rowHeight)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let scenario = self.scenarios?.object(at: indexPath.row) as! NSDictionary
        if scenario.value(forKey: "scenarioIsActive") as! Bool {
            if scenario.value(forKey: "scenarioSegueIdentifier") as! String != "scenarioMessaging" {
                if self.shouldPerformSegue(withIdentifier: scenario.value(forKey: "scenarioSegueIdentifier") as! String, sender: nil) {
                    self.performSegue(withIdentifier: scenario.value(forKey: "scenarioSegueIdentifier") as! String, sender: nil)
                }
            }
            else {
                // Its the Messaging Scenario which requires a manual override of a Navigation Controller
                self.pushMessagingController()
            }
        } else {
            let popUp = PopupDialog(title: "Sorry", message: "The \(scenario.value(forKey: "scenarioName")!) Scenario is not ready yet\n(Its coming soon Joe! 😉)")
            self.present(popUp, animated: true, completion: nil)
        }
    }
    
    func showFloatingSettingsButton() {
        
        self.roundButton = UIButton(type: .custom)
        self.roundButton.setTitleColor(UIColor.orange, for: .normal)
        self.roundButton.addTarget(self, action: #selector(ButtonClick(_:)), for: UIControlEvents.touchUpInside)
        self.view.addSubview(roundButton)
        
//        let share = ActionButtonItem(title: "share", image: UIImage(named: "settingsIcon"))
//        share.action = { item in print("Sharing...") }
//
//        let email = ActionButtonItem(title: "email", image: UIImage(named: "settingsIcon"))
//        email.action = { item in print("Email...") }
//
//        let actionButton = ActionButton(attachedToView: self.tableView, items: [share, email])
//        actionButton.action = { button in button.toggleMenu() }
        
    }
    
    override func viewWillLayoutSubviews() {
        
        roundButton.layer.cornerRadius = roundButton.layer.frame.size.width/2
        roundButton.backgroundColor = UIColor.lightGray
        roundButton.clipsToBounds = true
        roundButton.setImage(UIImage(named:"settings"), for: .normal)
        roundButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            roundButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -3),
            roundButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -53),
            roundButton.widthAnchor.constraint(equalToConstant: 50),
            roundButton.heightAnchor.constraint(equalToConstant: 50)])
        
        feedbackButton.layer.cornerRadius = roundButton.layer.frame.size.width/2
        feedbackButton.backgroundColor = UIColor(red: 57.0/255.0, green: 60.0/255.0, blue: 66.0/255.0, alpha: 1.0)
        feedbackButton.clipsToBounds = true
        feedbackButton.setImage(UIImage(named:"feedback"), for: .normal)
        feedbackButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            feedbackButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -3),
            feedbackButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -113),
            feedbackButton.widthAnchor.constraint(equalToConstant: 50),
            feedbackButton.heightAnchor.constraint(equalToConstant: 50)])
    }
    
    /** Action Handler for button **/
    
    @IBAction func ButtonClick(_ sender: UIButton){
        self.performSegue(withIdentifier: "toSettings", sender: nil)
    }
    
    func getEmailDomain(s: String) -> String {
        var v = s.components(separatedBy: "@").last?.components(separatedBy: ".")
        v?.removeLast()
        
        return (v!.last)!
    }
    
    @IBAction func showFeedback(_ sender: UIButton){
        
        let emailAddress = UserDefaults.standard.string(forKey: "userEmailAddress")
        
        if self.getEmailDomain(s: emailAddress!) == "cisco" {

            let title = "Send Feedback"
            let message = "You can send feedback on this app by choosing the option below. \n\nAlso if this App helped you to Win a deal, we'd love to hear about it!"
            let image = UIImage(named: "pexels-photo-103290")
            
            let popup = PopupDialog(title: title, message: message, image: image)
            
            let buttonOne = CancelButton(title: "Cancel") {
                print("You canceled the car dialog.")
            }
            
            let buttonTwo = DefaultButton(title: "Did this App Help You Win?", height: 60) {
                self.performSegue(withIdentifier: "showFeedback", sender: nil)
            }
            
            let buttonThree = DefaultButton(title: "Send Feedback about the App", height: 60) {
                let feedback = APFeedTableViewController()
                feedback.mailHTML = true
                let nav = UINavigationController(rootViewController: feedback)
                self.present(nav, animated: true, completion: nil)
            }
            
            popup.addButtons([buttonOne, buttonTwo, buttonThree])
            self.present(popup, animated: true, completion: nil)
            
        } else {
            let feedback = APFeedTableViewController()
            feedback.mailHTML = true
            let nav = UINavigationController(rootViewController: feedback)
            self.present(nav, animated: true, completion: nil)
        }
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        print("Should perform segue?")
        let defaults = UserDefaults.standard
        var shouldPerformSegue: Bool = true

        guard let emailAddress = defaults.value(forKey: "userEmailAddress") else {
            self.showPopupMissingEmailAddress()
            shouldPerformSegue = false
            return false
        }
        guard let recipient = defaults.value(forKey: "recipientUri") else {
            self.showPopupMissingRecipient(title: "Missing Recipient", message: "You need to enter the recipient that will recieve the Spark Call, you can add this in Settings in the Recipient URI Field. This can be either the email address of a Spark account, a SIP URI (prefixed with sip: e.g. sip:jonfiel@cisco.com) or a PSTN number if you have Spark/Hybrid Call services activated.")
            shouldPerformSegue = false
            return false
        }
        if identifier == "scenarioCustomerWebsite" {
        guard let webUri = defaults.value(forKey: "customerWebsiteURL") else {
            self.showPopup(title: "Missing Customer Website URL", message: "In order for this scenario to function, you need to add the Customers Website URL in the Settings Menu")
            shouldPerformSegue = false
            return false
            }
        }
        Mixpanel.mainInstance().people.set(property: "Email",
                                           to: UserDefaults.standard.string(forKey: "userEmailAddress")!)
        Mixpanel.mainInstance().registerSuperProperties(["Email": UserDefaults.standard.string(forKey: "userEmailAddress")!])
        Mixpanel.mainInstance().track(event: identifier, properties: ["Vertical" : identifier])
        let profile: Dictionary<String, String> = [
            "Name": UserDefaults.standard.string(forKey: "userEmailAddress")!,
            "Email": UserDefaults.standard.string(forKey: "userEmailAddress")!,
            "DefaultReceipient": UserDefaults.standard.string(forKey: "recipientUri")!
        ]
        
        // event with properties
        let props = [
            "Vertical": identifier
        ]
            
        return shouldPerformSegue
    }
    
    func showPopupMissingEmailAddress() {
        let alertController = UIAlertController(title: "Email Address", message: "Please input your Email Address:", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
            if let field = alertController.textFields?[0] {
                // store your data
                UserDefaults.standard.set(field.text, forKey: "userEmailAddress")
                UserDefaults.standard.synchronize()
            } else {
                
            }
        }
        
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
//            UserDefaults.standard.set("refused@cisco.com", forKey: "userEmailAddress")
//            UserDefaults.standard.synchronize()
//        }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Email Address"
        }
        
        alertController.addAction(confirmAction)
        //alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showPopup(title: String, message: String) {
        let popup = PopupDialog(title: title, message: message)
        let cancelButton = CancelButton(title: "Cancel") {}
        let settingsButton = DefaultButton(title: "Add your own Token in Settings") {
            self.performSegue(withIdentifier: "toSettings", sender: nil)
        }
        popup.addButtons([settingsButton, cancelButton])
        self.present(popup, animated: true, completion: nil)
    }
    
    func showPopupMissingRecipient(title: String, message: String) {
        let popup = PopupDialog(title: title, message: message)
        let cancelButton = CancelButton(title: "Cancel") {}
        let settingsButton = DefaultButton(title: "Add a Recipient in Settings") {
            self.performSegue(withIdentifier: "toSettings", sender: nil)
        }
        let autoConfigureDemoRecipient = DefaultButton(title: "Recipient EBC Camera (Experimental)") {
            UserDefaults.standard.setValue(SparkMediaHelper.experimentalRecipientUri(), forKey: "recipientUri")
        }
        popup.addButtons([settingsButton, autoConfigureDemoRecipient, cancelButton])
        self.present(popup, animated: true, completion: nil)
    }
    
    func showPopupMissingApiKey(title: String, message: String) {
        let popup = PopupDialog(title: title, message: message)
        let cancelButton = CancelButton(title: "Cancel") {}
        let settingsButton = DefaultButton(title: "Add your own Token in Settings") {
            self.performSegue(withIdentifier: "toSettings", sender: nil)
        }
        let autoConfigureTokenButton = DefaultButton(title: "Auto Token (Experimental)") {
            UserDefaults.standard.setValue(SparkMediaHelper.experimentalSparkIdToken(), forKey: "sparkApiKey")
        }
        popup.addButtons([settingsButton, autoConfigureTokenButton, cancelButton])
        self.present(popup, animated: true, completion: nil)
    }
    
    func pushMessagingController() {
        let vc = AABlurAlertController()
        
        vc.addAction(action: AABlurAlertAction(title: "Dismiss", style: AABlurActionStyle.modernCancel) { _ in
            print("cancel")
            self.dismiss(animated: true, completion: nil)
        })
        vc.addAction(action: AABlurAlertAction(title: "Chat", style: AABlurActionStyle.modern) { _ in
            print("start")
            let defaults = UserDefaults.standard
            
            ALLoadingView.manager.showLoadingView(ofType: .messageWithIndicator)
            ALLoadingView.manager.backgroundColor = UIColor.black
            ALLoadingView.manager.messageText = "Connecting to Agent"
            
            SparkMediaHelper.retrieveGuestToken(name: defaults.string(forKey: "guestIdentificationString")!, token: { (token) in
                let wxt = WXTKit(apiKey: token, authType: .guestId)
                wxt.activate(authenticationStatus: { (authenticated) in
                    if authenticated {
                        let messagingController = WXTeamsDirectMessageViewController(recipient: defaults.string(forKey: "messagingRecipientUri")!)
                        var preChatMessages = [String]()
                        preChatMessages.append("Esta Ud ahora conectado con Agente Bot. 👨‍💼 👋")
                        preChatMessages.append("Tenga en consideración que el contenido de este chat puede ser grabado para efectos de capacitación y considerarciones legales.")
                        messagingController.preChatMessages = preChatMessages
                        let navController = UINavigationController(rootViewController: messagingController)
                        self.present(navController, animated: true, completion: nil)
                        
                        ALLoadingView.manager.hideLoadingView()
                        
                    }
                })
            })
        })
        
        vc.alertStyle = AABlurAlertStyle.modern
        vc.topImageStyle = AABlurTopImageStyle.fullWidth
        vc.blurEffectStyle = .light
        vc.alertImage.image = UIImage(named: "topperOrange")
        vc.imageHeight = 110
        vc.alertImage.contentMode = .scaleAspectFill
        vc.alertImage.layer.masksToBounds = true
        vc.alertTitle.text = "Live Chat"
        vc.alertSubtitle.text = "Lets Chat and get this issue sorted out for you"
        self.present(vc, animated: true, completion: nil)
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
