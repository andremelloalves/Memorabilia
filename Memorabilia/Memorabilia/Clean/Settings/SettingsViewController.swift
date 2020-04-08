//
//  SettingsViewController.swift
//  Memorabilia
//
//  Created by André Mello Alves on 08/04/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import UIKit

protocol SettingsViewInput: class {

    // Update
    
    func reloadSections(changes: SectionChanges, sections: [SettingsSection])
    
}

class SettingsViewController: UIViewController, MenuPage {

    // MARK: Menu page

    var menu: MenuController?
    
    // MARK: Clean Properties
    
    var interactor: SettingsInteractorInput?
    
    var router: (SettingsRouterInput & SettingsRouterOutput)?
    
    // MARK: View properties

    // MARK: Control properties

    // MARK: ... properties
    
    // MARK: View model
    
    // MARK: Initializers
    
    override init(nibName nibSettingsOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibSettingsOrNil, bundle: nibBundleOrNil)
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

extension SettingsViewController {
    
    // MARK: Clean setup
    
    private func cleanSetup() {
        let viewController = self
        let interactor = SettingsInteractor()
        let presenter = SettingsPresenter()
        let router = SettingsRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.interactor = interactor
    }
    
}

extension SettingsViewController: SettingsViewInput {
    
    // Update
    
    func reloadSections(changes: SectionChanges, sections: [SettingsSection]) {
        
    }
    
}
