//
//  SettingsViewController.swift
//  SparkMediaSDKSampler
//
//  Created by Jonathan Field on 08/01/2017.
//  Copyright © 2017 JonathanField. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import SwiftySettings

class Storage : SettingsStorageType {
    
    subscript(key: String) -> Bool? {
        get {
            return Defaults[key].bool
        }
        set {
            Defaults[key] = newValue
        }
    }
    subscript(key: String) -> Float? {
        get {
            return Float(Defaults[key].doubleValue)
        }
        set {
            Defaults[key] = newValue
        }
    }
    subscript(key: String) -> Int? {
        get {
            return Defaults[key].int
        }
        set {
            Defaults[key] = newValue
        }
    }
    subscript(key: String) -> String? {
        get {
            return Defaults[key].string
        }
        set {
            Defaults[key] = newValue
        }
    }
}

class SettingsViewController: SwiftySettingsViewController {
    
    var storage = Storage()

    override func viewDidLoad() {
        super.viewDidLoad()
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height - 44, width: UIScreen.main.bounds.size.width, height: 44))
        let saveButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(dismissSettingsController))
        let leftFlexibleSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let rightFlexibleSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([leftFlexibleSpace, saveButton, rightFlexibleSpace], animated: true)
        self.view.addSubview(toolBar)
        self.loadSettings()
    }
    
    func dismissSettingsController() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func loadSettings() {
        let coreSettings = Section(title: "Webex Teams API and Media SDK Setup")
        coreSettings.with(TextField(key: "userEmailAddress", title: "Your Email Address", secureTextEntry: false))
        coreSettings.with(TextField(key: "guestIdentificationString", title: "Guest Name (Optional)", secureTextEntry: false))
        coreSettings.with(TextField(key: "recipientUri", title: "Video Recipient URI (WXT Address, SIP URI or PSTN)", secureTextEntry: false))
        coreSettings.with(TextField(key: "messagingRecipientUri", title: "Messaging Recipient (WXT Address)", secureTextEntry: false))
        
        let retailSettings = Section(title: "Retail Scenario")
        retailSettings.with(TextField(key: "retailStoreName", title: "Retail Store Name", secureTextEntry: false))
        
        let providerOptions = OptionsButton(key: "creditCardProvider", title: "Card Provider")
        providerOptions.with(option: Option(title: "Visa", optionId: 1))
        providerOptions.with(option: Option(title: "Mastercard", optionId: 2))
        providerOptions.with(option: Option(title: "Maestro", optionId: 3))
        providerOptions.with(option: Option(title: "Cirrus", optionId: 4))
        providerOptions.with(option: Option(title: "American Express", optionId: 5))
        
        let themes = NSArray(contentsOf:Bundle.main.url(forResource: "financialThemes", withExtension: "plist")!)
        let financialThemeSelection = OptionsButton(key: "themeId", title: "Financial Scenario Theme Colour")
        for temp in themes! {
            let theme = temp as! NSDictionary
            let themeName = theme.value(forKey: "themeName") as! String
            let themeIdStringValue = theme.value(forKey: "themeId") as! String
            financialThemeSelection.with(option: Option(title: themeName , optionId: Int(themeIdStringValue)!))
        }
        
        let financialSettings = Section(title: "Financial Scenario")
        financialSettings.with(TextField(key: "bankName", title: "Bank Name", secureTextEntry: false))
        financialSettings.with(providerOptions)
        financialSettings.with(financialThemeSelection)
        
        let customerWebsiteSettings = Section(title: "Customer Website")
        customerWebsiteSettings.with(TextField(key: "customerName", title: "Customer Name", secureTextEntry: false))
        customerWebsiteSettings.with(TextField(key: "customerWebsiteURL", title: "Customer Website Address (WITH HTTPS://)", secureTextEntry: false))
        
        let mainScreen = Screen(title: "Webex Teams SDK Demo Settings")
        mainScreen.include(section: coreSettings)
        mainScreen.include(section: retailSettings)
        mainScreen.include(section: financialSettings)
        mainScreen.include(section: customerWebsiteSettings)
        
        settings = SwiftySettings(storage: self.storage, main: mainScreen)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
