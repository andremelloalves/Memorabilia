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
    
    func routeToStudioViewController()
    
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
    
    func routeToStudioViewController() {
        // Perform segue
        let studioViewController = StudioViewController()
        studioViewController.modalTransitionStyle = .coverVertical
        studioViewController.modalPresentationStyle = .fullScreen
        
        var dInteractor = studioViewController.router!.interactor!
        
        passDataStudioViewController(source: interactor!, destination: &dInteractor)
        viewController?.menu?.present(studioViewController, animated: true, completion: nil)
    }
    
    // MARK: Data passing
    
    private func passDataStudioViewController(source: CreateInteractorData, destination: inout StudioInteractorData) {
        // Pass data
        destination.db = source.db
    }

}
