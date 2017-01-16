//
//  PreviewViewController.swift
//  GifMaker
//
//  Created by Alejandrina Patron on 1/2/17.
//  Copyright © 2017 Alejandrina Patron. All rights reserved.
//

import UIKit

protocol PreviewViewControllerDelegate {
    func previewVC(preview: PreviewViewController, didSaveGif gif: Gif)
}

class PreviewViewController: UIViewController {
    
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    var gif: Gif?
    var delegate: PreviewViewControllerDelegate?
    
    @IBOutlet weak var gifImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        gifImageView.image = gif?.gifImage
        
        // Customize buttons
        self.shareButton.layer.cornerRadius = 4.0
        self.shareButton.layer.borderColor = UIColor(red: 255.0/255.0, green: 65.0/255.0, blue: 112.0/255.0, alpha: 1.0).cgColor
        self.shareButton.layer.borderWidth = 1.0
        
        self.saveButton.layer.cornerRadius = 4.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "Preview"
        applyTheme(theme: .dark)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.title = ""
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
        delegate?.previewVC(preview: self, didSaveGif: gif!)
        _ = self.navigationController?.popToRootViewController(animated: true)
    }

}
