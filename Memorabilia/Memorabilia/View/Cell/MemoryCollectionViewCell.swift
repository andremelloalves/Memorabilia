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
    
    let cover: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .systemPurple
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
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
        
        // Photo
        addSubview(cover)
        
        // Constraints
        setupConstraints()
    }
    
    // MARK: Update
    
    public func updateCover(_ data: Data) {
        cover.image = UIImage(data: data)
    }
    
    // MARK: Constraints
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Self
            
            // Cover
            cover.topAnchor.constraint(equalTo: topAnchor),
            cover.leftAnchor.constraint(equalTo: leftAnchor),
            cover.rightAnchor.constraint(equalTo: rightAnchor),
            cover.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

}
