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
    
    func routeToCreateViewController()
    
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
    
    func routeToExperienceViewController(memoryID: String) {
        // Perform segue
        let experienceViewController = ExperienceViewController()
        experienceViewController.modalTransitionStyle = .coverVertical
        experienceViewController.modalPresentationStyle = .fullScreen
        
        var dInteractor = experienceViewController.router!.interactor!
        
        passDataExperienceViewController(source: interactor!, destination: &dInteractor, memoryID: memoryID)
        viewController?.present(experienceViewController, animated: true, completion: nil)
    }
    
    func routeToCreateViewController() {
        // Perform segue
        let createViewController = CreateViewController()
        createViewController.modalTransitionStyle = .coverVertical
        createViewController.modalPresentationStyle = .fullScreen
        
        var dInteractor = createViewController.router!.interactor!
        
        passDataCreateViewController(source: interactor!, destination: &dInteractor)
        viewController?.present(createViewController, animated: true, completion: nil)
    }
    
    // MARK: Data passing
    
    private func passDataExperienceViewController(source: MemoriesInteractorData, destination: inout ExperienceInteractorData, memoryID: String) {
        // Pass data
        destination.db = source.db
        destination.memory = source.memories?.first { $0.uid == memoryID }
    }
    
    private func passDataCreateViewController(source: MemoriesInteractorData, destination: inout CreateInteractorData) {
        // Pass data
        destination.db = source.db
        destination.memories = source.memories
    }
    
}
