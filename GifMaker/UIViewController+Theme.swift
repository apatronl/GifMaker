//
//  UIViewController+Theme.swift
//  GifMaker
//
//  Created by Alejandrina Patron on 1/16/17.
//  Copyright © 2017 Alejandrina Patron. All rights reserved.
//

import UIKit

enum Theme {
    case light
    case dark
    case darkTranslucent
}

extension UIViewController {
    func applyTheme(theme: Theme) {

        switch theme {
        case .light:
            self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
            self.navigationController?.navigationBar.barTintColor = UIColor.white
            self.navigationController?.navigationBar.tintColor = UIColor(red: 255.0/255.0, green: 51.0/255.0, blue: 102.0/255.0, alpha: 1.0)
            self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red:46.0/255.0, green:61.0/255.0, blue:73.0/255.0, alpha:1.0)]
            self.view.backgroundColor = UIColor.white
            
        case .dark:
            self.view.backgroundColor = UIColor(red: 46.0/255.0, green: 61.0/255.0, blue: 73.0/255.0, alpha: 1.0)
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.isTranslucent = true
            self.navigationController?.view.backgroundColor = UIColor(red: 46.0/255.0, green: 61.0/255.0, blue: 73.0/255.0, alpha: 1.0)
            self.navigationController?.navigationBar.backgroundColor = UIColor(red: 46.0/255.0, green: 61.0/255.0, blue: 73.0/255.0, alpha: 1.0)
            self.edgesForExtendedLayout = []
            self.navigationController?.navigationBar.tintColor = UIColor.white
            self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
            
        case .darkTranslucent:
            self.view.backgroundColor = UIColor(red: 46.0/255.0, green: 61.0/255.0, blue: 73.0/255.0, alpha: 1.0)
        }
    }
}
