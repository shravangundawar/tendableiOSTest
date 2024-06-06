//
//  AppActivityLoader.swift
//  TendableiOSTest
//
//  Created by Shravan Gundawar on 06/06/24.
//

import Foundation
import UIKit

class AppActivityLoader: UIView {

    private var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        self.backgroundColor = UIColor.black.withAlphaComponent(1)
        self.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    func show() {
        activityIndicator.startAnimating()
        self.isHidden = false
    }
    
    func hide() {
        activityIndicator.stopAnimating()
        self.isHidden = true
    }
}
