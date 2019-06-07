//
//  CustomerWebsiteViewController.swift
//  SparkMediaSDKSampler
//
//  Created by Jonathan Field on 20/02/2017.
//  Copyright © 2017 JonathanField. All rights reserved.
//

import UIKit
import PopupDialog
import MIFab
import Mixpanel

class CustomerWebsiteViewController: UIViewController, UIWebViewDelegate, WXTeamsCallingDelegate {

    @IBOutlet weak var webView: UIWebView!
    fileprivate var fab: MIFab!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = UserDefaults.standard.value(forKey: "customerName") as! String?
        self.setupButton()
        self.webView.delegate = self
        self.setupWebView(uri: self.checkWebAddress())
        Mixpanel.mainInstance().track(event: "Customer Website was Demoed", properties: ["Website" : UserDefaults.standard.string(forKey: "customerWebsiteURL")!, "Caller": UserDefaults.standard.string(forKey: "userEmailAddress")!, "Callee": UserDefaults.standard.string(forKey: "recipientUri")!])
        let props = [
            "Customer Website": UserDefaults.standard.string(forKey: "customerWebsiteURL")!,
            "Caller": UserDefaults.standard.string(forKey: "userEmailAddress")!,
            "Callee": UserDefaults.standard.string(forKey: "recipientUri")!
        ]
        
    }
    
    func setupButton() {
        var fabConfig = MIFab.Config()
        
        fabConfig.buttonImage = UIImage(named: "wbxTeams")
        fabConfig.buttonBackgroundColor = UIColor(red: 107/255, green: 249/255, blue: 147/255, alpha: 1.0)
        
        fab = MIFab(
            parentVC: self,
            config: fabConfig,
            options: [
                MIFabOption(
                    title: "Remote Assistance",
                    image: UIImage(named: "wbxTeams"),
                    backgroundColor: UIColor(red: 107/255, green: 249/255, blue: 147/255, alpha: 1.0),
                    tintColor: UIColor.white,
                    actionClosure: {
                       self.startVideoCall()
                }
                )
            ]
        )
        fab.showButton(animated: true)
    }
    
    @IBAction func homeButtonPressed(_ sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    func startVideoCall() {
        // Prepare the popup assets
        let title = "Video Call"
        let message = "Are you ready to start a Video Call?"
        
        // Create the dialog
        let popup = PopupDialog(title: title, message: message, image: UIImage(named: "customerWebsiteCallPreview"))
        
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

    
    func checkWebAddress() -> String{
        let defaults = UserDefaults.standard
        let uri = defaults.value(forKey: "customerWebsiteURL")
        return uri as! String

    }
    
    func setupWebView(uri: String) {
         let url = URL(string: uri)
         let urlRequest = URLRequest(url: url! as URL)
         self.webView.loadRequest(urlRequest)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func callDidComplete() {
        print("Call did complete")
    }
    
    func callFailed(withError: String) {
        print("Call Failed with Error")
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
