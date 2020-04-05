//
//  NavigationBarView.swift
//  Memorabilia
//
//  Created by André Mello Alves on 11/10/19.
//  Copyright © 2019 André Mello Alves. All rights reserved.
//

import UIKit

class NavigationBarView: UIView {
    
    // MARK: Properties
    
    let leftButton: CircleButton = {
        let button = CircleButton()
        return button
    }()
    
    let titleButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.baselineAdjustment = .alignCenters
        button.contentHorizontalAlignment = .left
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let rightButton: CircleButton = {
        let button = CircleButton()
        return button
    }()
    
//    let background: UIVisualEffectView = {
//        let blur = UIBlurEffect(style: .systemChromeMaterial)
//        let view = UIVisualEffectView(effect: blur)
//        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
//        return view
//    }()
    
    // MARK: Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        if UIAccessibility.isReduceTransparencyEnabled {
            backgroundColor = .secondarySystemBackground
        } else {
            backgroundColor = .clear
        }
        
        // Background
//        addSubview(background)
        
        // Left button
        addSubview(leftButton)
        
        // Title button
        addSubview(titleButton)
        
        // Right button
        addSubview(rightButton)
        
        setupConstraints()
    }
    
    // MARK: Constraints
    
    private func setupConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            // Left button
            leftButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            leftButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            
            // Title button
            titleButton.heightAnchor.constraint(equalTo: leftButton.heightAnchor),
            titleButton.leftAnchor.constraint(equalTo: leftButton.rightAnchor, constant: 16),
            titleButton.centerYAnchor.constraint(equalTo: leftButton.centerYAnchor),
            titleButton.rightAnchor.constraint(equalTo: rightButton.leftAnchor, constant: -16),
            
            // Right button
            rightButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            rightButton.bottomAnchor.constraint(equalTo: leftButton.bottomAnchor)
        ])
    }

}
