//
//  InformationInteractor.swift
//  Memorabilia
//
//  Created by André Mello Alves on 24/05/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import Foundation

protocol InformationInteractorInput {
    
    // Create

    // Read

    // Update

    // Delete
    
}

protocol InformationInteractorData {
    
    // Data
    
    var db: Database? { get set }
    
}

class InformationInteractor: InformationInteractorInput, InformationInteractorData {
    
    // MARK: Clean Properties
    
    var presenter: InformationPresenterInput?
    
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


extension InformationInteractor: DatabaseObserver {
    
    func notify() {

    }
    
}
