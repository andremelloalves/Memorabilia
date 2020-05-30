//
//  PillButton.swift
//  Memorabilia
//
//  Created by André Mello Alves on 03/04/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import UIKit

class PillButton: UIButton {

    // MARK: Properties
    
    let background: UIVisualEffectView = {
        // Blur
        let blur = UIBlurEffect(style: .regular)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.isUserInteractionEnabled = false
        blurView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
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
        backgroundColor = .clear
        layer.cornerRadius = 20
        clipsToBounds = true
        setTitleColor(.white, for: .normal)
        tintColor = .white
        titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        let configuration = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular, scale: .medium)
        setPreferredSymbolConfiguration(configuration, forImageIn: .normal)
        
        // Background
        addSubview(background)
        bringSubviewToFront(imageView!)
        bringSubviewToFront(titleLabel!)
        
        setupConstraints()
    }
    
    // MARK: Update
    
    public func update(title: String?, image: UIImage?) {
        setTitle(title, for: .normal)
        setImage(image, for: .normal)
    }
    
    // MARK: Constraints
    
    private func setupConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            // Self
            
        ])
    }
    
}
