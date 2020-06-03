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
    
    func presentSnapshot(with data: Data)
    
    func presentWorld(with data: Data)
    
    func presentReminder(with identifier: String)
    
}

class ExperiencePresenter: ExperiencePresenterInput {
    
    // MARK: Clean Properties
    
    weak var viewController: ExperienceViewInput?
    
    // MARK: Properties
    
    // MARK: Functions
    
    func presentSnapshot(with data: Data) {
        viewController?.loadSnapshot(with: data)
    }
    
    func presentWorld(with data: Data) {
        viewController?.loadWorld(with: data)
    }
    
    func presentReminder(with identifier: String) {
        viewController?.reloadReminder(with: identifier)
    }
    
}
