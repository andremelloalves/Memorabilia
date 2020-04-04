//
//  OptionsBarView.swift
//  Memorabilia
//
//  Created by André Mello Alves on 02/04/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import UIKit

class OptionsBarView: UIView {
    
    // MARK: Properties
    
    let stack: UIStackView = {
        let view = UIStackView()
        view.alignment = .fill
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let focus: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    lazy var background: UIVisualEffectView = {
        // Blur
        let blur = UIBlurEffect(style: .regular)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        // Vibrancy
        let vibrancy = UIVibrancyEffect(blurEffect: blur, style: .label)
        let vibrancyView = UIVisualEffectView(effect: vibrancy)
        vibrancyView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        vibrancyView.contentView.addSubview(focus)
        blurView.contentView.addSubview(vibrancyView)
        return blurView
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
        
        // Background
        addSubview(background)
        
        // Focus
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        stack.addGestureRecognizer(pan)
        
        // Stack
        addSubview(stack)
        
        // Constraints
        setupConstraints()
    }
    
    // MARK: Constraints
    
    private func setupConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            // Self
            heightAnchor.constraint(equalToConstant: 50),
            
            // Stack
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            stack.leftAnchor.constraint(equalTo: leftAnchor, constant: 4),
            stack.rightAnchor.constraint(equalTo: rightAnchor, constant: -4),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4)
        ])
    }
    
    // MARK: View life cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateFocus()
    }
    
    // MARK: Action
    
    @objc func handleTap(sender: UIButton) {
        let animation = { self.focus.frame = sender.frame + CGPoint(x: 4, y: 4) }
        animator.addAnimations(animation)
        animator.startAnimation()
    }
    
    @objc func handlePan(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: focus)
        let animation = { self.focus.frame = self.focusSnap }
        
        switch sender.state {
        case .changed:
            animator.pauseAnimation()
            dragBy(translation)
        case .ended:
            animator.addAnimations(animation)
            animator.startAnimation()
        default:
            break
        }
        
        sender.setTranslation(.zero, in: focus)
    }
    
    // MARK: Animations
    
    private let animator: UIViewPropertyAnimator = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut, animations: nil)
    
    private func validateDrag(_ translation: CGPoint) -> Bool {
        let isUnder = focus.frame.minX + translation.x < stack.frame.minX
        let isOver = focus.frame.maxX + translation.x > stack.frame.maxX
        return !isUnder && !isOver
    }
    
    private func dragBy(_ translation: CGPoint) {
        let isValid = validateDrag(translation)
        guard isValid else { return }
        focus.center = CGPoint(x: focus.center.x + translation.x, y: focus.center.y)
    }
    
    private var focusSnap: CGRect {
        let frames = buttons.map { $0.frame }
        let closest = frames.reduce(.zero) { focus.frame.center <-> $0.center < focus.frame.center <-> $1.center ? $0 : $1 }
        return closest + CGPoint(x: 4, y: 4)
    }
    
    public func updateFocus() {
        let width = stack.frame.width / CGFloat(buttons.count)
        let height = stack.frame.height
        let animation = { self.focus.frame = CGRect(x: 4, y: 4, width: width, height: height) }
        animator.addAnimations(animation)
        animator.startAnimation()
    }
    
    // MARK: Delegate
    
    private var buttons: [UIButton] = []
    
    public func addButton(iconName: String) {
        let button = OptionsBarButton()
        button.setImage(UIImage(systemName: iconName), for: .normal)
        button.addTarget(self, action: #selector(handleTap), for: .primaryActionTriggered)
        stack.addArrangedSubview(button)
        buttons.append(button)
    }
    
    public func removeButton() {
        guard let button = buttons.popLast() else { return }
        stack.removeArrangedSubview(button)
        button.removeFromSuperview()
        updateFocus()
    }
    
}
