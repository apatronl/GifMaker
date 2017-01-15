//
//  GifCell.swift
//  GifMaker
//
//  Created by Alejandrina Patron on 1/13/17.
//  Copyright © 2017 Alejandrina Patron. All rights reserved.
//

import UIKit

class GifCell: UICollectionViewCell {
    
    @IBOutlet weak var gifImageView: UIImageView!
    
    func configureForGif(gif: Gif) {
        gifImageView.image = gif.gifImage
    }

}
