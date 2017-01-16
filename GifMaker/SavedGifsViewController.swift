//
//  SavedGifsViewController.swift
//  GifMaker
//
//  Created by Alejandrina Patron on 1/13/17.
//  Copyright © 2017 Alejandrina Patron. All rights reserved.
//

import UIKit

class SavedGifsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, PreviewViewControllerDelegate {
    
    var gifsFilePath: String {
        let directories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsPath = directories[0]
        let gifsPath = documentsPath.appending("/savedGifs")
        return gifsPath
    }
    var savedGifs = [Gif]()
    let cellMargin: CGFloat = 12.0
    @IBOutlet weak var emptyView: UIStackView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showWelcome()
        let bottomBlur = CAGradientLayer()
        bottomBlur.frame = CGRect(x: 0.0, y: self.view.frame.size.height - 100.0, width: self.view.frame.size.width, height: 100.0)
        bottomBlur.colors = [UIColor(white: 1.0, alpha: 0.0).cgColor, UIColor.white.cgColor]
        self.view.layer.insertSublayer(bottomBlur, above: self.collectionView.layer)
        if FileManager.default.fileExists(atPath: gifsFilePath) {
            savedGifs = NSKeyedUnarchiver.unarchiveObject(withFile: gifsFilePath) as! [Gif]
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emptyView.isHidden = (savedGifs.count != 0)
        collectionView.reloadData()
        self.title = "My Collection"
        applyTheme(theme: .light)
        self.navigationController?.navigationBar.isHidden = savedGifs.count == 0
    }

    func showWelcome() {
        if !UserDefaults.standard.bool(forKey: "WelcomeViewSeen") {
            let welcomeViewController = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeViewController")
            self.navigationController?.pushViewController(welcomeViewController!, animated: true)
        }
    }
    
    // MARK: CollectionView Delegate and Datasource Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedGifs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GifCell", for: indexPath) as! GifCell
        let gif = savedGifs[indexPath.item]
        cell.configureForGif(gif: gif)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let gif = savedGifs[indexPath.item]
        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailVC.gif = gif
        detailVC.modalPresentationStyle = .overCurrentContext
        self.present(detailVC, animated: true, completion: nil)
    }
    
    // MARK: CollectionViewFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.size.width - (cellMargin * 2.0)) / 2.0
        return CGSize(width: width, height: width)
    }
    
    // MARK: PreviewViewControllerDelegate
    func previewVC(preview: PreviewViewController, didSaveGif gif: Gif) {
        gif.gifData = NSData(contentsOf: gif.url!)
        savedGifs.append(gif)
        NSKeyedArchiver.archiveRootObject(savedGifs, toFile: gifsFilePath)
    }

}
