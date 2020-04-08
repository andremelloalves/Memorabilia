//
//  CreateRouter.swift
//  Memorabilia
//
//  Created by André Mello Alves on 08/04/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import Foundation

protocol CreateRouterInput {
    
    // Navigation
    
}

protocol CreateRouterOutput {
    
    // Data passing
    
    var interactor: CreateInteractorData? { get }
    
}

class CreateRouter: CreateRouterInput, CreateRouterOutput {
    
    // MARK: Clean Properties
    
    weak var viewController: CreateViewController?
    
    var interactor: CreateInteractorData?
    
    // MARK: Navigation
    
    // MARK: Data passing
    
}
