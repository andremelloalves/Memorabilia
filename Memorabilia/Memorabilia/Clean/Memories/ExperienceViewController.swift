//
//  ExperienceViewController.swift
//  Memorabilia
//
//  Created by André Mello Alves on 15/03/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import UIKit

protocol ExperienceViewInput: class {
    
}

class ExperienceViewController: UIViewController, ExperienceViewInput {
    
    // MARK: Clean Properties
    
    var interactor: ExperienceInteractorInput?
    
    var router: (ExperienceRouterInput & ExperienceRouterOutput)?
    
    // MARK: Initializers
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        cleanSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        cleanSetup()
    }
    
    // MARK: View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .cyan
    }

}

extension ExperienceViewController {
    
    // MARK: Clean setup
    
    private func cleanSetup() {
        let viewController = self
        let interactor = ExperienceInteractor()
        let presenter = ExperiencePresenter()
        let router = ExperienceRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.interactor = interactor
    }
    
}
