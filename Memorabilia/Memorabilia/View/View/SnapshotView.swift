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
        parentFrame = .zero
        super.init(coder: coder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        // Self
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
    
    private var widthConstraint = NSLayoutConstraint()
    
    private var heigthConstraint = NSLayoutConstraint()
    
    private func setupConstraints() {
        widthConstraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: snapshotSize(multiplier: 0.3).width)
        heigthConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: snapshotSize(multiplier: 0.3).height)
        
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            // Self
            widthConstraint,
            heigthConstraint,
            
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
            self.widthConstraint.constant = self.snapshotSize(multiplier: 0.7).width
            self.heigthConstraint.constant = self.snapshotSize(multiplier: 0.7).height
//            self.layoutIfNeeded()
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
            self.widthConstraint.constant = self.snapshotSize(multiplier: 0.3).width
            self.heigthConstraint.constant = self.snapshotSize(multiplier: 0.3).height
//            self.layoutIfNeeded()
        }
        let completion: (UIViewAnimatingPosition) -> () = { [weak self] _ in
            self?.isExpanded = false
            self?.sizeIcon.image = UIImage(systemName: "arrow.up.left.and.arrow.down.right")
        }
        animator.addAnimations(animation)
        animator.addCompletion(completion)
        animator.startAnimation()
    }
    
    private func snapshotSize(multiplier: CGFloat) -> CGSize {
        let width = parentFrame.width * multiplier
        let height = parentFrame.height * multiplier
        return CGSize(width: width, height: height)
    }
    
    private func startAnimation() {
        UIView.animate(withDuration: 0.15) {
            self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }
    }
    
    private func stopAnimation() {
        UIView.animate(withDuration: 0.15) {
            self.transform = .identity
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

