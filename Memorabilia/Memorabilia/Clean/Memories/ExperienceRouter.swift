//
//  ExperienceRouter.swift
//  Memorabilia
//
//  Created by André Mello Alves on 15/03/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import Foundation

protocol ExperienceRouterInput {
    
    // Navigation
    
    func routeBack()
    
}

protocol ExperienceRouterOutput {
    
    // Data passing
    
    var interactor: ExperienceInteractorData? { get }
    
}

class ExperienceRouter: ExperienceRouterInput, ExperienceRouterOutput {
    
    // MARK: Clean Properties
    
    weak var viewController: ExperienceViewController?
    
    var interactor: ExperienceInteractorData?
    
    // MARK: Navigation
    
    func routeBack() {
        viewController?.navigationController?.popViewController(animated: true)
    }
    
    // MARK: Data passing
    
}

