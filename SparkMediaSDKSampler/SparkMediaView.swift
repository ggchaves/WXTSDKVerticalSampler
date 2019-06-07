//
//  SparkMediaView.swift
//  SparkMediaView
//
//  The MIT License (MIT)
//
//  Created by Jonathan Field on 09/10/2016.
//  Copyright © 2016 Cisco. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import UIKit
import SparkSDK
import AVFoundation

/**
 Provides notifications when significant events take place during a video call
 - function callDidComplete: Triggered when the call ends regardless of the reason for call ending.
 - function callFailedWithError: Triggered when there was an error in setting up the call or there was an error with authentication
 */
public protocol SparkMediaViewDelegate: class {
    func callDidComplete()
    func callFailed(withError: String)
}

public class SparkMediaView: UIViewController {
    
    //Video Components
    @IBOutlet weak var remoteMediaView: MediaRenderView!
    @IBOutlet weak var localMediaView: MediaRenderView!
    
    //User Interface
    @IBOutlet weak var muteButton: UIButton!
    @IBOutlet weak var hangupButton: UIButton!
    @IBOutlet weak var rotateCameraButton: UIButton!
    @IBOutlet weak var callTimerLabel: UILabel!
    
    //Enums
    public enum AuthenticationStrategy {
        case sparkId, oAuth, appId
    }
    
    public enum MediaAccessType {
        case audio, audioVideo
    }
    
    //Call Variables
    var authenticationType: AuthenticationStrategy
    let apiKey: String!
    var callTimer: Timer!
    var currentCallDuration: Int = 0
    
    //Delegate
    weak var delegate:SparkMediaViewDelegate?
    
