//
//  SparkMediaHelper.swift
//  SparkMediaHelper
//
//  Created by Jonathan Field on 23/10/2016.
//  Copyright © 2016 Cisco. All rights reserved.
//

import UIKit
import SwiftMessages
import Alamofire

class SparkMediaHelper: NSObject {
    
    static func unableToRegisterWithSparkView() -> UIView {
        let view = MessageView.viewFromNib(layout: .CardView)
        view.configureTheme(.error)
        view.configureDropShadow()
        view.configureContent(title: "Error", body: "Unable to register with WXT, check your access token.")
        return view
    }
    
    static func timeStringFromSeconds(currrentCallDuration: Int) -> String {
        let minutes:Int = (currrentCallDuration / 60) % 60
        let seconds:Int = currrentCallDuration % 60
        let formattedTimeString = String(format: "%02u:%02u", minutes, seconds)
        return formattedTimeString
    }
    
    static func appIdToken() -> String {
        let credentials = NSDictionary(contentsOf:Bundle.main.url(forResource: "credentials", withExtension: "plist")!)
        return credentials?.value(forKey: "appIdToken") as! String
    }
    
    static func mixPanelToken() -> String {
        let credentials = NSDictionary(contentsOf:Bundle.main.url(forResource: "credentials", withExtension: "plist")!)
        return credentials?.value(forKey: "mixPanelToken") as! String
    }
    
    static func experimentalSparkIdToken() -> String {
        let credentials = NSDictionary(contentsOf:Bundle.main.url(forResource: "credentials", withExtension: "plist")!)
        return credentials?.value(forKey: "experimentalSparkId") as! String
    }
    
    static func experimentalRecipientUri() -> String {
        let credentials = NSDictionary(contentsOf:Bundle.main.url(forResource: "credentials", withExtension: "plist")!)
        return credentials?.value(forKey: "experimentalRecipientUri") as! String
    }
    
    static func experimentalCustomerWebsiteURL() -> String {
        let credentials = NSDictionary(contentsOf:Bundle.main.url(forResource: "credentials", withExtension: "plist")!)
        return credentials?.value(forKey: "experimentalCustomerWebsite") as! String
    }
    
    static func defaultMessagingAddress() -> String {
        let credentials = NSDictionary(contentsOf:Bundle.main.url(forResource: "credentials", withExtension: "plist")!)
        return credentials?.value(forKey: "defaultMessagingRecipient") as! String
    }
    
    static func defaultGuestIdentity() -> String {
        let credentials = NSDictionary(contentsOf:Bundle.main.url(forResource: "credentials", withExtension: "plist")!)
        return credentials?.value(forKey: "guestIdentificationString") as! String
    }
    
    static func retrieveGuestToken(name: String, token: @escaping (_ result: String) -> Void) {
        
        // Add Headers
        let headers = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "x-api-key":"BDbzrJY4xL16cBohvxV434vPjkU1v7CO6Ns0Y7iM",
            ]
        
        // JSON Body
        let body: [String : Any] = [
            "name": name,
            "sub": "\(arc4random_uniform(5000))"
        ]
        
        // Fetch Request
        Alamofire.request("https://7s6pizsaij.execute-api.us-west-2.amazonaws.com/dev/generate-jwt", method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                if (response.result.error == nil) {
//                    debugPrint("HTTP Response Body: \(response.data)")
                    if let result = response.result.value {
                        let JSON = result as! NSDictionary
                        token(JSON.value(forKey: "token") as! String)
                }
                else {
//                    debugPrint("HTTP Request failed: \(response.result.error)")
                }
            }
        }
    }
}
