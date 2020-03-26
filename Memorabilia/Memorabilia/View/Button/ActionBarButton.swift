//
//  ActionBarButton.swift
//  Relista
//
//  Created by André Mello Alves on 11/10/19.
//  Copyright © 2019 André Mello Alves. All rights reserved.
//
import UIKit

class ActionBarButton: UIButton {

    // MARK: Properties
    
//    let icon: UIImageView = {
//        let view = UIImageView()
//        view.tintColor = .systemGreen
//        view.contentMode = .scaleAspectFit
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
    
    let title: UILabel = {
        let title = UILabel()
        title.backgroundColor = .clear
        title.textColor = .label
        title.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        title.adjustsFontForContentSizeCategory = true
        title.adjustsFontSizeToFitWidth = true
        title.baselineAdjustment = .alignCenters
        title.textAlignment = .center
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
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
        backgroundColor = .secondarySystemFill
        layer.cornerRadius = 20
        clipsToBounds = true
        
        // Icon
//        icon.image = UIImage(systemName: "plus.circle.fill")
//        addSubview(icon)
        
        // Title
        title.text = "Criar memória"
        
        addSubview(title)
        
        setupConstraints()
    }
    
    // MARK: Constraints
    
    private func setupConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            // Self
            heightAnchor.constraint(equalToConstant: 50),
            
            // Icon
//            icon.heightAnchor.constraint(equalToConstant: 40),
//            icon.widthAnchor.constraint(equalToConstant: 40),
//            icon.centerYAnchor.constraint(equalTo: centerYAnchor),
//            icon.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            
            // Title
            title.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            title.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            title.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
}
