//
//  SettingsRouter.swift
//  Memorabilia
//
//  Created by André Mello Alves on 08/04/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import Foundation

protocol SettingsRouterInput {
    
    // Navigation
    
}

protocol SettingsRouterOutput {
    
    // Data passing
    
    var interactor: SettingsInteractorData? { get }
    
}

class SettingsRouter: SettingsRouterInput, SettingsRouterOutput {
    
    // MARK: Clean Properties
    
    weak var viewController: SettingsViewController?
    
    var interactor: SettingsInteractorData?
    
    // MARK: Navigation
    
    // MARK: Data passing
    
}
