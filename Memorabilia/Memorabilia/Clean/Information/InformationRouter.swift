//
//  InformationRouter.swift
//  Memorabilia
//
//  Created by André Mello Alves on 24/05/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import Foundation

protocol InformationRouterInput {
    
    // Navigation
    
}

protocol InformationRouterOutput {
    
    // Data passing
    
    var interactor: InformationInteractorData? { get }
    
}

class InformationRouter: InformationRouterInput, InformationRouterOutput {
    
    // MARK: Clean Properties
    
    weak var viewController: InformationViewController?
    
    var interactor: InformationInteractorData?
    
    // MARK: Navigation
    
    // MARK: Data passing
    
}
