//
//  Gif.swift
//  GifMaker
//
//  Created by Alejandrina Patron on 1/3/17.
//  Copyright © 2017 Alejandrina Patron. All rights reserved.
//

import UIKit

class Gif: NSCoder {
    
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
}
