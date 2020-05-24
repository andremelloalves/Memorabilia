//
//  InformationViewController.swift
//  Memorabilia
//
//  Created by André Mello Alves on 24/05/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import UIKit

protocol InformationViewInput: class {

    // Update
    
    func loadSections(sections: [InformationSection])
    
    func reloadSections(changes: SectionChanges, sections: [InformationSection])
    
}

class InformationViewController: UIViewController {
    
    // MARK: Clean Properties
    
    var interactor: InformationInteractorInput?
    
    var router: (InformationRouterInput & InformationRouterOutput)?
    
    // MARK: View properties

    // MARK: Control properties
    
    var type: InformationType = .app

    // MARK: ... properties
    
    // MARK: View model
    
    // MARK: Initializers
    
    init(type: InformationType) {
        super.init(nibName: nil, bundle: nil)
        self.type = type
    }
    
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
        
        // ... views
        
        // Constraints
        setupConstraints()
    }
    
    // MARK: Constraints
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // ... views
        ])
    }
    
    // MARK: View life cycle
    
    // MARK: Action

    // MARK: Animation
    
    // MARK: Navigation
    
}

extension InformationViewController {
    
    // MARK: Clean setup
    
    private func cleanSetup() {
        let viewController = self
        let interactor = InformationInteractor()
        let presenter = InformationPresenter()
        let router = InformationRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.interactor = interactor
    }
    
}

extension InformationViewController: InformationViewInput {
    
    // Update
    
    func loadSections(sections: [InformationSection]) {
        
    }
    
    func reloadSections(changes: SectionChanges, sections: [InformationSection]) {
        
    }
    
}
