//
//  Database.swift
//  Memorabilia
//
//  Created by André Mello Alves on 02/10/19.
//  Copyright © 2019 André Mello Alves. All rights reserved.
//

import Foundation
import RealmSwift
import PromiseKit

class Database {
    
    // MARK: Properties
    
    static let db = Database()
    
    private let realm: RealmDatabase
    
    private let defaults: UserDefaultsDatabase
    
    private let documents: DocumentsDatabase
    
    private var observers: [WeakObserver] = []
    
    let uid: String = UUID().uuidString
    
    // MARK: Observer
    
    private struct WeakObserver {
        weak var observer: DatabaseObserver?
    }
    
    // MARK: Initializers
    
    private init() {
        self.realm = RealmDatabase.db
        self.defaults = UserDefaultsDatabase.db
        self.documents = DocumentsDatabase.db
        
        // Receive Realm notifications
        realm.startNotifications(observer: self)
    }
    
    deinit {
        realm.stopNotifications(observer: self)
    }
    
    // MARK: Setup
    
    static func configure() {
        
    }
    
    // MARK: Create
    
    // MARK: Read
    
    func readMemories() -> Promise<[Memory]> {
        return Promise { seal in
            let sort = NSSortDescriptor(key: "creationDate", ascending: false)
            let results: Results<Memory> = realm.query(with: nil, sortDescriptors: [sort])
            let memories: [Memory] = Array(results)
            seal.fulfill(memories)
        }
    }
    
    // MARK: Update
    
    func update(changes: () -> ()?) {
        realm.update(changes: changes)
    }
    
    // MARK: Delete
    
    // MARK: Notification
    
    func startNotifications(observer: DatabaseObserver) {
        self.observers.append(WeakObserver(observer: observer))
    }
    
    func stopNotifications(observer: DatabaseObserver) {
        self.observers.removeAll(where: { $0.observer == nil || $0.observer?.uid == observer.uid })
    }
    
}

extension Database: RealmObserver {
    
    func notify() {
        observers.forEach({ $0.observer?.notify() })
    }
    
}
