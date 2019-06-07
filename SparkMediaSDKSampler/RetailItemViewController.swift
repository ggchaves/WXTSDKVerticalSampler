//
//  RetailItemViewController.swift
//  SparkMediaSDKSampler
//
//  Created by Jonathan Field on 07/01/2017.
//  Copyright © 2017 JonathanField. All rights reserved.
//

import UIKit
import PopupDialog
import AABlurAlertController

class RetailItemViewController: UIViewController, WXTeamsCallingDelegate {


    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productDescription: UITextView!
    @IBOutlet weak var itemQuantitySelector: UILabel!
    @IBOutlet weak var increaseQuantityButton: UIButton!
    @IBOutlet weak var decreaseQuantityButton: UIButton!
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    
    var product: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (self.product == nil) {
            let products = NSArray(contentsOf:Bundle.main.url(forResource: "retailItems", withExtension: "plist")!)
            self.product = products?.object(at: 0) as! NSDictionary
        }
        
        self.navigationItem.title = self.product.value(forKey: "productName") as! String?
        let basketButton = UIBarButtonItem(image: UIImage(named: "retailBasket"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(cartView(_:)))
        self.navigationItem.rightBarButtonItem = basketButton
        self.productImage.image = UIImage(named: self.product.value(forKey: "productImage") as! String)
        self.productName.text = self.product.value(forKey: "productName") as! String?
        self.productPrice.text = self.product.value(forKey: "productPrice") as! String?
        self.productDescription.text = self.product.value(forKey: "productDescription") as! String?
        let rightBarButtons = self.navigationItem.rightBarButtonItems
        let cartButtonItem = rightBarButtons?.last
        cartButtonItem?.addBadge(number: RetailCart.sharedInstance.cartContents.count)
        cartButtonItem?.addBadge(number: RetailCart.sharedInstance.cartContents.count)
        if UIDevice.current.deviceType == .iPhone5 || UIDevice.current.deviceType == .iPhone5S || UIDevice.current.deviceType == .iPhone5C || UIDevice.current.deviceType == .iPhoneSE {
            self.increaseQuantityButton.isHidden = true
            self.decreaseQuantityButton.isHidden = true
            self.itemQuantitySelector.isHidden = true
        }
        
//        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = (self.navigationController?.navigationBar.bounds)!
//        self.navigationController?.navigationBar.addSubview(blurEffectView)
        
        
        //self.increaseQuantityButton.bringSubview(toFront: self.blurView)
        
//        //only apply the blur if the user hasn't disabled transparency effects
//        if !UIAccessibilityIsReduceTransparencyEnabled() {
//            self.overlayView.backgroundColor = .clear
//
//            let blurEffect = UIBlurEffect(style: .dark)
//            let blurEffectView = UIVisualEffectView(effect: blurEffect)
//            //always fill the view
//            blurEffectView.frame = self.overlayView.bounds
//            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//
//            overlayView = blurEffectView
//        } else {
//            self.overlayView.backgroundColor = UIColor.gray
//        }
        
    }
    
    func cartView(_ sender : UIButton){
        self.performSegue(withIdentifier: "toCart", sender: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = self.product.value(forKey: "productName") as! String?
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func liveSupport(_ sender: UIButton) {
        
        let vc = AABlurAlertController()
        
        vc.addAction(action: AABlurAlertAction(title: "Dismiss", style: AABlurActionStyle.modernCancel) { _ in
            print("cancel")
        })
        vc.addAction(action: AABlurAlertAction(title: "Call", style: AABlurActionStyle.modern) { _ in
            print("start")
            let defaults = UserDefaults.standard
            SparkMediaHelper.retrieveGuestToken(name: defaults.string(forKey: "guestIdentificationString")!, token: { (token) in
                let wxt = WXTKit(apiKey: token, authType: .guestId)
                
                ALLoadingView.manager.showLoadingView(ofType: .messageWithIndicator)
                ALLoadingView.manager.backgroundColor = UIColor.black
                ALLoadingView.manager.messageText = "Connecting to Agent"
                
                wxt.activate(authenticationStatus: { (authenticated) in
                    if authenticated {
                        wxt.videoCall(navigationController: self.navigationController!, recipient: defaults.string(forKey: "recipientUri")!, delegate: self)
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
        vc.alertTitle.text = "Live Video Support"
        vc.alertSubtitle.text = "Lets jump on a call and get this issue sorted out for you"
        self.present(vc, animated: true, completion: nil)
    }
    
    func callDidComplete() {
        print("Call did complete")
    }
    
    func callFailed(withError: String) {
        print("Call Failed with Error")
    }
    
    @IBAction func addToOrder(_ sender: Any) {
        let productId = self.product.value(forKey: "productId") as! NSNumber
        let cartItem = RetailCartItem()
        cartItem.productId = productId.intValue
        cartItem.quantity = Int(self.itemQuantitySelector.text!)!
        RetailCart.sharedInstance.cartContents.add(cartItem)
        let rightBarButtons = self.navigationItem.rightBarButtonItems
        let cartButtonItem = rightBarButtons?.last
        cartButtonItem?.addBadge(number: RetailCart.sharedInstance.cartContents.count)
    }
    
    @IBAction func adjustItemQuantity(_ sender: UIButton) {
        let pressedButton = sender
        let currentQuantity = Int(self.itemQuantitySelector.text!)
        if pressedButton.tag == 100 {
            let updatedQuantity = currentQuantity! + 1
            if updatedQuantity <= 9 {
                self.adjustQuantityLabel(quantity: String(updatedQuantity))
            }
        }
        else if pressedButton.tag == 200 {
            let updatedQuantity = currentQuantity! - 1
            if updatedQuantity >= 0 {
                self.adjustQuantityLabel(quantity: String(updatedQuantity))
            }
        }
    }
    
    func adjustQuantityLabel(quantity: String) {
        self.itemQuantitySelector.text = quantity
    }
    
    func textToImage(drawText text: String, inImage image: UIImage, atPoint point: CGPoint) -> UIImage {
        let textColor = UIColor.white
        let textFont = UIFont(name: "Helvetica Bold", size: 38)!
        
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(image.size, false, scale)
        
        let textFontAttributes = [
            NSFontAttributeName: textFont,
            NSForegroundColorAttributeName: textColor,
            ] as [String : Any]
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        
        let rect = CGRect(origin: point, size: image.size)
        text.draw(in: rect, withAttributes: textFontAttributes)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.navigationItem.title = "Back"
    }
    

}
