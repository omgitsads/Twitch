//
//  StreamViewItem.swift
//  Twitch
//
//  Created by Adam Holt on 04/04/2016.
//  Copyright © 2016 Adam Holt. All rights reserved.
//

import Cocoa
import Alamofire
import ObjectMapper

class StreamViewItem: NSCollectionViewItem {
    @IBOutlet weak var streamNameLabel: NSTextField!
    @IBOutlet weak var viewersLabel: NSTextField!
    @IBOutlet weak var followersLabel: NSTextField!
    
    var imageRequest: Request?
    var record: protocol<Mappable>!
    
    var stream: Stream! {
        get {
            return self.record as! Stream
        }
    }
    
    override func viewDidDisappear() {
        self.imageRequest?.cancel()
    }
    
    func setup() {
        self.streamNameLabel.stringValue = ""
        self.imageView?.image = NSImage(named: "video-default")
        self.streamNameLabel.stringValue = self.stream.status!
        self.viewersLabel?.attributedStringValue = self.attributedViewersLabel()
        
        if let previewImage = self.stream.previewImage {
            self.imageView?.image = previewImage
        } else {
            // Cancel the existing request if it's running
            self.imageRequest?.cancel()
            
            // Start a new request to fetch the box artwork
            self.imageRequest = Alamofire.request(.GET, self.stream.preview!.absoluteString)
            
            // Assign the box artwork if the request was successful.
            self.imageRequest!.responseData { response in
                if response.result.isSuccess {
                    // If the image was 404, we don't need to create a new one.
                    if (response.response?.URL?.path != "/ttv-static/404_preview-320x180.jpg") {
                        self.stream.previewImage = NSImage(data:  response.result.value!)
                        self.imageView?.image = self.stream.previewImage
                    }
                }
            }
        }
    }
    
    func attributedViewersLabel() -> NSAttributedString {
        let boldfont = NSFont(name: "SFUIText-Bold", size: 9)!
        
        let string = "\(self.stream.viewers!) viewers on \(self.stream.name!)"
        let nsString = string as NSString
        let attributedString = NSMutableAttributedString(string: string)
        
        let userRange = nsString.rangeOfString(self.stream.name!)
        attributedString.addAttribute(NSFontAttributeName, value: boldfont, range: userRange)
        
        return attributedString
    }
}
