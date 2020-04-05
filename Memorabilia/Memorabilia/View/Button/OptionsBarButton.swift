//
//  OptionsBarButton.swift
//  Memorabilia
//
//  Created by André Mello Alves on 04/04/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import UIKit

class OptionsBarButton: UIButton {
    
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
        tintColor = .systemBackground
        layer.cornerRadius = 20
        clipsToBounds = true
        adjustsImageWhenHighlighted = false
        addTarget(self, action: #selector(buttonAction), for: .primaryActionTriggered)
        let configuration = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular, scale: .medium)
        setPreferredSymbolConfiguration(configuration, forImageIn: .normal)
    }
    
    // MARK: Action
    
    @objc private func buttonAction() {
        execute()
    }
    
    // MARK: Delegate
    
    private var actions: [() -> ()] = []
    
    public func addAction(_ action: @escaping () -> ()) {
        actions.append(action)
    }
    
    public func execute() {
        actions.forEach { $0() }
    }
    
}

