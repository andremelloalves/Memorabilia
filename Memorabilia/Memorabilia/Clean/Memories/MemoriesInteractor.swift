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
    
//    // Create
//
//    func finishMemories()

    // Read
    
    func readMemoryPhoto(id: String, index: IndexPath)

    func readMemories()

//    // Update
//
//    func updateItemIsBought(by id: String)
//
//    // Delete
//
//    func deleteItem(by id: String)
//
//    func deleteItems()
    
}

protocol MemoriesInteractorData {
    
    // Data
    
    var db: Database? { get set }
    
//    var group: GroupRealm? { get set }

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
    
//    var group: GroupRealm?
//
//    var list: RelistRealm?

    var memories: [Memory]?

//    private var sorting: ListSorting?
    
    // MARK: Initializers
    
    init() {}
    
    deinit {
        db?.stopNotifications(observer: self)
    }
    
    // MARK: Functions
    
    // Create
    
    // Read
    
    func readMemories() {
        guard let db = db else { return }
        
        firstly {
            db.readMemories()
        }.done { memories in
            self.memories = memories
            let entity = MemoriesEntity.Present(memories: memories)
            self.presenter?.presentMemories(entity: entity)
        }.catch { error in
            print(error.localizedDescription)
        }
    }
    
    func readMemoryPhoto(id: String, index: IndexPath) {
        guard let db = db else { return }
        
        firstly {
            db.readMemoryPhoto(id: id)
        }.done { photo in
            self.presenter?.presentMemoryPhoto(photo, with: id, for: index)
        }.catch { error in
            print(error)
        }
    }
    
    // Update
    
    // Delete
    
}


extension MemoriesInteractor: DatabaseObserver {
    
    func notify() {
        
    }
    
}
