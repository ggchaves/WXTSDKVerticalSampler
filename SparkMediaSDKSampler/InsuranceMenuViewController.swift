//
//  InsuranceMenuViewController.swift
//  SparkMediaSDKSampler
//
//  Created by Jonathan Field on 24/07/2017.
//  Copyright © 2017 JonathanField. All rights reserved.
//

import UIKit

class InsuranceMenuViewController: UIViewController {

    @IBOutlet weak var itemButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        self.itemButton.title = "Hello"
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ButtonPressed(_ sender: Any) {
        
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
