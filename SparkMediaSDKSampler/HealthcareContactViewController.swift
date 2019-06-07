//
//  HealthcareContactViewController.swift
//  SparkMediaSDKSampler
//
//  Created by Jonathan Field on 28/05/2017.
//  Copyright © 2017 JonathanField. All rights reserved.
//

import UIKit
import PopupDialog

class HealthcareContactViewController: UIViewController, WXTeamsCallingDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func searchTapped(sender:UIButton) {
        print("search pressed")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startVideoCall(_ sender: UIButton) {
        // Prepare the popup assets
        let title = "Remote Medical Consultation"
        let message = "Are you ready to start the call?"
        
        // Create the dialog
        let popup = PopupDialog(title: title, message: message, image: nil)
        
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
    
    func callDidComplete() {
        
    }
    
    func callFailed(withError: String) {
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
