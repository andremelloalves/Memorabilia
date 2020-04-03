//
//  ActionView.swift
//  Memorabilia
//
//  Created by André Mello Alves on 03/04/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import UIKit

class ActionView: UIView {
    
    // MARK: Properties
    
    var symbol: String = "" {
        didSet {
            imageView.image = UIImage(systemName: symbol)
        }
    }
    
    var text: String = ""{
        didSet {
            textLabel.text = text
        }
    }
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.tintColor = .white
        let configuration = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular, scale: .small)
        view.preferredSymbolConfiguration = configuration
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.adjustsFontForContentSizeCategory = true
        label.adjustsFontSizeToFitWidth = false
        label.baselineAdjustment = .alignCenters
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var background: UIVisualEffectView = {
        // Blur
        let blur = UIBlurEffect(style: .regular)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        // Vibrancy
        let vibrancy = UIVibrancyEffect(blurEffect: blur, style: .label)
        let vibrancyView = UIVisualEffectView(effect: vibrancy)
        vibrancyView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        vibrancyView.contentView.addSubview(imageView)
        vibrancyView.contentView.addSubview(textLabel)
        blurView.contentView.addSubview(vibrancyView)
        return blurView
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
        layer.cornerRadius = 20
        clipsToBounds = true
        backgroundColor = .clear
        
        // Background
        addSubview(background)
        
        setupConstraints()
    }
    
    // MARK: Constraints
    
    private func setupConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            // Self
//            heightAnchor.constraint(greaterThanOrEqualToConstant: 40),
            
            // Title
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            imageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            imageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            
            // Info
            textLabel.heightAnchor.constraint(equalToConstant: 22),
            textLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            textLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            textLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            textLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
    
}
