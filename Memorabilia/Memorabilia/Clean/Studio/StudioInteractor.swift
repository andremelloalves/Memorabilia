//
//  StudioInteractor.swift
//  Memorabilia
//
//  Created by André Mello Alves on 29/03/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import Foundation
import PromiseKit

protocol StudioInteractorInput {
    
    // Create

    func createMemory(with worldData: Data, photo: Data)

    // Read

    // Update

    // Delete
    
}

protocol StudioInteractorData {
    
    // Data
    
    var db: Database? { get set }
    
    var memories: [Memory]? { get set }
    
}

class StudioInteractor: StudioInteractorInput, StudioInteractorData {
    
    // MARK: Clean Properties
    
    var presenter: StudioPresenterInput?
    
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
    
    var memories: [Memory]?
    
    // MARK: Initializers
    
    init() {}
    
    deinit {
        db?.stopNotifications(observer: self)
    }
    
    // MARK: Functions
    
    // Create
    
    func createMemory(with worldData: Data, photo: Data) {
        guard let db = db else { return }
        
        firstly {
            db.createMemory(with: worldData, photo: photo)
        }.done { _ in
            print("World created successfully!")
        }.catch { error in
            print(error.localizedDescription)
        }
    }
    
    // Read
    
    // Update
    
    // Delete
    
}


extension StudioInteractor: DatabaseObserver {
    
    func notify() {
        
    }
    
}
