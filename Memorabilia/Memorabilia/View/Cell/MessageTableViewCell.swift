//
//  MessageTableViewCell.swift
//  Memorabilia
//
//  Created by André Mello Alves on 30/05/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    
    // MARK: Properties
    
    static let identifier = "Message"
    
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
    
    lazy var background: UIVisualEffectView = {
        // Blur
        let blur = UIBlurEffect(style: .regular)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.layer.cornerRadius = 20
        blurView.clipsToBounds = true
        blurView.translatesAutoresizingMaskIntoConstraints = false
        
        // Vibrancy
        let vibrancy = UIVibrancyEffect(blurEffect: blur, style: .label)
        let vibrancyView = UIVisualEffectView(effect: vibrancy)
        vibrancyView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        vibrancyView.contentView.addSubview(messageLabel)
        blurView.contentView.addSubview(vibrancyView)
        return blurView
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
        
        // Background
        addSubview(background)
        
        // Constraints
        setupConstraints()
    }
    
    // MARK: Update
    
    public func update(message: String?, width: CGFloat) {
        messageLabel.text = message
        messageLabel.preferredMaxLayoutWidth = width
    }
    
    // MARK: Constraints
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Self
            
            // Background
            background.topAnchor.constraint(equalTo: topAnchor),
            background.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            background.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            background.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // Input
            messageLabel.topAnchor.constraint(equalTo: background.topAnchor, constant: 16),
            messageLabel.leftAnchor.constraint(equalTo: background.leftAnchor, constant: 16),
            messageLabel.rightAnchor.constraint(equalTo: background.rightAnchor, constant: -16),
            messageLabel.bottomAnchor.constraint(equalTo: background.bottomAnchor, constant: -16),
        ])
    }

}



