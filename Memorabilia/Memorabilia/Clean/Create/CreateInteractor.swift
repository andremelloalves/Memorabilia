//
//  CreateInteractor.swift
//  Memorabilia
//
//  Created by André Mello Alves on 29/03/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import Foundation

protocol CreateInteractorInput {
    
//    // Create
//
//    func finishCreate()
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

protocol CreateInteractorData {
    
    // Data
    
    var db: Database? { get set }
    
//    var group: GroupRealm? { get set }
//
//    var list: RelistRealm? { get }
//
//    var items: [ItemRealm]? { get }
    
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


extension CreateInteractor: DatabaseObserver {
    
    func notify() {
        
    }
    
}
