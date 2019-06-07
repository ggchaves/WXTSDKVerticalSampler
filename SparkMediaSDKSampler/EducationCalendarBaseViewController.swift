//
//  EducationCalendarBaseViewController.swift
//  SparkMediaSDKSampler
//
//  Created by Jonathan Field on 21/02/2018.
//  Copyright © 2018 JonathanField. All rights reserved.
//

import UIKit
import RVCalendarWeekView
import ASBottomSheet
import AABlurAlertController
import DateToolsSwift

class EducationCalendarBaseViewController: UIViewController, MSWeekViewDelegate, WXTeamsCallingDelegate {
    
    @IBOutlet weak var weekView: MSWeekView!
    let calendar = NSCalendar.autoupdatingCurrent

    override func viewDidLoad() {
        super.viewDidLoad()
        weekView.delegate = self
        weekView.daysToShowOnScreen = 1
       
        
        let now = Date.init()
        let minutes: Double = 90
        let add90MinsDate = now.addingTimeInterval(minutes * 60)
        
        let event1 = MSEvent(start: calendar.date(byAdding:.hour, value: -12, to: NSDate() as Date!), end: calendar.date(byAdding:.hour, value: -12, to: add90MinsDate))
        event1?.title = "REQ10410 - Interview Candidate John Doe"
        event1?.location = "@webex"
        
        
        let event2 = MSEvent(start: calendar.date(byAdding:.hour, value: -12, to: now.addingTimeInterval(100 * 60)), end: calendar.date(byAdding:.hour, value: -12, to: now.addingTimeInterval(190 * 60)))
        event2?.title = "REQ10410 - Interview Candidate David Busters"
        event2?.location = "@Webex"
        
        let event3 = MSEvent(start: calendar.date(byAdding:.hour, value: -12, to: now.addingTimeInterval(220 * 60)), end: calendar.date(byAdding:.hour, value: -12, to: now.addingTimeInterval(270 * 60)))
        event3?.title = "REQ10410 - Interview Jimmy Fallon"
        event3?.location = "@Webex"
        
        
        self.weekView.events = [event1!, event2!, event3!]
   
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getNewDateAfterAddingHours(hoursToAdd:NSInteger, oldDate:Date) -> Date {

        let calendar = Calendar.current
        let newDate = calendar.date(byAdding: .hour, value: hoursToAdd, to: oldDate)
        return newDate!
    }
    
    func weekView(_ sender: Any!, eventSelected eventCell: MSEventCell!) {
        print(eventCell.event.title)
        
        let vc = AABlurAlertController()
        
        vc.addAction(action: AABlurAlertAction(title: "Dismiss", style: AABlurActionStyle.modernCancel) { _ in
            print("cancel")
        })
        vc.addAction(action: AABlurAlertAction(title: "Join", style: AABlurActionStyle.modern) { _ in
            print("start")
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
        })
        
        vc.alertStyle = AABlurAlertStyle.modern
        vc.topImageStyle = AABlurTopImageStyle.fullWidth
        vc.blurEffectStyle = .light
        vc.alertImage.image = UIImage(named: "topper")
        vc.imageHeight = 110
        vc.alertImage.contentMode = .scaleAspectFill
        vc.alertImage.layer.masksToBounds = true
        vc.alertTitle.text = eventCell.event.title
        vc.alertSubtitle.text = "Are you ready to join the Interview with Cisco Webex?"
        self.present(vc, animated: true, completion: nil)
    }
    
    func weekView(_ weekView: MSWeekView!, onTapAt date: Date!) {
        print("tapped")
    }
    
    @IBAction func done(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
