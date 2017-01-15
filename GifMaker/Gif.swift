//
//  Gif.swift
//  GifMaker
//
//  Created by Alejandrina Patron on 1/3/17.
//  Copyright © 2017 Alejandrina Patron. All rights reserved.
//

import UIKit

class Gif: NSObject, NSCoding {
    
    let url: URL?
    let videoURL: URL?
    var caption: String?
    let gifImage: UIImage?
    var gifData: NSData?
    
    init(url: URL, videoURL: URL, caption: String?) {
        self.url = url
        self.videoURL = videoURL
        self.caption = caption
        self.gifImage = UIImage.gif(url: url.absoluteString)!
        self.gifData = nil
    }
    
    init(name: String) {
        self.url = nil
        self.videoURL = nil
        self.caption = nil
        self.gifData = nil
        self.gifImage = UIImage.gif(name: name)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.url = aDecoder.decodeObject(forKey: "url") as? URL
        self.videoURL = aDecoder.decodeObject(forKey: "videoURL") as? URL
        self.caption = aDecoder.decodeObject(forKey: "caption") as? String
        self.gifImage = aDecoder.decodeObject(forKey: "gifImage") as? UIImage
        self.gifData = aDecoder.decodeObject(forKey: "gifData") as? NSData
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.url, forKey: "url")
        aCoder.encode(self.videoURL, forKey: "videoURL")
        aCoder.encode(self.caption, forKey: "caption")
        aCoder.encode(self.gifImage, forKey: "gifImage")
        aCoder.encode(self.gifData, forKey: "gifData")
    }
}
