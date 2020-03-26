//
//  ActionBarView.swift
//  Relista
//
//  Created by André Mello Alves on 11/10/19.
//  Copyright © 2019 André Mello Alves. All rights reserved.
//

import UIKit

class ActionBarView: UIView {
    
    // MARK: Properties
    
    let button: ActionBarButton = {
        let button = ActionBarButton()
        return button
    }()
    
    let background: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .systemChromeMaterial)
        let view = UIVisualEffectView(effect: blur)
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return view
    }()
    
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
        //addSubview(background)
        
        // Button
        addSubview(button)
        
        setupConstraints()
    }
    
    // MARK: Constraints
    
    private func setupConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            // Button
            button.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            button.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            button.rightAnchor.constraint(equalTo: rightAnchor, constant: -16)
        ])
    }

}
