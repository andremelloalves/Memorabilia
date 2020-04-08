//
//  CreateInteractor.swift
//  Memorabilia
//
//  Created by André Mello Alves on 08/04/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import Foundation

protocol CreateInteractorInput {
    
    // Create

    // Read

    // Update

    // Delete
    
}

protocol CreateInteractorData {
    
    // Data
    
    var db: Database? { get set }
    
}

class CreateInteractor: CreateInteractorInput, CreateInteractorData {
    
    // MARK: Clean Properties
    
    var presenter: CreatePresenterInput?
    
    // MARK: Properties
    
    var uid: String = UUID().uuidString
    
    var db: Database? {
        willSet {
            db?.stopNotifications(observer: self)
        }
        didSet {
            db?.startNotifications(observer: self)
        }
    }
    
    // MARK: Initializers
    
    init() {}
    
    deinit {
        db?.stopNotifications(observer: self)
    }
    
    // MARK: Functions
    
    // Create
    
    // Read
    
    // Update
    
    // Delete
    
}


extension CreateInteractor: DatabaseObserver {
    
    func notify() {

    }
    
}

