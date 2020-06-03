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
    
    func readSnapshot(with id: String, for index: IndexPath)

    func readMemories()

    // Update

    // Delete
    
    func deleteMemory(with id: String)
    
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
    
    func readSnapshot(with id: String, for index: IndexPath) {
        guard let db = db else { return }
        
        firstly {
            db.readMemorySnapshot(with: id)
        }.done(on: .global(qos: .userInitiated)) { snapshot in
            self.presenter?.present(snapshot, with: id, for: index)
        }.catch { error in
            print(error.localizedDescription)
        }
    }
    
    func readMemories() {
        readMemories(shouldUpdate: false)
    }
    
    private func readMemories(shouldUpdate: Bool = false) {
        guard let db = db else { return }
        
        firstly {
            db.readMemories()
        }.get { memories in
            self.memories = memories
        }.map {
            $0.map { MemoriesEntity.Present(uid: $0.identifier, name: $0.name, creationDate: $0.creationDate) }
        }.done(on: .global(qos: .userInitiated)) { memories in
            self.presenter?.present(memories, shouldUpdate: shouldUpdate)
        }.catch { error in
            print(error.localizedDescription)
        }
    }
    
    // Update
    
    // Delete
    
    func deleteMemory(with id: String) {
        guard let db = db else { return }
        
        firstly {
            db.deleteMemory(with: id)
        }.done {
            self.readMemories(shouldUpdate: true)
        }.catch { error in
            print(error.localizedDescription)
        }
    }
    
}


extension MemoriesInteractor: DatabaseObserver {
    
    func notify() {
        
    }
    
}
