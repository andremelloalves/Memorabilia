//
//  ExperiencePresenter.swift
//  Memorabilia
//
//  Created by André Mello Alves on 15/03/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import Foundation

protocol ExperiencePresenterInput {
    
    // Present
    
    func presentMemoryPhoto(_ data: Data)
    
    func presentARWorld(_ world: Data)
    
    func presentReminder(identifier: String)
    
}

class ExperiencePresenter: ExperiencePresenterInput {
    
    // MARK: Clean Properties
    
    weak var viewController: ExperienceViewInput?
    
    // MARK: Properties
    
    // MARK: Functions
    
    func presentMemoryPhoto(_ data: Data) {
        viewController?.loadPhoto(data)
    }
    
    func presentARWorld(_ world: Data) {
        viewController?.loadARWorld(world)
    }
    
    func presentReminder(identifier: String) {
        viewController?.reloadReminder(identifier: identifier)
    }
    
}
