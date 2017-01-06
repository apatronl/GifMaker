//
//  PreviewViewController.swift
//  GifMaker
//
//  Created by Alejandrina Patron on 1/2/17.
//  Copyright © 2017 Alejandrina Patron. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController {
    
    var gif: Gif?
    
    @IBOutlet weak var gifImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        gifImageView.image = gif?.gifImage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func shareGif(sender: AnyObject) {
        let animatedGif = NSData(contentsOf: (self.gif?.url!)!)
        let itemsToShare = [animatedGif]
        
        let shareController = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
        shareController.completionWithItemsHandler = {(activity, completed, items, error) in
            if completed {
                _ = self.navigationController?.popToRootViewController(animated: true)
            }
        }
        self.navigationController?.present(shareController, animated: true, completion: nil)
    }

}
