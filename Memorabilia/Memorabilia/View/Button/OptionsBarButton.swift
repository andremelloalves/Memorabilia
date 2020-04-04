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
        let configuration = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular, scale: .medium)
        setPreferredSymbolConfiguration(configuration, forImageIn: .normal)
    }
    
}

