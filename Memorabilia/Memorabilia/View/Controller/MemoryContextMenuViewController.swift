//
//  MemoryContextMenuViewController.swift
//  Memorabilia
//
//  Created by André Mello Alves on 28/05/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import UIKit

class MemoryContextMenuViewController: UIViewController {

    // MARK: Properties
    
    let cover: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .systemBackground
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let date: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.backgroundColor = .clear
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.adjustsFontForContentSizeCategory = true
        label.adjustsFontSizeToFitWidth = false
        label.baselineAdjustment = .alignCenters
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let name: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.backgroundColor = .clear
        label.font = UIFont.systemFont(ofSize: 23, weight: .semibold)
        label.adjustsFontForContentSizeCategory = true
        label.adjustsFontSizeToFitWidth = false
        label.baselineAdjustment = .alignCenters
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: Initializers
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        // Self
        view.backgroundColor = .systemBackground
        let width = UIScreen.main.bounds.width - 32
        preferredContentSize = CGSize(width: width, height: width)
        
        // Cover
        view.addSubview(cover)
        
        // Date
        view.addSubview(date)
        
        // Name
        view.addSubview(name)
        
        // Constraints
        setupConstraints()
    }
    
    // MARK: Constraints
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Cover
            cover.topAnchor.constraint(equalTo: view.topAnchor),
            cover.leftAnchor.constraint(equalTo: view.leftAnchor),
            cover.rightAnchor.constraint(equalTo: view.rightAnchor),
            cover.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Date
            date.heightAnchor.constraint(equalToConstant: 41),
            date.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            date.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            date.bottomAnchor.constraint(equalTo: name.topAnchor, constant: -4),
            
            // Name
            name.heightAnchor.constraint(equalToConstant: 28),
            name.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            name.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            name.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
        ])
    }
    
}
