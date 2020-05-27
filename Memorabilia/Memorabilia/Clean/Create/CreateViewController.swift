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
    
    // MARK: Clean Properties
    
    var interactor: CreateInteractorInput?
    
    var router: (CreateRouterInput & CreateRouterOutput)?
    
    // MARK: View properties
    
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
        
        // Create button
        view.addSubview(createButton)
        
        // Constraints
        setupConstraints()
    }
    
    // MARK: Constraints
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Self
            
            // Create button
            createButton.heightAnchor.constraint(equalToConstant: 40),
            createButton.widthAnchor.constraint(equalToConstant: 120),
            createButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK: View life cycle
    
    // MARK: Action
    
    @objc func createButtonAction() {
        routeToStudio()
    }

    // MARK: Animation
    
    // MARK: Navigation
    
    private func routeToStudio() {
        router?.routeToStudioViewController()
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
