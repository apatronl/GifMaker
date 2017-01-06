//
//  UIViewController+Record.swift
//  GifMaker
//
//  Created by Alejandrina Patron on 1/2/17.
//  Copyright © 2017 Alejandrina Patron. All rights reserved.
//

import MobileCoreServices
import UIKit

// MARK: - Constants

let frameCount = 16
let delayTime: Float = 0.2
let loopCount = 0 // 0 = loop forever

// MARK: - UIViewController (Record)

extension UIViewController {
    
    @IBAction func presentVideoOptions(sender: AnyObject) {
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            self.launchPhotoLibrary()
        } else {
            let newGifActionSheet = UIAlertController(title: "Create a new GIF", message: nil, preferredStyle: .actionSheet)
            let recordVideo = UIAlertAction(title: "Record a Video", style: .default, handler: { UIAlertAction in
                self.launchVideoCamera()
            })
            let chooseFromExisting = UIAlertAction(title: "Choose from Existing", style: .default, handler: { UIAlertAction in
                self.launchPhotoLibrary()
            })
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            newGifActionSheet.addAction(recordVideo)
            newGifActionSheet.addAction(chooseFromExisting)
            newGifActionSheet.addAction(cancel)
            
            present(newGifActionSheet, animated: true, completion: nil)
            let pinkColor = UIColor(red: 255.0/255.0, green: 65.0/255.0, blue: 112.0/255.0, alpha: 1.0)
            newGifActionSheet.view.tintColor = pinkColor
        }
        
    }
    
    public func launchVideoCamera() {
        let recordVideoController = UIImagePickerController()
        recordVideoController.sourceType = .camera
        recordVideoController.mediaTypes = [kUTTypeMovie as String]
        recordVideoController.allowsEditing = false
        recordVideoController.delegate = self
        recordVideoController.videoQuality = .typeHigh
        self.present(recordVideoController, animated: true, completion: nil)
    }
    
    public func launchPhotoLibrary() {
        let videoPicker = UIImagePickerController()
        videoPicker.sourceType = .photoLibrary
        videoPicker.mediaTypes = [kUTTypeMovie as String]
        videoPicker.allowsEditing = false
        videoPicker.delegate = self
        videoPicker.videoQuality = .typeHigh
        self.present(videoPicker, animated: true, completion: nil)
    }
    
}

// MARK: - UIViewController: UINavigationControllerDelegate

extension UIViewController: UINavigationControllerDelegate {
    
}

// MARK: - UIViewController: UIImagePickerControllerDelegate

extension UIViewController: UIImagePickerControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        if mediaType == kUTTypeMovie as String {
            let videoURL = info[UIImagePickerControllerMediaURL] as! NSURL
            dismiss(animated: true, completion: nil)
            convertVideoToGIF(videoURL: videoURL)
        }
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func convertVideoToGIF(videoURL: NSURL) {
        let regift = Regift(sourceFileURL: videoURL as URL, frameCount: frameCount, delayTime: delayTime, loopCount: loopCount)
        let gifURL = regift.createGif()
        let gif = Gif(url: gifURL!, videoURL: videoURL as URL, caption: nil)
        displayGIF(gif: gif)
    }
    
    func displayGIF(gif: Gif) {
        let gifEditorVC = storyboard?.instantiateViewController(withIdentifier: "GifEditorViewController") as! GifEditorViewController
        gifEditorVC.gif = gif
        navigationController?.pushViewController(gifEditorVC, animated: true)
    }
    
}
