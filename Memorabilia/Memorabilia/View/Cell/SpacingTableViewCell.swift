//
//  SpacingTableViewCell.swift
//  Memorabilia
//
//  Created by André Mello Alves on 28/05/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import UIKit

class SpacingTableViewCell: UITableViewCell {
    
    // MARK: Properties
    
    static let identifier = "Spacing"
    
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
        
        // Constraints
        setupConstraints()
    }
    
    // MARK: Update
    
    public func updateHeight(height: CGFloat) {
        heightConstraint.constant = height
    }
    
    // MARK: Constraints
    
    var heightConstraint: NSLayoutConstraint = NSLayoutConstraint()
    
    private func setupConstraints() {
        heightConstraint = heightAnchor.constraint(equalToConstant: 16)
        
        NSLayoutConstraint.activate([
            // Self
            heightConstraint
        ])
    }

}


