//
//  EmptyMemoryCollectionViewCell.swift
//  Memorabilia
//
//  Created by André Mello Alves on 05/04/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import UIKit

class EmptyMemoryCollectionViewCell: UICollectionViewCell {
    
    // MARK: Properties
    
    static let identifier = "EmptyMemory"
    
    lazy var button: PillButton = {
        let button = PillButton()
        let configuration = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular, scale: .large)
        button.setPreferredSymbolConfiguration(configuration, forImageIn: .normal)
        return button
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
        
        // Button
        addSubview(button)
        
        // Constraints
        setupConstraints()
    }
    
    // MARK: Constraints
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Self
            
            // Input
            button.topAnchor.constraint(equalTo: topAnchor),
            button.leftAnchor.constraint(equalTo: leftAnchor),
            button.rightAnchor.constraint(equalTo: rightAnchor),
            button.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

}
