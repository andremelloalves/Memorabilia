//
//  SettingsInteractor.swift
//  Memorabilia
//
//  Created by André Mello Alves on 08/04/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import Foundation
import PromiseKit

protocol SettingsInteractorInput {
    
    // Create

    // Read
    
    func read()

    // Update
    
    func updatePreference(with color: Color)
    
    func updateBackground(with data: Data)

    // Delete
    
}

protocol SettingsInteractorData {
    
    // Data
    
    var db: Database? { get set }
    
    var preference: Preference? { get set }
    
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
    
    var preference: Preference?
    
    // MARK: Initializers
    
    init() {}
    
    deinit {
        db?.stopNotifications(observer: self)
    }
    
    // MARK: Functions
    
    // Create
    
    // Read
    
    func read() {
        read(shouldUpdate: false)
    }
    
    func read(shouldUpdate: Bool) {
        presenter?.present([], preference: preference, shouldUpdate: shouldUpdate)
    }
    
    // Update
    
    func updatePreference(with color: Color) {
        guard let db = db, let preference = preference else { return }
        
        preference.color = color
        
        firstly {
            db.update(preference)
        }.done {
            self.read(shouldUpdate: true)
        }.catch { error in
            print(error.localizedDescription)
        }
    }
    
    func updateBackground(with data: Data) {
        guard let db = db else { return }
        
        firstly {
            db.updateBackground(with: data)
        }.catch { error in
            print(error.localizedDescription)
        }
    }
    
    // Delete
    
}


extension SettingsInteractor: DatabaseObserver {
    
    func notify() {

    }
    
}
