//
//  PreviewViewController.swift
//  GifMaker
//
//  Created by Alejandrina Patron on 1/2/17.
//  Copyright © 2017 Alejandrina Patron. All rights reserved.
//

import UIKit

protocol PreviewViewControllerDelegate {
    func previewVC(_preview: PreviewViewController, didSaveGif gif: Gif)
}

class PreviewViewController: UIViewController {
    
    var gif: Gif?
    var delegate: PreviewViewControllerDelegate?
    
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
    
    @IBAction func createAndSave(sender: AnyObject) {
        self.gif?.gifData = NSData(contentsOf: (self.gif?.url)!)
        
        // Save Gif
//        let appDelegate = UIApplication.shared.delegate
        
        delegate?.previewVC(_preview: self, didSaveGif: gif!)
        _ = self.navigationController?.popToRootViewController(animated: true)
    }

}
