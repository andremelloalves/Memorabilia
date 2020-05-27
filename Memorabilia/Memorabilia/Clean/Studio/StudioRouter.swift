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
    
    func routeToInformation(type: InformationType)
    
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
    
    func routeToInformation(type: InformationType) {
        let informationViewController = InformationViewController()
        informationViewController.modalTransitionStyle = .crossDissolve
        informationViewController.modalPresentationStyle = .overCurrentContext
        
        var dInteractor = informationViewController.router!.interactor!
        
        passDataInformationViewController(source: interactor!, destination: &dInteractor, type: type)
        viewController?.present(informationViewController, animated: true, completion: nil)
    }
    
    // MARK: Data passing
    
    private func passDataInformationViewController(source: StudioInteractorData,
                                                   destination: inout InformationInteractorData,
                                                   type: InformationType) {
        destination.db = source.db
        destination.type = type
    }
    
}
