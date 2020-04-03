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
    
    let stack: UIStackView = {
        let view = UIStackView()
        view.alignment = .fill
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let highlight: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.frame = CGRect(x: 4, y: 4, width: 78, height: 42)
        return view
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
        
        vibrancyView.contentView.addSubview(highlight)
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
        backgroundColor = .clear
        layer.cornerRadius = 20
        clipsToBounds = true
        
        // Background
        addSubview(background)
        
        // Highlight
        
        // Stack
        addSubview(stack)
        
        // Buttons
        
        setupConstraints()
    }
    
    func addButton(iconName: String) {
        let button = UIButton()
        button.backgroundColor = .clear
        button.tintColor = .systemBackground
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
            
            // Stack
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.leftAnchor.constraint(equalTo: leftAnchor),
            stack.rightAnchor.constraint(equalTo: rightAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
}
