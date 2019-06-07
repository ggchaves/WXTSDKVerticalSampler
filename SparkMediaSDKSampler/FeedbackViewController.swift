//
//  FeedbackViewController.swift
//  SparkMediaSDKSampler
//
//  Created by Jonathan Field on 20/07/2017.
//  Copyright © 2017 JonathanField. All rights reserved.
//

import UIKit

class FeedbackViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: "homeButtonPressed:")
        self.webView.loadRequest(URLRequest(url: URL(string: "http://cs.co/sparkapidemowins")!))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func homeButtonPressed(_ sender: Any) {
        print("Print")
        self.navigationController?.dismiss(animated: true, completion: nil)
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
