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
    
    let activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        view.color = .label
        view.hidesWhenStopped = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let cover: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
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
        
        // Activity indicator
        addSubview(activityIndicator)
        
        // Photo
        addSubview(cover)
        
        // Constraints
        setupConstraints()
    }
    
    // MARK: Update
    
    public func updateCover(_ data: Data) {
        cover.image = UIImage(data: data)
        activityIndicator.stopAnimating()
    }
    
    // MARK: Constraints
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Self
            
            // Activity indicator
            activityIndicator.topAnchor.constraint(equalTo: topAnchor),
            activityIndicator.leftAnchor.constraint(equalTo: leftAnchor),
            activityIndicator.rightAnchor.constraint(equalTo: rightAnchor),
            activityIndicator.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // Cover
            cover.topAnchor.constraint(equalTo: topAnchor),
            cover.leftAnchor.constraint(equalTo: leftAnchor),
            cover.rightAnchor.constraint(equalTo: rightAnchor),
            cover.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

}
