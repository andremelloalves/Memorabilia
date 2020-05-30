//
//  CollectionViewHeaderView.swift
//  Memorabilia
//
//  Created by André Mello Alves on 29/05/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import UIKit

class CollectionViewHeaderView: UICollectionReusableView {
    
    // MARK: Properties
    
    static let identifier = "CollectionHeader"
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.backgroundColor = .clear
        label.font = UIFont.systemFont(ofSize: 23, weight: .semibold)
        label.adjustsFontForContentSizeCategory = true
        label.adjustsFontSizeToFitWidth = false
        label.baselineAdjustment = .alignCenters
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        
        // Title
        addSubview(titleLabel)
        
        // Constraints
        setupConstraints()
    }
    
    // MARK: Update
    
    public func updateTitle(title: String) {
        titleLabel.text = title
    }
    
    // MARK: Constraints
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Self
            
            // Title
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
        ])
    }
    
    // MARK: View life cycle
    
    // MARK: Action
    
    // MARK: Animation
    
    // MARK: Touch
    
    // MARK: Delegate
    
}
