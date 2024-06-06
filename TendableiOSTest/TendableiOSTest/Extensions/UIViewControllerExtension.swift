//
//  UIViewControllerExtension.swift
//  TendableiOSTest
//
//  Created by Shravan Gundawar on 06/06/24.
//

import Foundation
import UIKit

extension UIViewController {
    private static let loaderViewTag = 999999
    
    func showLoader() {
        DispatchQueue.main.async {
            if let _ = self.view.viewWithTag(UIViewController.loaderViewTag) {
                return
            }
            
            let loader = AppActivityLoader(frame: self.view.bounds)
            loader.tag = UIViewController.loaderViewTag
            loader.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(loader)
            
            NSLayoutConstraint.activate([
                loader.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                loader.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                loader.topAnchor.constraint(equalTo: self.view.topAnchor),
                loader.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            ])
            
            loader.show()
        }
    }
    
    func hideLoader() {
        DispatchQueue.main.async {
            if let loader = self.view.viewWithTag(UIViewController.loaderViewTag) as? AppActivityLoader {
                loader.hide()
                loader.removeFromSuperview()
            }
        }
    }
}
