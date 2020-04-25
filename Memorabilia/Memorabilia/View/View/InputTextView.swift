//
//  InputTextView.swift
//  Memorabilia
//
//  Created by André Mello Alves on 07/11/19.
//  Copyright © 2019 André Mello Alves. All rights reserved.
//

import UIKit

class InputTextView: UITextField {
    
    // MARK: Properties
    
    var inset = UIEdgeInsets(top: 9, left: 16, bottom: 9, right: 16)
    
    lazy var backgroundBlur: UIVisualEffectView = {
        // Blur
        let blur = UIBlurEffect(style: .regular)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        return blurView
    }()
    
    // MARK: Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        // Self
        layer.cornerRadius = 20
        clipsToBounds = true
        textColor = .white
        font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        keyboardType = .asciiCapable
        autocorrectionType = .default
        
        // Background
        addSubview(backgroundBlur)
        
        // Constraints
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: Functions
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
      return bounds.inset(by: inset)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
      return bounds.inset(by: inset)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
      return bounds.inset(by: inset)
    }
    
}
