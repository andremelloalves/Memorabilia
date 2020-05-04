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
    
    let photo: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .systemPurple
//        view.layer.cornerRadius = 20
//        view.layer.borderWidth = 1
//        view.layer.borderColor = UIColor.white.cgColor
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
//    let infoView: InfoView = {
//        let view = InfoView()
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
        layer.cornerRadius = 20
        clipsToBounds = true
        
        // Photo
        addSubview(photo)
        
//        // Info
//        photo.addSubview(infoView)
        
        // Constraints
        setupConstraints()
    }
    
    // MARK: Update
    
    public func update(memory: MemoriesEntity.Display.MemoryItem) {
//        infoView.titleLabel.text = memory.name
//        infoView.infoLabel.text = memory.date
    }
    
    public func updatePhoto(_ data: Data) {
        photo.image = UIImage(data: data)
    }
    
    // MARK: Constraints
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Self
            
            // Photo
            photo.topAnchor.constraint(equalTo: topAnchor),
            photo.leftAnchor.constraint(equalTo: leftAnchor),
            photo.rightAnchor.constraint(equalTo: rightAnchor),
            photo.bottomAnchor.constraint(equalTo: bottomAnchor),
            
//            // Info view
//            infoView.leftAnchor.constraint(equalTo: photo.leftAnchor, constant: 8),
//            infoView.rightAnchor.constraint(equalTo: photo.rightAnchor, constant: -8),
//            infoView.bottomAnchor.constraint(equalTo: photo.bottomAnchor, constant: -8),
        ])
    }

}
