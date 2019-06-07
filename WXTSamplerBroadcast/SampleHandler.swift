//
//  SampleHandler.swift
//  WXTSamplerBroadcast
//
//  Created by jonfiel on 11/09/2018.
//  Copyright © 2018 JonathanField. All rights reserved.
//

import ReplayKit
import SparkBroadcastExtensionKit

class SampleHandler: RPBroadcastSampleHandler {

    override func broadcastStarted(withSetupInfo setupInfo: [String : NSObject]?) {
        // User has requested to start the broadcast. Setup info from the UI extension can be supplied but optional.
        SparkBroadcastExtension.sharedInstance.start(applicationGroupIdentifier: "group.sdksampler.jonf") {
            error in
            if let sparkError = error {
                switch sparkError {
                case .illegalStatus(let reason):
                    self.finishBroadcastWithError(NSError.init(domain: "ScreenShare", code: -1, userInfo: [NSLocalizedFailureReasonErrorKey:reason]))
                default:
                    break
                }
            } else {
                SparkBroadcastExtension.sharedInstance.onError = {
                    error in
                    print("=====Client onError :\(error)====")
                }
                
                SparkBroadcastExtension.sharedInstance.onStateChange = {
                    state in
                    print("=====Client onStateChange :\(state.rawValue)====")
                    if state == .Stopped {
                        self.finishBroadcastWithError(NSError.init(domain: "ScreenShare", code: 0, userInfo: [NSLocalizedFailureReasonErrorKey:"stop screen boradcasting."]))
                    }
                    
                }
            }
        }
    }
    
    override func broadcastPaused() {
        // User has requested to pause the broadcast. Samples will stop being delivered.
    }
    
    override func broadcastResumed() {
        // User has requested to resume the broadcast. Samples delivery will resume.
    }
    
    override func broadcastFinished() {
        // User has requested to finish the broadcast.
        SparkBroadcastExtension.sharedInstance.finish()
    }
    
    override func processSampleBuffer(_ sampleBuffer: CMSampleBuffer, with sampleBufferType: RPSampleBufferType) {
        switch sampleBufferType {
            case RPSampleBufferType.video:
                // Handle video sample buffer
                SparkBroadcastExtension.sharedInstance.handleVideoSampleBuffer(sampleBuffer: sampleBuffer)
                break
            case RPSampleBufferType.audioApp:
                // Handle audio sample buffer for app audio
                break
            case RPSampleBufferType.audioMic:
                // Handle audio sample buffer for mic audio
                break
        }
    }
}
