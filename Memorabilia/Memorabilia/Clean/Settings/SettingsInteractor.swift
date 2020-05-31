//
//  SettingsInteractor.swift
//  Memorabilia
//
//  Created by André Mello Alves on 08/04/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import Foundation

protocol SettingsInteractorInput {
    
    // Create

    // Read
    
    func read()

    // Update

    // Delete
    
}

protocol SettingsInteractorData {
    
    // Data
    
    var db: Database? { get set }
    
}

class SettingsInteractor: SettingsInteractorInput, SettingsInteractorData {
    
    // MARK: Clean Properties
    
    var presenter: SettingsPresenterInput?
    
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
    
    func read() {
        presenter?.present(memories: [], shouldUpdate: false)
    }
    
    // Update
    
    // Delete
    
}


extension SettingsInteractor: DatabaseObserver {
    
    func notify() {

    }
    
}
