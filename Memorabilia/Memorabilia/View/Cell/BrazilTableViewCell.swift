//
//  BrazilTableViewCell.swift
//  Memorabilia
//
//  Created by André Mello Alves on 27/05/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import UIKit

class BrazilTableViewCell: UITableViewCell {
    
    // MARK: Properties
    
    static let identifier = "Brazil"
    
    let flag: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
        
        // Image
        addSubview(flag)
        
        // Constraints
        setupConstraints()
    }
    
    // MARK: Update
    
    public func updatePhoto(_ data: Data) {
        flag.image = UIImage(data: data)
    }
    
    // MARK: Constraints
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Self
            heightAnchor.constraint(equalToConstant: 48),
            
            // Flag
            flag.widthAnchor.constraint(equalToConstant: 16),
            flag.heightAnchor.constraint(equalToConstant: 16),
            flag.centerXAnchor.constraint(equalTo: centerXAnchor),
            flag.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

}

