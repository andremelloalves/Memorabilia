//
//  MemoryContextMenuViewController.swift
//  Memorabilia
//
//  Created by André Mello Alves on 28/05/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import UIKit
import PromiseKit

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
        label.font = .systemFont(ofSize: 34, weight: .bold)
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
        label.font = .systemFont(ofSize: 23, weight: .semibold)
        label.adjustsFontForContentSizeCategory = true
        label.adjustsFontSizeToFitWidth = false
        label.baselineAdjustment = .alignCenters
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var background: UIVisualEffectView = {
        // Blur
        let blur = UIBlurEffect(style: .regular)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        
        // Vibrancy
        let vibrancy = UIVibrancyEffect(blurEffect: blur, style: .label)
        let vibrancyView = UIVisualEffectView(effect: vibrancy)
        vibrancyView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        vibrancyView.contentView.addSubview(date)
        vibrancyView.contentView.addSubview(name)
        blurView.contentView.addSubview(vibrancyView)
        return blurView
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
        
        // Background
        view.addSubview(background)
        
        // Constraints
        setupConstraints()
    }
    
    // MARK: Update
    
    public func update(memory: MemoriesEntity.Display.MemoryItem) {
        date.text = memory.date
        name.text = memory.name
        
        firstly {
            App.session.db.readMemoryPhoto(with: memory.photoID)
        }.done { photo in
            self.cover.image = UIImage(data: photo)
        }.catch { error in
            print(error.localizedDescription)
        }
    }
    
    // MARK: Constraints
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Cover
            cover.topAnchor.constraint(equalTo: view.topAnchor),
            cover.leftAnchor.constraint(equalTo: view.leftAnchor),
            cover.rightAnchor.constraint(equalTo: view.rightAnchor),
            cover.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Background
            background.topAnchor.constraint(equalTo: date.topAnchor, constant: -16),
            background.leftAnchor.constraint(equalTo: view.leftAnchor),
            background.rightAnchor.constraint(equalTo: view.rightAnchor),
            background.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
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
