//
//  RetailCartItem.swift
//  SparkMediaSDKSampler
//
//  Created by Jonathan Field on 13/04/2017.
//  Copyright © 2017 JonathanField. All rights reserved.
//

import UIKit

class RetailCartItem: NSObject {
    
    var productId: Int = 0
    var quantity: Int = 0
    
    func productForCartItem() -> NSDictionary {
        let products = NSArray(contentsOf:Bundle.main.url(forResource: "retailItems", withExtension: "plist")!)
        var product = NSDictionary()
        for temp in products! {
            let tempDict = temp as! NSDictionary
            let cartProductId = tempDict.value(forKey: "productId") as! NSNumber
            if self.productId ==  cartProductId.intValue{
                product = tempDict
            }
        }
        return product
    }

}
