//
//  SparkDirectMessageViewController.swift
//  SDKWrapperExample
//
//  Created by Jonathan Field on 09/04/2018.
//  Copyright © 2018 JonathanField. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import WebexSDK
import Photos
import PhotosUI
import MobileCoreServices
import AVKit

class WXTeamsDirectMessageViewController: JSQMessagesViewController, UIDocumentPickerDelegate {
    
    public var recipient: Person?
    public var incomingMessageBubbleColor: UIColor?
    public var outgoingMessageBubbleColor: UIColor?
    public var incomingMessageTextColor: UIColor?
    public var outgoingMessageTextColor: UIColor?
    
    fileprivate var messages = [JSQMessage]()
    var preChatMessages = [String]()
    fileprivate lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    fileprivate lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    public init(recipient: String) {
        self.recipient = nil
        super.init(nibName: nil, bundle: nil)
        self.personFromEmailAddress(emailAddress: recipient)
    }
    
    public init(recipient: String, incomingMessageBubbleColor: UIColor?, outgoingMessageBubbleColor: UIColor?, incomingMessageTextColor: UIColor?, outgoingMessageTextColor: UIColor?) {
        self.recipient = nil
        self.incomingMessageBubbleColor = incomingMessageBubbleColor
        self.outgoingMessageBubbleColor = outgoingMessageBubbleColor
        self.incomingMessageTextColor = incomingMessageTextColor
        self.outgoingMessageTextColor = outgoingMessageTextColor
        super.init(nibName: nil, bundle: nil)
        self.personFromEmailAddress(emailAddress: recipient)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        WXTManager.activeUser { (person) in
            self.senderId = person.id!
            self.senderDisplayName = person.displayName!
            self.registerForIncomingMessages()
            if self.preChatMessages.count > 0 {
                self.scrollToBottom(animated: true)
                self.showTypingIndicator = true
                    for message in self.preChatMessages {
                        print("Adding Pre-Chat Message to View")
                        self.addMessage(withId: "Agent", name: "System", text: message)
                }
                self.showTypingIndicator = false
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = self.senderDisplayName
    }
    
    override func viewWillLayoutSubviews() {
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //WXTManager.shared.deinitSpark()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func registerForIncomingMessages() {
        print("Registering for Inbound Messages")
        WXTManager.shared.spark?.messages.onEvent = { messageEvent in
            switch messageEvent{
            case .messageReceived(let message):
                print("------ PERSON-ID: \(message.personId!) \n\n RECIPIENT-ID \(self.recipient!.id!)")
                if message.personId! == self.recipient!.id! {
                    
                    if message.files == nil {
                        self.updateMessageActivity(message)
                    }
                    else {
                        for file in message.files! {
                            
                            WXTManager.shared.spark?.messages.downloadFile(file, completionHandler: { (result) in
                                
                                let fileExtension = NSURL(fileURLWithPath: (result.data?.absoluteString)!).pathExtension
                                print("Extension is \(fileExtension)!")
                                
                                if (fileExtension == "mp4") {
                                    let video = JSQVideoMediaItem(fileURL: result.data?.absoluteURL, isReadyToPlay: true)
                                    self.addVideoMessage(withId: message.personEmail!, name: "Agent", key: file.displayName!, mediaItem: video!)
                                }
                                else if (fileExtension == "pdf" || fileExtension == "docx" || fileExtension == "doc" || fileExtension == "ppt" || fileExtension == "pptx" || fileExtension == "xls" || fileExtension == "xlsx") {
                                }
                                else {
                                    let image = UIImage(data: NSData(contentsOf: (result.data?.absoluteURL)!)! as Data)
                                    self.addPhotoMessage(withId: message.personEmail!, name: "Agent", key: file.displayName!, mediaItem: JSQPhotoMediaItem(image: image))
                                }
                                self.finishReceivingMessage(animated: true)
                            })
                        }
                    }
                }
                break
            case .messageDeleted(let messageId):
                // ...
                break
            }
        }
    }
    
    fileprivate func updateMessageActivity(_ message: Message) {
        print("MESSAGE RECIEVED - \(message.text!)")
        self.addMessage(withId: message.personId!, name: message.personEmail!, text: self.removeHTMLTag(htmlString: message.text!))
    }
    
    private func addMessage(withId id: String, name: String, text: String) {
        print("ADDING MESSAGE TO VIEW - \(id) \(name) \(text)")
        if let message = JSQMessage(senderId: id, displayName: name, text: text) {
            messages.append(message)
            finishSendingMessage(animated: true)
        }
    }
    
    private func addPhotoMessage(withId id: String, name: String, key: String, mediaItem: JSQPhotoMediaItem) {
        if let message = JSQMessage(senderId: id, displayName: name, media: mediaItem) {
            messages.append(message)
            collectionView.reloadData()
        }
        self.finishReceivingMessage(animated: true)
    }
    
    private func addVideoMessage(withId id: String, name: String, key: String, mediaItem: JSQVideoMediaItem) {
        
        if let message = JSQMessage(senderId: id, displayName: name, media: mediaItem) {
            messages.append(message)
            collectionView.reloadData()
        }
        self.finishReceivingMessage(animated: true)
    }
    
    func removeHTMLTag(htmlString: String) -> String {
        return htmlString.replacingOccurrences(of: "<[^>]+>", with: "", options: String.CompareOptions.regularExpression, range: nil)
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        DispatchQueue.main.async{
            self.addMessage(withId: self.senderId, name: self.senderDisplayName, text: text)
        }
        DispatchQueue.global(qos: .background).async {
            
            WXTManager.shared.spark?.messages.post(personEmail: EmailAddress.fromString((self.recipient?.emails![0].toString())!)!, text: text!, files: [], queue: nil, completionHandler: { (response) in
                DispatchQueue.main.async {
                    self.finishSendingMessage()
                    JSQSystemSoundPlayer.jsq_playMessageSentSound()
                }
            })
        }
    }
    
    // MARK: - CollectionView Configuration
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    private func setupOutgoingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor(red: 25.0/255.0, green: 62.0/255.0, blue: 122.0/255.0, alpha: 1.0))
    }
    
