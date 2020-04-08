//
//  StudioRouter.swift
//  Memorabilia
//
//  Created by André Mello Alves on 29/03/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import Foundation

protocol StudioRouterInput {
    
    // Navigation
    
    func routeBack()
    
}

protocol StudioRouterOutput {
    
    // Data passing
    
    var interactor: StudioInteractorData? { get }
    
}

class StudioRouter: StudioRouterInput, StudioRouterOutput {
    
    // MARK: Clean Properties
    
    weak var viewController: StudioViewController?
    
    var interactor: StudioInteractorData?
    
    // MARK: Navigation
    
    func routeBack() {
        // Perform segue
        viewController?.dismiss(animated: true, completion: nil)
    }
    
}
