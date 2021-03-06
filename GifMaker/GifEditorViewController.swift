//
//  GifEditorViewController.swift
//  GifMaker
//
//  Created by Alejandrina Patron on 1/2/17.
//  Copyright © 2017 Alejandrina Patron. All rights reserved.
//

import UIKit

class GifEditorViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var gifImageView: UIImageView!
    @IBOutlet weak var captionTextField: UITextField!
    
    var gif: Gif?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        gifImageView.image = gif?.gifImage
        subscribeToKeyboardNotifications()
        applyTheme(theme: .dark)
        self.title = "Add a Caption"
        self.navigationController?.navigationBar.backItem?.title = ""
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Attributes for text style
        let defaultAttributes: [String:AnyObject] = [NSStrokeColorAttributeName: UIColor.black,
                                                     NSStrokeWidthAttributeName: -4.0 as NSNumber,
                                                     NSForegroundColorAttributeName: UIColor.white,
                                                     NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!]
        
        captionTextField.defaultTextAttributes = defaultAttributes
        captionTextField.textAlignment = NSTextAlignment.center
        captionTextField.attributedPlaceholder = NSAttributedString(string: "Add Caption", attributes: defaultAttributes)
        
        // Tap Gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
        self.title = ""
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    // MARK: - UITextFieldDelegate

    func textFieldDidBeginEditing(_ textField: UITextField) {
        captionTextField.placeholder = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        captionTextField.resignFirstResponder()
        if let caption = captionTextField.text {
            let trimmed = caption.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimmed.isEmpty {
                captionTextField.text = nil
                captionTextField.placeholder = "Add a caption"
            }
        }
        return true
    }
    
}

// Methods to adjust the keyboard
extension GifEditorViewController {
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(GifEditorViewController.keyboardWillShow),
                                                         name: NSNotification.Name.UIKeyboardWillShow,
                                                         object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(GifEditorViewController.keyboardWillHide),
                                                         name: NSNotification.Name.UIKeyboardWillHide,
                                                         object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if view.frame.origin.y >= 0 {
            view.frame.origin.y -= getKeyboardHeight(notification: notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if (self.view.frame.origin.y < 0) {
            view.frame.origin.y += getKeyboardHeight(notification: notification)
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    @IBAction func presentPreview(sender: AnyObject) {
        let previewVC = self.storyboard?.instantiateViewController(withIdentifier: "PreviewViewController") as! PreviewViewController
        self.gif?.caption = captionTextField.text
        
        let regift = Regift(sourceFileURL: (self.gif?.videoURL)!, frameCount: frameCount, delayTime: delayTime, loopCount: loopCount)
        
        let captionFont = captionTextField.font
        let url = regift.createGif(caption: captionTextField.text, font: captionFont)
        
        let gif = Gif(url: url!, videoURL: (self.gif?.videoURL)!, caption: captionTextField.text)
        previewVC.gif = gif
        previewVC.delegate = navigationController?.viewControllers.first as! SavedGifsViewController
        
        self.navigationController?.pushViewController(previewVC, animated: true)
    }
}

