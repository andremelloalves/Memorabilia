//
//  ImageInputTableViewCell.swift
//  Memorabilia
//
//  Created by André Mello Alves on 28/05/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import UIKit

class ImageInputTableViewCell: UITableViewCell {
    
    // MARK: Properties
    
    static let identifier = "ImageInput"
    
    lazy var input: PillButton = {
        let button = PillButton()
        return button
    }()
    
    // MARK: Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
        
        // Input
        addSubview(input)
        
        // Constraints
        setupConstraints()
    }
    
    // MARK: Constraints
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Self
            
            // Input
            input.heightAnchor.constraint(equalTo: input.widthAnchor),
            input.topAnchor.constraint(equalTo: topAnchor),
            input.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            input.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            input.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

}


