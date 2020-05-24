//
//  MemoriesRouter.swift
//  Memorabilia
//
//  Created by André Mello Alves on 15/03/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import Foundation

protocol MemoriesRouterInput {
    
    // Navigation
    
    func routeToExperienceViewController(memoryID: String)
    
}

protocol MemoriesRouterOutput {
    
    // Data passing
    
    var interactor: MemoriesInteractorData? { get }
    
}

class MemoriesRouter: MemoriesRouterInput, MemoriesRouterOutput {
    
    // MARK: Clean Properties
    
    weak var viewController: MemoriesViewController?
    
    var interactor: MemoriesInteractorData?
    
    // MARK: Navigation
    
    func routeToInformationViewController(type: InformationType) {
        let informationViewController = InformationViewController()
        informationViewController.modalTransitionStyle = .coverVertical
        informationViewController.modalPresentationStyle = .fullScreen
        informationViewController.transitioningDelegate = viewController
        
        var dInteractor = informationViewController.router!.interactor!
        
        passDataInformationViewController(source: interactor!, destination: &dInteractor, type: type)
        viewController?.menu?.present(informationViewController, animated: true, completion: nil)
    }
    
    func routeToExperienceViewController(memoryID: String) {
        let experienceViewController = ExperienceViewController()
        experienceViewController.modalTransitionStyle = .coverVertical
        experienceViewController.modalPresentationStyle = .fullScreen
        experienceViewController.transitioningDelegate = viewController
        
        var dInteractor = experienceViewController.router!.interactor!
        
        passDataExperienceViewController(source: interactor!, destination: &dInteractor, memoryID: memoryID)
        viewController?.menu?.present(experienceViewController, animated: true, completion: nil)
    }
    
    // MARK: Data passing
    
    private func passDataInformationViewController(source: MemoriesInteractorData,
                                                   destination: inout InformationInteractorData,
                                                   type: InformationType) {
        destination.db = source.db
        destination.type = type
    }
    
    private func passDataExperienceViewController(source: MemoriesInteractorData, destination: inout ExperienceInteractorData, memoryID: String) {
        destination.db = source.db
        destination.memory = source.memories?.first { $0.uid == memoryID }
    }
    
}
