//
//  MessagingMenuViewController.swift
//  SparkMediaSDKSampler
//
//  Created by jonfiel on 05/07/2018.
//  Copyright © 2018 JonathanField. All rights reserved.
//

import UIKit
import AABlurAlertController

class MessagingMenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let vc = AABlurAlertController()
        
        vc.addAction(action: AABlurAlertAction(title: "Dismiss", style: AABlurActionStyle.modernCancel) { _ in
            print("cancel")
            self.dismiss(animated: true, completion: nil)
        })
        vc.addAction(action: AABlurAlertAction(title: "Chat", style: AABlurActionStyle.modern) { _ in
            print("start")
            // Read from persisted settings
            let defaults = UserDefaults.standard
            let wxt = WXTKit(apiKey: defaults.string(forKey: "sparkApiKey")!, authType: .wxtId)
            wxt.activate(authenticationStatus: { (authenticated) in
                if authenticated {
                    //self.navigationController?.isNavigationBarHidden = false
                    wxt.directMessage(navigationController: self.navigationController!, recipient: defaults.string(forKey: "messagingRecipientUri")!)
                }
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        //self.navigationController?.isNavigationBarHidden = true
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
