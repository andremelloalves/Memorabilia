//
//  CircleButton.swift
//  Memorabilia
//
//  Created by André Mello Alves on 01/12/19.
//  Copyright © 2019 André Mello Alves. All rights reserved.
//

import UIKit

class CircleButton: UIButton {
    
    // MARK: Properties
    
    let icon: UIImageView = {
        let view = UIImageView()
        view.tintColor = .tertiaryLabel
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
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
        // Self
        backgroundColor = .clear
        layer.cornerRadius = 20
        clipsToBounds = true
        
        // Image
        addSubview(icon)
        
        setupConstraints()
    }
    
    // MARK: Constraints
    
    private func setupConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            // Self
            heightAnchor.constraint(equalToConstant: 40),
            widthAnchor.constraint(equalToConstant: 40),
            
            // Image
            icon.topAnchor.constraint(equalTo: topAnchor),
            icon.leftAnchor.constraint(equalTo: leftAnchor),
            icon.rightAnchor.constraint(equalTo: rightAnchor),
            icon.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
}
