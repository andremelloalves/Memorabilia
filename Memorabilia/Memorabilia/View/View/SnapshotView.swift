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
    
    let parentFrame: CGRect
    
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
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(pan)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
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
    
    @objc func handleTap() {
        animate()
    }
    
    @objc func handlePan(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            animate()
            animator.pauseAnimation()
        case .changed:
            let translation = sender.translation(in: sender.view)
            var fraction: CGFloat
            
            if isExpanded {
                fraction = collapseProgress(translation: translation)
            } else {
                fraction = expandProgress(translation: translation)
            }
            
            animator.fractionComplete = fraction
        case .ended:
            let velocity = sender.velocity(in: sender.view)
            
            var canEnd = canComplete(velocity: velocity)
            if velocity.x == 0 && velocity.y == 0 {
                canEnd = animator.fractionComplete >= 0.5
            }
            
            animator.isReversed = !canEnd
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        default:
            return
        }
    }
    
    // MARK: Animation
    
    private let animator: UIViewPropertyAnimator = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut, animations: nil)
    
    private func animate() {
        if isExpanded {
            collapse()
        } else {
            expand()
        }
    }
    
    private func expand() {
        let animation = { [unowned self] in
            self.frame = self.snapshotFrame(multiplier: 0.7)
        }
        let completion: (UIViewAnimatingPosition) -> () = { [weak self] state in
            if state == .end {
                self?.isExpanded = true
                self?.sizeIcon.image = UIImage(systemName: "arrow.down.right.and.arrow.up.left")
            }
        }
        animator.addAnimations(animation)
        animator.addCompletion(completion)
        animator.startAnimation()
    }

    private func collapse() {
        let animation = { [unowned self] in
            self.frame = self.snapshotFrame(multiplier: 0.3)
        }
        let completion: (UIViewAnimatingPosition) -> () = { [weak self] state in
            if state == .end {
                self?.isExpanded = false
                self?.sizeIcon.image = UIImage(systemName: "arrow.up.left.and.arrow.down.right")
            }
        }
        animator.addAnimations(animation)
        animator.addCompletion(completion)
        animator.startAnimation()
    }
    
    private func canComplete(velocity: CGPoint) -> Bool {
        let max = signedMax(velocity.x, velocity.y)
        if isExpanded {
            return max > 0
        } else {
            return max < 0
        }
    }
    
    private func expandProgress(translation: CGPoint) -> CGFloat {
        let size = snapshotFrame(multiplier: 0.7).size - snapshotFrame(multiplier: 0.3).size
        let xFraction = -translation.x / size.width
        let yFraction = -translation.y / size.height
        return max(xFraction, yFraction)
    }
    
    private func collapseProgress(translation: CGPoint) -> CGFloat {
        let size = snapshotFrame(multiplier: 0.7).size - snapshotFrame(multiplier: 0.3).size
        let xFraction = translation.x / size.width
        let yFraction = translation.y / size.height
        return max(xFraction, yFraction)
    }
    
    private func snapshotFrame(multiplier: CGFloat) -> CGRect {
        let width = parentFrame.width * multiplier
        let height = parentFrame.height * multiplier
        let x = parentFrame.width - width - 16
        let y = parentFrame.height - height - 16
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
}

