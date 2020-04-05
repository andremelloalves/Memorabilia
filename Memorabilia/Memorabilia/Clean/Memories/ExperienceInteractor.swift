//
//  ExperienceInteractor.swift
//  Memorabilia
//
//  Created by André Mello Alves on 15/03/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import Foundation
import PromiseKit

protocol ExperienceInteractorInput {
    
    // Create

    // Read
    
    func readMemoryPhoto()
    
    func readARWorld()

    // Update

    // Delete
    
}

protocol ExperienceInteractorData {
    
    // Data
    
    var db: Database? { get set }
    
    var memory: Memory? { get set }
    
    var world: Data? { get }
    
}

class ExperienceInteractor: ExperienceInteractorInput, ExperienceInteractorData {
    
    // MARK: Clean Properties
    
    var presenter: ExperiencePresenterInput?
    
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
    
    var memory: Memory?
    
    var world: Data?
    
    // MARK: Initializers
    
    init() {}
    
    deinit {
        db?.stopNotifications(observer: self)
    }
    
    // MARK: Functions
    
    // Create
    
    // Read
    
    func readMemoryPhoto() {
        guard let db = db else { return }
        guard let memory = memory else { return }
        
        firstly {
            db.readMemoryPhoto(id: memory.uid)
        }.done { photo in
            self.presenter?.presentMemoryPhoto(photo)
        }.catch { error in
            print(error)
        }
    }
    
    func readARWorld() {
        guard let db = db else { return }
        guard let memory = memory else { return }
        
        firstly {
            db.readARWorld(id: memory.uid)
        }.done { world in
            self.world = world
            self.presenter?.presentARWorld(world)
        }.catch { error in
            print(error.localizedDescription)
        }
    }
    
    // Update
    
    // Delete
    
}


extension ExperienceInteractor: DatabaseObserver {
    
    func notify() {
        
    }
    
}
