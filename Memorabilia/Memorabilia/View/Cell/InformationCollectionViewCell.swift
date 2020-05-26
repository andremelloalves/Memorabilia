//
//  InformationCollectionViewCell.swift
//  Memorabilia
//
//  Created by André Mello Alves on 24/05/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import UIKit

class InformationCollectionViewCell: UICollectionViewCell {
    
    // MARK: Properties
    
    static let identifier = "Information"
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.adjustsFontForContentSizeCategory = true
        label.adjustsFontSizeToFitWidth = false
        label.baselineAdjustment = .alignCenters
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.adjustsFontForContentSizeCategory = true
        label.adjustsFontSizeToFitWidth = false
        label.baselineAdjustment = .alignCenters
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let photo: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 4
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
        backgroundColor = .systemBackground
        layer.cornerRadius = 20
        clipsToBounds = true
        
        // Title
        addSubview(titleLabel)
        
        // Message
        addSubview(messageLabel)
        
        // Image
        addSubview(photo)
        
        // Constraints
        setupConstraints()
    }
    
    // MARK: Update
    
    public func update(information: InformationEntity.Display.Item) {
        titleLabel.text = information.title
        messageLabel.text = information.message
    }
    
    public func updatePhoto(_ data: Data) {
        photo.image = UIImage(data: data)
    }
    
    // MARK: Constraints
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Self
            
            // Title
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            
            // Message
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            messageLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            messageLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            
            // Image
            photo.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 16),
            photo.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            photo.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            photo.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }

}

