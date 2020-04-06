//
//  SnapshotView.swift
//  Memorabilia
//
//  Created by André Mello Alves on 05/04/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import UIKit

class SnapshotView: UIImageView {
    
    // MARK: Properties
    
    let sizeIcon: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.tintColor = .white
        view.contentMode = .scaleAspectFit
        view.image = UIImage(systemName: "arrow.up.left.and.arrow.down.right")
        let configuration = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular, scale: .small)
        view.preferredSymbolConfiguration = configuration
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: Control properties
    
    var parentFrame: CGRect
    
    var isExpanded = false
    
    // MARK: Initializers
    
    override init(frame: CGRect) {
        self.parentFrame = frame
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        self.parentFrame = .zero
        super.init(coder: coder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        // Self
        frame = snapshotFrame(multiplier: 0.3)
        layer.cornerRadius = 20
        clipsToBounds = true
        backgroundColor = .systemBackground
        isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(sizeAction))
        addGestureRecognizer(tap)
        
        // Background
        addSubview(sizeIcon)
        
        // Constraints
        setupConstraints()
    }
    
    // MARK: Constraints
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Self
            
            // SizeIcon
            sizeIcon.widthAnchor.constraint(equalToConstant: 40),
            sizeIcon.heightAnchor.constraint(equalToConstant: 40),
            sizeIcon.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            sizeIcon.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
    
    // MARK: View life cycle
    
    // MARK: Action
    
    @objc func sizeAction() {
        if isExpanded {
            contractSnapshot()
        } else {
            expandSnapshot()
        }
    }
    
    // MARK: Animation
    
    private let animator: UIViewPropertyAnimator = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut, animations: nil)
    
    private func expandSnapshot() {
        let animation = { [unowned self] in
            self.frame = self.snapshotFrame(multiplier: 0.7)
        }
        let completion: (UIViewAnimatingPosition) -> () = { [weak self] _ in
            self?.isExpanded = true
            self?.sizeIcon.image = UIImage(systemName: "arrow.down.right.and.arrow.up.left")
        }
        animator.addAnimations(animation)
        animator.addCompletion(completion)
        animator.startAnimation()
    }
    
    private func contractSnapshot() {
        let animation = { [unowned self] in
            self.frame = self.snapshotFrame(multiplier: 0.3)
        }
        let completion: (UIViewAnimatingPosition) -> () = { [weak self] _ in
            self?.isExpanded = false
            self?.sizeIcon.image = UIImage(systemName: "arrow.up.left.and.arrow.down.right")
        }
        animator.addAnimations(animation)
        animator.addCompletion(completion)
        animator.startAnimation()
    }
    
    private func snapshotFrame(multiplier: CGFloat) -> CGRect {
        let width = parentFrame.width * multiplier
        let height = parentFrame.height * multiplier
        let x = parentFrame.width - width - 16
        let y = parentFrame.height - height - 16
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
}

