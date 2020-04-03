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
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
//    let shadow: UIView = {
//        let view = UIView()
//        view.backgroundColor = .systemBackground
//        view.clipsToBounds = true
//        view.layer.masksToBounds = false
//        view.layer.cornerRadius = 20
//        view.layer.shadowRadius = 8
//        view.layer.shadowColor = UIColor.black.cgColor
//        view.layer.shadowOpacity = 0.5
//        view.layer.shadowOffset = .zero
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
    
    let infoView: InfoView = {
        let view = InfoView()
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
        
        // Shadow
        
        // Photo
        
        // Subviews
//        addSubview(shadow)
        addSubview(photo)
        photo.addSubview(infoView)
        
        // Constraints
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
        NSLayoutConstraint.activate([
            // Self
            
            // Photo
            photo.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            photo.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            photo.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            photo.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            
            // Shadow
//            shadow.topAnchor.constraint(equalTo: photo.topAnchor),
//            shadow.leftAnchor.constraint(equalTo: photo.leftAnchor),
//            shadow.rightAnchor.constraint(equalTo: photo.rightAnchor),
//            shadow.bottomAnchor.constraint(equalTo: photo.bottomAnchor),
            
            // Info view
            infoView.leftAnchor.constraint(equalTo: photo.leftAnchor, constant: 8),
            infoView.rightAnchor.constraint(equalTo: photo.rightAnchor, constant: -8),
            infoView.bottomAnchor.constraint(equalTo: photo.bottomAnchor, constant: -8),
        ])
    }
    
    // MARK: Animation
    
    private func startAnimation() {
        UIView.animate(withDuration: 0.15) {
            self.photo.transform = CGAffineTransform(scaleX: 0.975, y: 0.975)
        }
    }
    
    private func stopAnimation() {
        UIView.animate(withDuration: 0.15) {
            self.photo.transform = .identity
        }
    }
    
    // MARK: Touch
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        startAnimation()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        stopAnimation()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        stopAnimation()
    }

}
