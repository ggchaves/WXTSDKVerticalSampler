//
//  RetailCart.swift
//  SparkMediaSDKSampler
//
//  Created by Jonathan Field on 13/04/2017.
//  Copyright © 2017 JonathanField. All rights reserved.
//

import Foundation
import PassKit

class RetailCart {
    static let sharedInstance = RetailCart()
    var cartContents = NSMutableArray(capacity: 15)
    
    func cartTotalCost() -> String {
        var cartValue = 0
        for currentItem in self.cartContents {
            let item = currentItem as! RetailCartItem
            print("The Item in the cart is: \(item)")
            cartValue = cartValue + (item.quantity * Int(item.productForCartItem().value(forKey: "productPriceRaw") as! NSNumber))
        }
        return "$\(cartValue)"
    }
    
    func cartTotalCost() -> Int {
        var cartValue = 0
        for currentItem in self.cartContents {
            let item = currentItem as! RetailCartItem
            print("The Item in the cart is: \(item)")
            cartValue = cartValue + (item.quantity * Int(item.productForCartItem().value(forKey: "productPriceRaw") as! NSNumber))
        }
        return cartValue
    }
    
    func paymentSummaryCartItems() -> [PKPaymentSummaryItem] {
        var paymentSummary = NSMutableArray()
        for currentItem in self.cartContents {
            let item = currentItem as! RetailCartItem
            
            let itemTotal = (item.quantity * Int(item.productForCartItem().value(forKey: "productPriceRaw") as! NSNumber))
            
            paymentSummary.add(PKPaymentSummaryItem(label: item.productForCartItem().value(forKey: "productName") as! String, amount: NSDecimalNumber(value: itemTotal)))
        }
        paymentSummary.add(PKPaymentSummaryItem(label: "Shipping", amount: 9.99))
        
        let defaults = UserDefaults.standard
        let storeName = defaults.value(forKey: "retailStoreName") as! String?
        if (storeName == nil) || storeName == "" {
            paymentSummary.add(PKPaymentSummaryItem(label: "Total", amount: NSDecimalNumber(value: self.cartTotalCost()).adding(9.99)))
        }
        else {
            paymentSummary.add(PKPaymentSummaryItem(label: storeName!, amount: NSDecimalNumber(value: self.cartTotalCost()).adding(9.99)))
        }
        return paymentSummary as! [PKPaymentSummaryItem]
    }
    
    func paymentSummaryCartItems(shippingType: NSDecimalNumber) -> [PKPaymentSummaryItem] {
        var paymentSummary = NSMutableArray()
        for currentItem in self.cartContents {
            let item = currentItem as! RetailCartItem
            
            let itemTotal = (item.quantity * Int(item.productForCartItem().value(forKey: "productPriceRaw") as! NSNumber))
            
            paymentSummary.add(PKPaymentSummaryItem(label: item.productForCartItem().value(forKey: "productName") as! String, amount: NSDecimalNumber(value: itemTotal)))
        }
        paymentSummary.add(PKPaymentSummaryItem(label: "Shipping", amount: shippingType))
        
        let defaults = UserDefaults.standard
        let storeName = defaults.value(forKey: "retailStoreName") as! String?
        if (storeName == nil) || storeName == "" {
            paymentSummary.add(PKPaymentSummaryItem(label: "Total", amount: NSDecimalNumber(value: self.cartTotalCost()).adding(shippingType)))
        }
        else {
            paymentSummary.add(PKPaymentSummaryItem(label: storeName!, amount: NSDecimalNumber(value: self.cartTotalCost()).adding(shippingType)))
        }
        return paymentSummary as! [PKPaymentSummaryItem]
    }
    
}