    //Initalizers
    public init(authType: AuthenticationStrategy, apiKey: String, delegate: SparkMediaViewDelegate?) {
        self.authenticationType = authType
        self.apiKey = apiKey
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.apiKey = String()
        self.authenticationType = .appId
        super.init(coder: aDecoder)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        let tapGestureRecogniser = UITapGestureRecognizer.init(target: self, action: #selector(tap))
        self.remoteMediaView.addGestureRecognizer(tapGestureRecogniser)
        
        let panGestureRecogniser = UIPanGestureRecognizer.init(target: self, action: #selector(repositionSelfView))
        self.localMediaView.addGestureRecognizer(panGestureRecogniser)
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Convenience Functions
    public func voiceCall(recipient: String!) {
        self.startSparkCall(authType: self.authenticationType, recipient: recipient, mediaAccessType: .audio)
    }
    
    public func videoCall(recipient: String!) {
        self.startSparkCall(authType: self.authenticationType ,recipient: recipient, mediaAccessType: .audioVideo)
    }
    
    /**
     Start a Call using the Spark Media SDK
     - parameter recipient: The Spark URI or SIP URI of the remote particpiant to be dialled
     - parameter mediaAccessType: The type of Media that will be sent to the remote party (Audio or Audio Video)
     */
    func startSparkCall(authType: AuthenticationStrategy, recipient: String, mediaAccessType: MediaAccessType) {
        
        self.authenticateWithSpark(apiKey: self.apiKey, authType: authType) { (attempted) in
            if attempted {
                self.registerDeviceWithSpark(mediaAccessType: mediaAccessType, successfulRegistration: { (success) in
                    
                    let session = AVAudioSession.sharedInstance()
                    if (session.responds(to: #selector(AVAudioSession.requestRecordPermission(_:)))) {
                        print("In")
                        AVAudioSession.sharedInstance().requestRecordPermission({(granted: Bool)-> Void in
                            if granted {
                                print("Granted")
                                self.startSparkCallTo(recipient: recipient, mediaAccessType: mediaAccessType)
                                                            } else{
                                print("not granted")
                            }
                        })
                    }
                    
                }) { (error) in
                    print("error in registration")
                    self.delegate?.callFailed(withError: "Unable to register with Spark, check your access token.")
                }
            }
        }
    }
    
    /**
     Initial Authentication to Spark
     - parameter apiKey: Spark Access Token from www.developer.ciscospark.com
     */
    func authenticateWithSpark(apiKey: String, authType: AuthenticationStrategy, authenticationAttempted: @escaping (_ attempted: Bool ) -> Void){
        if authType == .sparkId {
            SparkContext.initSparkForSparkIdLogin(apiKey: apiKey)
            authenticationAttempted(true)
        }
        else if authType == .appId {
            SparkContext.initSparkForJWTLogin(apiKey: apiKey)
            authenticationAttempted(true)
        }
        SparkContext.sharedInstance.spark?.phone.disableVideoCodecActivation()
    }
    
    /**
     Register this instance of the Media SDK with the Spark Cloud for Outgoing Calls
     - parameter mediaAccessType: The type of Media that will be sent to the remote party (Audio or Audio Video)
     - parameter successfulRegistration: Triggered if the instance of the Media SDK was registered with the Spark Cloud successfully
     - parameter unSuccessfulRegistration: Triggered if the instance of the Media SDK was unable to register with the Spark Cloud
     */
    func registerDeviceWithSpark(mediaAccessType: MediaAccessType, successfulRegistration: @escaping (_ successfulRegistration: String ) -> Void, unSuccessfulRegistration: @escaping (_ error: String) -> Void){
//        self.spark?.phone.requestMediaAccess(MediaAccessType.audioVideo) { granted in
//            if !granted {
//                print("not granted")
//            }
//        }
//        self.spark?.phone.register() { success in
//            if (success != nil) {
//                print("success")
//                successfulRegistration("success")
//            } else {
//                print("failure")
//                unSuccessfulRegistration("failed")
//            }
//        }
        SparkContext.sharedInstance.spark?.phone.register() { [weak self] success in
            if let strongSelf = self {
                if success == nil {
                    successfulRegistration("success")
                }
            }
        }
    }
    
    
    func initiateCall(recipient: String) {
        print("Make the calllllllll")
        //var mediaOption = MediaOption.audioOnly()
        //if VideoAudioSetup.sharedInstance.isVideoEnabled() {
            let mediaOption = MediaOption.audioVideo(local: self.localMediaView, remote: self.remoteMediaView)
        //}
        // Makes a call to an intended recipient on behalf of the authenticated user.
        SparkContext.sharedInstance.spark?.phone.dial(recipient, option: mediaOption) { [weak self] result in
            if let strongSelf = self {
                switch result {
                case .success(let call):
                    SparkContext.sharedInstance.call = call
                    // Callback when remote participant(s) is ringing.
                    call.onRinging = { [weak self] in
                        if let strongSelf = self {
                            print("Ringing")
                            //...
                        }
                    }
                    // Callback when remote participant(s) answered and this *call* is connected.
                    call.onConnected = { [weak self] in
                        if let strongSelf = self {
                            print("Connected")
                            self?.hideLoadingScreen()
                        }
                    }
                    //Callback when this *call* is disconnected (hangup, cancelled, get declined or other self device pickup the call).
                    call.onDisconnected = {[weak self] disconnectionType in
                        if let strongSelf = self {
                            self?.delegate?.callDidComplete()
                            self?.dismiss(animated: true, completion: nil)
                        }
                    }
                    // Callback when the media types of this *call* have changed.
                    call.onMediaChanged = {[weak self] mediaChangeType in
                        if let strongSelf = self {
                            switch mediaChangeType {
                            //Local/Remote video rendering view size has changed
                            case .localVideoViewSize,.remoteVideoViewSize:
                                break
                            // This might be triggered when the remote party muted or unmuted the audio.
                            case .remoteSendingAudio(let isSending):
                                break
                            // This might be triggered when the remote party muted or unmuted the video.
                            case .remoteSendingVideo(let isSending):
                                break
                            // This might be triggered when the local party muted or unmuted the video.
                            case .sendingAudio(let isSending):
                                break
                            // This might be triggered when the local party muted or unmuted the aideo.
                            case .sendingVideo(let isSending):
                                break
                            // Camera FacingMode on local device has switched.
                            case .cameraSwitched:
                                break
                            // Whether loud speaker on local device is on or not has switched.
                            case .spearkerSwitched:
                                break
                            default:
                                break
                            }
                        }
                    }
                case .failure(let error):
                    _ = strongSelf.navigationController?.popViewController(animated: true)
                    print("Dial call error: \(error)")
                }
            }
        }
    }

    
    /**
     Trigger the Spark call to start
     - parameter recipient: The Spark URI or SIP URI of the remote particpiant to be dialled
     - parameter mediaAccessType: The type of Media that will be sent to the remote party (Audio or Audio Video)
     */
    func startSparkCallTo(recipient: String, mediaAccessType: MediaAccessType){
        self.startCallTimer()
        print("Called")
        SparkContext.sharedInstance.spark?.phone.defaultFacingMode = .user
        self.showLoadingScreen(recipient: recipient)
        self.initiateCall(recipient: recipient)
//        self.spark?.phone.defaultFacingMode = .user
//        
//        let call = spark?.phone.dial(recipient, option: mediaAccessType == .audio ? MediaOption.audioOnly() : MediaOption.audioVideo(local: self.localMediaView, remote: self.remoteMediaView)) { [weak self] result in
//            if result.success {
//                self?.currentCall = result
//                if mediaAccessType == .audio {
////                    self.callTimerLabel.isHidden = false
////                    self.rotateCameraButton.isEnabled = false
////                    self.toggleButtonVisibilityState()
////                    self.handleSparkCallEvents()
//                }
//            }
//            else {
//                print("Failed to dial call.")
//                self.delegate?.callFailed(withError: "Failed to Dial, check your recipient has a valid address and that you have internet connectivity.")
//            }
//        }
        //self.currentCall = call
    }

    
    // Button Actions
    @IBAction func rotateCameraPressed(_ sender: UIButton) {
        if SparkContext.sharedInstance.call?.facingMode == .user {
            SparkContext.sharedInstance.call?.facingMode = .environment
            self.rotateCameraButton.setImage(UIImage(named: "rotate"), for: UIControlState())
        }
        else if SparkContext.sharedInstance.call?.facingMode == .environment {
            SparkContext.sharedInstance.call?.facingMode = .user
            self.rotateCameraButton.setImage(UIImage(named: "rotateActive"), for: UIControlState())
        }
    }
    
    @IBAction func hangupPressed(_ sender: UIButton) {
        self.view.backgroundColor = UIColor.black
        self.callTimerLabel.isHidden = true
        
        SparkContext.sharedInstance.call?.hangup(completionHandler: { (error) in
            if error == nil {
                SparkContext.sharedInstance.call?.hangup(completionHandler: { (error) in
                    SparkContext.sharedInstance.call = nil
                })
            }
            else {
                print("Unable to hangup call")
            }
        })
    }
    
    @IBAction func mutePressed(_ sender: UIButton) {
        var muteState: Bool
        if SparkContext.sharedInstance.call?.sendingAudio == true {
            muteState = false
        }
        else {
            muteState = true
        }
        
        SparkContext.sharedInstance.call?.sendingAudio = muteState
        if (SparkContext.sharedInstance.call?.sendingAudio == true) {
            self.muteButton.setImage(UIImage(named: "mute"), for: UIControlState())
        }
        else{
            self.muteButton.setImage(UIImage(named: "muteActive"), for: UIControlState())
        }
    }
    
    // Gesture Recognisers
    func tap(_ gestureRecognizer: UITapGestureRecognizer) {
        self.toggleButtonVisibilityState()
    }
    
    func repositionSelfView(_ gestureRecognizer: UIPanGestureRecognizer){
        self.updateLocalMediaView(sender: gestureRecognizer)
    }
    
    // UI Helpers
    func toggleButtonVisibilityState() {
        if self.muteButton.isHidden || self.hangupButton.isHidden || self.rotateCameraButton.isHidden {
            self.muteButton.isHidden = false
            self.hangupButton.isHidden = false
            self.rotateCameraButton.isHidden = false
            self.callTimerLabel.isHidden = false
        }
        else {
            self.muteButton.isHidden = true
            self.hangupButton.isHidden = true
            self.rotateCameraButton.isHidden = true
            self.callTimerLabel.isHidden = true
        }
    }
    
    func showLoadingScreen(recipient: String) {
        ALLoadingView.manager.blurredBackground = true
        ALLoadingView.manager.showLoadingView(ofType: .messageWithIndicatorAndCancelButton, windowMode: .fullscreen)
        ALLoadingView.manager.cancelCallback = {
            SparkContext.sharedInstance.call?.hangup(completionHandler: { (error) in
                print("Hangup Failed")
                self.dismiss(animated: true, completion: nil)
            })
        ALLoadingView.manager.hideLoadingView()
        }
    }
    
    func hideLoadingScreen() {
        ALLoadingView.manager.hideLoadingView()
    }
    
    func updateLocalMediaView(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view)
        sender.view!.center = CGPoint(x: sender.view!.center.x + translation.x, y: sender.view!.center.y + translation.y)
        sender.setTranslation(CGPoint.init(x: 0, y: 0), in: self.view)
        
    }
    
    func startCallTimer() {
        self.callTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (timer) in
            self.currentCallDuration += 1
            self.callTimerLabel.text = SparkMediaHelper.timeStringFromSeconds(currrentCallDuration: self.currentCallDuration)
        })
    }
    
    fileprivate func showPhoneRegisterFailAlert() {
        let alert = UIAlertController(title: "Alert", message: "Phone register fail", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}
