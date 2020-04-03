//
//  ActionBarButton.swift
//  Relista
//
//  Created by André Mello Alves on 11/10/19.
//  Copyright © 2019 André Mello Alves. All rights reserved.
//
import UIKit

class ActionBarButton: UIButton {

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
        setTitleColor(.systemBackground, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        
        // Background
        addSubview(background)
        bringSubviewToFront(titleLabel!)
        
        setupConstraints()
    }
    
    // MARK: Constraints
    
    private func setupConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            // Self
            heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
}
