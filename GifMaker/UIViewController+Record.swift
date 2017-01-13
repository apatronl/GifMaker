//
//  UIViewController+Record.swift
//  GifMaker
//
//  Created by Alejandrina Patron on 1/2/17.
//  Copyright © 2017 Alejandrina Patron. All rights reserved.
//

import MobileCoreServices
import UIKit
import AVFoundation

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
        recordVideoController.delegate = self
        recordVideoController.allowsEditing = true
        recordVideoController.videoQuality = .typeHigh
        self.present(recordVideoController, animated: true, completion: nil)
    }
    
    public func launchPhotoLibrary() {
        let videoPicker = UIImagePickerController()
        videoPicker.sourceType = .photoLibrary
        videoPicker.mediaTypes = [kUTTypeMovie as String]
        videoPicker.delegate = self
        videoPicker.allowsEditing = true
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
            let videoURL = info[UIImagePickerControllerMediaURL] as! URL
            let start: NSNumber? = info["_UIImagePickerControllerVideoEditingStart"] as? NSNumber
            let end: NSNumber? = info["_UIImagePickerControllerVideoEditingEnd"] as? NSNumber
            var duration: NSNumber?
            if let start = start, let end = end {
                duration = NSNumber(value: (end.floatValue) - (start.floatValue))
            } else {
                duration = nil
            }
            dismiss(animated: true, completion: nil)
            cropVideoToSquare(rawVideoURL: videoURL, start: start, duration: duration)
        }
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func convertVideoToGIF(videoURL: URL, start: NSNumber?, duration: NSNumber?) {
        DispatchQueue.main.async( execute: {
            self.dismiss(animated: true, completion: nil)
        })
        var regift: Regift!
        if let _ = start {
            // trimmed gif
            regift = Regift(sourceFileURL: videoURL, destinationFileURL: nil, startTime: start as! Float, duration: duration as! Float, frameRate: frameCount, loopCount: loopCount)
        } else {
            // untrimmed gif
            regift = Regift(sourceFileURL: videoURL, frameCount: frameCount, delayTime: delayTime, loopCount: loopCount)
        }
        let gifURL = regift.createGif()
        let gif = Gif(url: gifURL!, videoURL: videoURL, caption: nil)
        displayGIF(gif: gif)
    }
    
    func displayGIF(gif: Gif) {
        let gifEditorVC = storyboard?.instantiateViewController(withIdentifier: "GifEditorViewController") as! GifEditorViewController
        gifEditorVC.gif = gif
        navigationController?.pushViewController(gifEditorVC, animated: true)
    }

    func cropVideoToSquare(rawVideoURL: URL, start: NSNumber?, duration: NSNumber?) {
        //Create the AVAsset and AVAssetTrack
        let videoAsset = AVAsset(url: rawVideoURL)
        let videoTrack = videoAsset.tracks(withMediaType: AVMediaTypeVideo).first! as AVAssetTrack
        
        // Crop to square
        let videoComposition = AVMutableVideoComposition()
        videoComposition.renderSize = CGSize(width: videoTrack.naturalSize.height, height: videoTrack.naturalSize.height)
        videoComposition.frameDuration = CMTime(value: 1, timescale: 30)
        
        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRange(start: kCMTimeZero, duration: CMTimeMakeWithSeconds(60, 30))
        
        // Rotate to portrait
        let transformer = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrack)
        let t1 = CGAffineTransform(translationX: videoTrack.naturalSize.height, y: -(videoTrack.naturalSize.width - videoTrack.naturalSize.height) / 2.0)
        let t2 = t1.rotated(by: CGFloat.pi / 2.0)
        let finalTransform: CGAffineTransform = t2
        transformer.setTransform(finalTransform, at: kCMTimeZero)
        instruction.layerInstructions = [transformer]
        videoComposition.instructions = [instruction]
        
        // Export
        let exporter = AVAssetExportSession(asset: videoAsset, presetName: AVAssetExportPresetHighestQuality)
        exporter?.videoComposition = videoComposition
        let path = self.createPath()
        exporter?.outputURL = URL(fileURLWithPath: path)
        exporter?.outputFileType = AVFileTypeQuickTimeMovie
        
        
        exporter?.exportAsynchronously(completionHandler: { () -> Void in
            DispatchQueue.main.async() {
                self.convertVideoToGIF(videoURL: (exporter?.outputURL)!, start: start, duration: duration)
            }
        })
    }
    
    func createPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths.first
        let manager = FileManager.default
        var outputURL = documentsDirectory!.appending("/output")
        do {
            try manager.createDirectory(atPath: outputURL, withIntermediateDirectories: true, attributes: nil)
        } catch let error {
            print(error.localizedDescription);
        }
        
        outputURL = (outputURL as NSString).appendingPathComponent("output.mov")
        // Remove Existing File
        do {
            try manager.removeItem(atPath: outputURL)
        } catch let error {
            print(error.localizedDescription)
        }
        return outputURL
    }
    
}