    private func setupIncomingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.incomingMessagesBubbleImage(with: self.incomingMessageBubbleColor != nil ? self.incomingMessageBubbleColor : UIColor.jsq_messageBubbleLightGray())
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item] // 1
        if message.senderId == senderId { // 2
            return outgoingBubbleImageView
        } else { // 3
            return incomingBubbleImageView
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let message = messages[indexPath.item]
        
        if message.senderId == senderId {
            // Outgoing Message Text Color, defaults to White if not specified
            cell.textView?.textColor = self.outgoingMessageTextColor != nil ? self.outgoingMessageTextColor : UIColor.white
        } else {
            // Incoming Message Text Color, defaults to Black if not specified
            cell.textView?.textColor = self.incomingMessageTextColor != nil ? self.incomingMessageTextColor : UIColor.black
        }
        return cell
    }
    
    func personFromEmailAddress(emailAddress: String) {
        WXTManager.shared.spark?.people.list(email: EmailAddress.fromString(emailAddress), displayName: nil, id: nil, orgId: nil, max: nil, queue: nil, completionHandler: { (response) in
            print("PERSON IS-> \(response.result)")
            let retrievedPerson: Person = response.result.data![0]
            self.recipient = retrievedPerson
            self.navigationItem.title = self.recipient?.displayName
        })
    }
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        self.showFilePicker()
//        let actionView = UIAlertController.init(title: "N/A", message: "Not Implemented in Default Implementation", preferredStyle: .alert)
//        let action1 = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
//        actionView.addAction(action1)
//        present(actionView, animated: true, completion: nil)
    }
    
    func getURL(asset: PHAsset, completionHandler : @escaping ((_ responseURL : URL?) -> Void)){
        if asset.mediaType == .image {
            let options: PHContentEditingInputRequestOptions = PHContentEditingInputRequestOptions()
            options.canHandleAdjustmentData = {(adjustmeta: PHAdjustmentData) -> Bool in
                return true
            }
            asset.requestContentEditingInput(with: options, completionHandler: {(contentEditingInput: PHContentEditingInput?, info: [AnyHashable : Any]) -> Void in
                completionHandler(contentEditingInput!.fullSizeImageURL as URL?)
            })
        } else if asset.mediaType == .video {
            let options: PHVideoRequestOptions = PHVideoRequestOptions()
            options.version = .original
            PHImageManager.default().requestAVAsset(forVideo: asset, options: options, resultHandler: {(asset: AVAsset?, audioMix: AVAudioMix?, info: [AnyHashable : Any]?) -> Void in
                if let urlAsset = asset as? AVURLAsset {
                    let localVideoUrl: URL = urlAsset.url as URL
                    completionHandler(localVideoUrl)
                } else {
                    completionHandler(nil)
                }
            })
        }
    }
    
    func done() {
        WXTManager.shared.deinitSpark()
        self.dismiss(animated: true, completion: nil)
    }
    
    func showFilePicker() {
        let documentViewController = UIDocumentPickerViewController(documentTypes: ["public.item"], in: .import)
        documentViewController.delegate = self
        self.present(documentViewController, animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        for documentUrl in urls {
            
            let sandboxFileUrl: URL = dir.first!.appendingPathComponent(documentUrl.lastPathComponent)
            
            if FileManager.default.fileExists(atPath: sandboxFileUrl.path) {
                print("File Exists")
                print(documentUrl.absoluteString)
                self.sendMediaMessage(emailAddress: EmailAddress.fromString((self.recipient?.emails![0].toString())!)!, assetUrl: sandboxFileUrl.absoluteString, fileName: sandboxFileUrl.lastPathComponent)
            }
            else {
                do {
                    try FileManager.default.copyItem(at: documentUrl, to: sandboxFileUrl)
                    print("Copied File")
                    self.sendMediaMessage(emailAddress: EmailAddress.fromString((self.recipient?.emails![0].toString())!)!, assetUrl: sandboxFileUrl.absoluteString, fileName: sandboxFileUrl.lastPathComponent)
                }
                catch {
                    print("Error: \(error)")
                }
            }
        }
    }
    
    func sendMediaMessage(emailAddress: EmailAddress, assetUrl: String, fileName: String) {
        
        let image = UIImage(named: "healthCareDoctor")
        let imageData = UIImagePNGRepresentation(image!)!
        let options = [
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceThumbnailMaxPixelSize: 300] as CFDictionary
        let source = CGImageSourceCreateWithData(imageData as CFData, nil)!
        let imageReference = CGImageSourceCreateThumbnailAtIndex(source, 0, options)!
        let thumbnail = UIImage(cgImage: imageReference)
        
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        let localPath = documentDirectory?.appending("ffff")
        let data = UIImagePNGRepresentation(thumbnail)! as NSData
        data.write(toFile: localPath!, atomically: true)
        
    
        var files: [LocalFile]?
        let mimeType: String = mimeTypeForPath(path: assetUrl)
        print("MIME TYPE IS: \(mimeType)")
        let thumbNail = LocalFile.Thumbnail.init(path: assetUrl, mime: mimeType, width: 200, height: 180)
        let tn = LocalFile.Thumbnail(path: URL.init(fileURLWithPath: localPath!).absoluteString, width: 200, height: 180)
        let fileModel = LocalFile.init(path: assetUrl, name: fileName, mime: mimeType, thumbnail: tn) { (progress) in
            print("Progress!!!!!!!!!!")
            print(progress)
        }
        files?.insert(fileModel!, at: 0)
        print("File Count is \(files?.count)")
        for tempFile in files! {
            print("GOING TO SEND \(tempFile.name)")
        }
        
        WXTManager.shared.spark?.messages.post(personEmail: emailAddress, text: fileName, files: files, queue: nil, completionHandler: { (response) in
            switch response.result {
                case .success(let message):
                    print("Success")
                    print(message)
                    self.addPhotoMessage(withId: self.senderId, name: fileName, key: fileName, mediaItem: JSQPhotoMediaItem(image: UIImage(contentsOfFile: assetUrl)))
                    break
                case .failure(let error):
                    print(error)
                    print("Failed!!!!!!!!!")
                    break
            }
            
        })
        
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAt indexPath: IndexPath!) {
        print("tapped at \(indexPath)")
        let message =  self.messages[indexPath.row]
        if message.isMediaMessage == true{
            let mediaItem =  message.media
            if mediaItem is JSQPhotoMediaItem {
                let photoItem = mediaItem as! JSQPhotoMediaItem
                let imageViewVC = WXTeamsImageViewController()
                let navController = UINavigationController(rootViewController: imageViewVC)
                imageViewVC.fileName = "Attachment"
                imageViewVC.attachmentImage = photoItem.image!
                self.present(navController, animated: true, completion: nil)
            }
            else if mediaItem is JSQVideoMediaItem {
                let video = message.media as! JSQVideoMediaItem
                let videoURL = video.fileURL
                self.playVideo(fileUrl: videoURL!)
            }
        }
//        else if message.text.contains("Attachment:") {
//            print(message.text!)
//            let fileUrl = self.attachments[message.text] as! URL
//            print(fileUrl)
//            let attachmentViewVC = WXTeamsDocumentViewController()
//            let navController = UINavigationController(rootViewController: attachmentViewVC)
//            attachmentViewVC.attachmentURI = fileUrl
//            self.present(navController, animated: true, completion: nil)
//        }
    }
    
    func playVideo(fileUrl: URL)
    {
        let player = AVPlayer(url: fileUrl)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true)
        {
            player.play()
        }
    }
    
    func mimeTypeForPath(path: String) -> String {
        let url = NSURL(fileURLWithPath: path)
        let pathExtension = url.pathExtension
        
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension! as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as String
            }
        }
        return "application/octet-stream"
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
