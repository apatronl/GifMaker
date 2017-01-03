//
//  GifEditorViewController.swift
//  GifMaker
//
//  Created by Alejandrina Patron on 1/2/17.
//  Copyright © 2017 Alejandrina Patron. All rights reserved.
//

import UIKit

class GifEditorViewController: UIViewController {
    
    @IBOutlet weak var gifImageView: UIImageView!
    var gifURL: URL? = nil
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let gifURL = gifURL {
            let gifFromRecording = UIImage.gif(url: gifURL.absoluteString)
            gifImageView.image = gifFromRecording
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
