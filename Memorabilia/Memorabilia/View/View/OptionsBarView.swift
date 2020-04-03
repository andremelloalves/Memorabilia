//
//  OptionsBarView.swift
//  Memorabilia
//
//  Created by André Mello Alves on 02/04/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import UIKit

class OptionsBarView: UIView {
    
    // MARK: Properties
    
    private var buttons: [UIButton] = []
    
    let background: UIVisualEffectView = {
        // Blur
        let blur = UIBlurEffect(style: .regular)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.isUserInteractionEnabled = false
        blurView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return blurView
    }()
    
    let highlight: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .regular)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.isUserInteractionEnabled = false
        blurView.backgroundColor = .systemPurple
//        blurView.alpha = 0.75
        blurView.layer.cornerRadius = 16
        blurView.clipsToBounds = true
        blurView.frame = CGRect(x: 4, y: 4, width: 78, height: 42)
        return blurView
    }()
    
    let stack: UIStackView = {
        let view = UIStackView()
        view.alignment = .fill
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.backgroundColor = .clear
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
        backgroundColor = .clear
        layer.cornerRadius = 20
        clipsToBounds = true
        
        // Background
        addSubview(background)
        
        // Highlight
        addSubview(highlight)
        
        // Stack
        addSubview(stack)
        
        // Buttons
        
        setupConstraints()
    }
    
    func addButton(iconName: String) {
        let button = UIButton()
        button.backgroundColor = .clear
        button.tintColor = .systemPurple
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        let configuration = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular, scale: .medium)
        button.setPreferredSymbolConfiguration(configuration, forImageIn: .normal)
        button.setImage(UIImage(systemName: iconName), for: .normal)
        button.addTarget(self, action: #selector(tap(sender:)), for: .primaryActionTriggered)
        stack.addArrangedSubview(button)
        buttons.append(button)
    }
    
    @objc func tap(sender: UIButton) {
        UIView.animate(withDuration: 0.3) {
            self.highlight.center = sender.center
        }
    }
    
    // MARK: Constraints
    
    private func setupConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            // Self
            heightAnchor.constraint(equalToConstant: 50),
            
            // Highlight
//            highlight.heightAnchor.constraint(equalTo: heightAnchor),
            
            // Stack
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.leftAnchor.constraint(equalTo: leftAnchor),
            stack.rightAnchor.constraint(equalTo: rightAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
}
