//
//  TableViewHeaderView.swift
//  Memorabilia
//
//  Created by André Mello Alves on 28/05/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import UIKit

class TableViewHeaderView: UITableViewHeaderFooterView {
    
    // MARK: Properties
    
    static let identifier = "TableHeader"
    
    let titleLabel: UILabel = {
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
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        // Self
        let view = UIView()
        view.backgroundColor = .clear
        backgroundView = view
        
        // Title
        addSubview(titleLabel)
        
        // Constraints
        setupConstraints()
    }
    
    // MARK: Update
    
    public func updateTitle(title: String) {
        titleLabel.text = title
    }
    
    // MARK: Constraints
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Self
            
            // Title
            titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 28),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
        ])
    }
    
    // MARK: View life cycle
    
    // MARK: Action
    
    // MARK: Animation
    
    // MARK: Touch
    
    // MARK: Delegate
    
}
