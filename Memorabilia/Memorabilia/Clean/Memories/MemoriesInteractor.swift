//
//  MemoriesInteractor.swift
//  Memorabilia
//
//  Created by André Mello Alves on 15/03/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import Foundation

protocol MemoriesInteractorInput {
    
//    // Create
//
//    func finishMemories()
//
//    // Read
//
//    func readGroupName()
//
//    func readListItems(by sorting: ListSorting, changes: Bool)
//
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
//
//    var list: RelistRealm? { get }
//
//    var items: [ItemRealm]? { get }
    
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
//
//    var items: [ItemRealm]?
//
//    private var sorting: ListSorting?
    
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


extension MemoriesInteractor: DatabaseObserver {
    
    func notify() {
        
    }
    
}
