//
//  EmptyMemoryCollectionViewCell.swift
//  Memorabilia
//
//  Created by André Mello Alves on 05/04/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import UIKit

class EmptyMemoryCollectionViewCell: UICollectionViewCell {
    
    // MARK: Properties
    
    static let identifier = "EmptyMemory"
    
    let photo: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .systemPurple
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
        addSubview(photo)
        
        // Info
        photo.addSubview(infoView)
        
        // Constraints
        setupConstraints()
    }
    
    // MARK: Update
    
    public func update(memory: MemoriesEntity.Display.MemoryItem) {
        infoView.titleLabel.text = memory.name
        infoView.infoLabel.text = memory.date
    }
    
    public func updatePhoto(_ data: Data) {
        photo.image = UIImage(data: data)
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
        super.touchesBegan(touches, with: event)
        startAnimation()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        stopAnimation()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        stopAnimation()
    }

}
