//
//  CreateViewController.swift
//  Memorabilia
//
//  Created by André Mello Alves on 08/04/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import UIKit

protocol CreateViewInput: class {

    // Update
    
}

class CreateViewController: UIViewController, MenuPage {
    
    // MARK: Menu page
    
    var menu: MenuController?
    
    var type: MenuPageType = .create
    
    // MARK: Clean Properties
    
    var interactor: CreateInteractorInput?
    
    var router: (CreateRouterInput & CreateRouterOutput)?
    
    // MARK: View properties
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "Aqui vai uma explicação rápida de como criar uma experiência."
        label.backgroundColor = .clear
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.adjustsFontForContentSizeCategory = true
        label.adjustsFontSizeToFitWidth = false
        label.baselineAdjustment = .alignCenters
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var background: UIVisualEffectView = {
        // Blur
        let blur = UIBlurEffect(style: .regular)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.layer.cornerRadius = 20
        blurView.clipsToBounds = true
        blurView.translatesAutoresizingMaskIntoConstraints = false
        
        // Vibrancy
        let vibrancy = UIVibrancyEffect(blurEffect: blur, style: .label)
        let vibrancyView = UIVisualEffectView(effect: vibrancy)
        vibrancyView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        vibrancyView.contentView.addSubview(infoLabel)
        blurView.contentView.addSubview(vibrancyView)
        return blurView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Nome"
//        label.textColor = .white
        label.backgroundColor = .clear
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        label.adjustsFontForContentSizeCategory = true
        label.adjustsFontSizeToFitWidth = false
        label.baselineAdjustment = .alignCenters
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var nameInput: InputTextView = {
        let view = InputTextView()
        view.delegate = self
        return view
    }()
    
    let createButton: PillButton = {
        let button = PillButton()
        button.setTitle("Criar em AR", for: .normal)
        button.addTarget(self, action: #selector(createButtonAction), for: .primaryActionTriggered)
        return button
    }()

    // MARK: Control properties

    // MARK: ... properties
    
    // MARK: View model
    
    // MARK: Initializers
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        cleanSetup()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        cleanSetup()
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        // Self
        view.backgroundColor = .clear
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap)
        
        // Background
        view.addSubview(background)
        
        // Name
        view.addSubview(nameLabel)
        
        // Input
        view.addSubview(nameInput)
        
        // Create button
        view.addSubview(createButton)
        
        // Constraints
        setupConstraints()
    }
    
    // MARK: Constraints
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Self
            
            // Info
            infoLabel.topAnchor.constraint(equalTo: background.topAnchor, constant: 16),
            infoLabel.leftAnchor.constraint(equalTo: background.leftAnchor, constant: 16),
            infoLabel.rightAnchor.constraint(equalTo: background.rightAnchor, constant: -16),
            infoLabel.bottomAnchor.constraint(equalTo: background.bottomAnchor, constant: -16),
            
            // Background
            background.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 72),
            background.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16),
            background.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16),
            
            // Name
            nameLabel.heightAnchor.constraint(equalToConstant: 29),
            nameLabel.topAnchor.constraint(equalTo: background.bottomAnchor, constant: 16),
            nameLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16),
            nameLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16),
            
            // Input
            nameInput.heightAnchor.constraint(equalToConstant: 40),
            nameInput.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            nameInput.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16),
            nameInput.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16),
            
            // Create button
            createButton.heightAnchor.constraint(equalToConstant: 40),
            createButton.widthAnchor.constraint(equalToConstant: 120),
            createButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -82)
        ])
    }
    
    // MARK: View life cycle
    
    // MARK: Action
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        nameInput.resignFirstResponder()
    }
    
    @objc func createButtonAction() {
        if let name = nameInput.text {
            routeToStudio(name: name)
        } else {
            // Alert
        }
    }

    // MARK: Animation
    
    // MARK: Navigation
    
    func pageWillDisapear() {
        nameInput.resignFirstResponder()
    }
    
    private func routeToStudio(name: String) {
        router?.routeToStudioViewController(name: name)
    }
    
}

extension CreateViewController {
    
    // MARK: Clean setup
    
    private func cleanSetup() {
        let viewController = self
        let interactor = CreateInteractor()
        let presenter = CreatePresenter()
        let router = CreateRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.interactor = interactor
    }
    
}

extension CreateViewController: CreateViewInput {
    
    // Update
    
}

extension CreateViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return false
    }
    
}
