//
//  MemoryCollectionViewCell.swift
//  Memorabilia
//
//  Created by André Mello Alves on 01/12/19.
//  Copyright © 2019 André Mello Alves. All rights reserved.
//

import UIKit

class MemoryCollectionViewCell: UICollectionViewCell {
    
    // MARK: Properties
    
    static let identifier = "Memory"
    
//    let moreField: InputTextView = {
//        let view = InputTextView()
//        view.clearButtonMode = .whileEditing
//        return view
//    }()
    
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
        
        // Text field
//        addSubview(moreField)
        
        setupConstraints()
    }
    
    private func update() {
//        guard let more = more else { return }
//
//        // More
//        moreField.placeholder = more.placeholder
//        moreField.text = more.more
    }
    
    // MARK: Constraints
    
    private func setupConstraints() {
//        NSLayoutConstraint.activate([
//            // Self
//            moreField.topAnchor.constraint(equalTo: topAnchor),
//            moreField.centerYAnchor.constraint(equalTo: centerYAnchor),
//            moreField.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
//            moreField.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
//            moreField.bottomAnchor.constraint(equalTo: bottomAnchor)
//        ])
    }

}
