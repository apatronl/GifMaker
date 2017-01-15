//
//  DetailViewController.swift
//  GifMaker
//
//  Created by Alejandrina Patron on 1/15/17.
//  Copyright © 2017 Alejandrina Patron. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var gifImageView: UIImageView!
    var gif: Gif?

    override func viewDidLoad() {
        super.viewDidLoad()

        gifImageView.image = gif?.gifImage
    }
    
    @IBAction func shareGif(sender: UIButton) {
        var itemsToShare = [NSData]()
        itemsToShare.append((self.gif?.gifData)!)
        
        let activityVC = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
        activityVC.completionWithItemsHandler = {(activity, completed, items, error) in
            if (completed) {
                self.dismiss(animated: true, completion: nil)
            }
        }
        present(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func closeDetailView(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
