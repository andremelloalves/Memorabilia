//
//  ColorTableViewCell.swift
//  Memorabilia
//
//  Created by André Mello Alves on 06/06/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import UIKit

class ColorTableViewCell: UITableViewCell {
    
    // MARK: Properties
    
    static let identifier = "Color"
    
    let colorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
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
    
    let selectionView: UIImageView = {
        let view = UIImageView()
        view.tintColor = .white
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var background: UIVisualEffectView = {
        // Blur
        let blur = UIBlurEffect(style: .regular)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.layer.cornerRadius = 20
        blurView.clipsToBounds = true
        blurView.layer.maskedCorners = []
        blurView.translatesAutoresizingMaskIntoConstraints = false
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
        selectionStyle = .none
        
        // Background
        addSubview(background)
        
        // Color
        addSubview(colorView)
        
        // Name
        addSubview(nameLabel)
        
        // Selection
        addSubview(selectionView)
        
        // Constraints
        setupConstraints()
    }
    
    // MARK: Update
    
    public func update(color: Color?, selected: Bool, isFirst: Bool, isLast: Bool) {
        colorView.backgroundColor = color?.uiColor
        nameLabel.text = color?.name
        
        if selected {
            selectionView.image = UIImage(systemName: "checkmark")
        } else {
            selectionView.image = nil
        }
        
        background.layer.maskedCorners = []
        if isFirst {
            background.layer.maskedCorners.insert(.layerMinXMinYCorner)
            background.layer.maskedCorners.insert(.layerMaxXMinYCorner)
        }
        if isLast {
            background.layer.maskedCorners.insert(.layerMinXMaxYCorner)
            background.layer.maskedCorners.insert(.layerMaxXMaxYCorner)
        }
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
            
            // Color
            colorView.widthAnchor.constraint(equalToConstant: 20),
            colorView.heightAnchor.constraint(equalToConstant: 20),
            colorView.leftAnchor.constraint(equalTo: background.leftAnchor, constant: 16),
            colorView.centerYAnchor.constraint(equalTo: background.centerYAnchor),
            
            // Name
            nameLabel.heightAnchor.constraint(equalToConstant: 22),
            nameLabel.topAnchor.constraint(equalTo: background.topAnchor, constant: 16),
            nameLabel.leftAnchor.constraint(equalTo: colorView.rightAnchor, constant: 16),
            nameLabel.rightAnchor.constraint(equalTo: selectionView.leftAnchor, constant: -16),
            nameLabel.bottomAnchor.constraint(equalTo: background.bottomAnchor, constant: -16),
            
            // Selection
            selectionView.widthAnchor.constraint(equalToConstant: 20),
            selectionView.heightAnchor.constraint(equalToConstant: 20),
            selectionView.rightAnchor.constraint(equalTo: background.rightAnchor, constant: -16),
            selectionView.centerYAnchor.constraint(equalTo: background.centerYAnchor)
        ])
    }

}



