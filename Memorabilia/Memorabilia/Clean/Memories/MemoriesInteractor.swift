//
//  MemoriesInteractor.swift
//  Memorabilia
//
//  Created by André Mello Alves on 15/03/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import Foundation
import PromiseKit

protocol MemoriesInteractorInput {
    
    // Create

    // Read
    
    func readMemoryPhoto(id: String, index: IndexPath)

    func readMemories()

    // Update

    // Delete
    
}

protocol MemoriesInteractorData {
    
    // Data
    
    var db: Database? { get set }

    var memories: [Memory]? { get }
    
}

class MemoriesInteractor: MemoriesInteractorInput, MemoriesInteractorData {
    
    // MARK: Clean Properties
    
    var presenter: MemoriesPresenterInput?
    
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
    
    // Read
    
    func readMemoryPhoto(id: String, index: IndexPath) {
        guard let db = db else { return }
        
        firstly {
            db.readMemoryPhoto(id: id)
        }.done(on: .global(qos: .userInitiated)) { photo in
            self.presenter?.presentMemoryPhoto(photo, with: id, for: index)
        }.catch { error in
            print(error)
        }
    }
    
    func readMemories() {
        guard let db = db else { return }
        
        firstly {
            db.readMemories()
        }.map {
            $0.map { MemoriesEntity.Present(uid: $0.uid, name: $0.name, creationDate: $0.creationDate) }
        }.done(on: .global(qos: .userInitiated)) { memories in
            self.presenter?.presentMemories(memories: memories)
        }.catch { error in
            print(error.localizedDescription)
        }
    }
    
    private func readMemoriesUpdate() {
        guard let db = db else { return }
        
        firstly {
            db.readMemories()
        }.map {
            $0.map { MemoriesEntity.Present(uid: $0.uid, name: $0.name, creationDate: $0.creationDate) }
        }.done(on: .global(qos: .userInitiated)) { memories in
            self.presenter?.presentMemories(memories: memories)
        }.catch { error in
            print(error.localizedDescription)
        }
    }
    
    // Update
    
    // Delete
    
}


extension MemoriesInteractor: DatabaseObserver {
    
    func notify() {
        readMemoriesUpdate()
    }
    
}
