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
    
    func createMemory(with worldMap: Data, photo: Data) -> Promise<Void> {
        let memory = Memory(name: "Memória")
        return Promise { seal in
            do {
                try realm.createUpdate(object: memory)
                try documents.create(file: memory.uid, folder: .experiences, data: worldMap)
                try documents.create(file: memory.uid, folder: .photos, data: photo)
                seal.fulfill(())
            } catch let error {
                seal.reject(error)
            }
        }
    }
    
    // MARK: Read
    
    func readMemories() -> Promise<[Memory]> {
        return Promise { seal in
            do {
                let sort = NSSortDescriptor(key: "creationDate", ascending: false)
                let results: Results<Memory> = try realm.query(with: nil, sortDescriptors: [sort])
                let memories: [Memory] = Array(results)
                seal.fulfill(memories)
            } catch let error {
                seal.reject(error)
            }
        }
    }
    
    func readMemoryPhoto(id: String) -> Promise<Data> {
        return Promise { seal in
            do {
                let photo = try documents.read(file: id, folder: .photos)
                seal.fulfill(photo)
            } catch let error {
                seal.reject(error)
            }
        }
    }
    
    func readARWorld(id: String) -> Promise<Data> {
        return Promise { seal in
            do {
                let world = try documents.read(file: id, folder: .experiences)
                seal.fulfill(world)
            } catch let error {
                seal.reject(error)
            }
        }
    }
    
    // MARK: Update
    
    func update(changes: () -> ()?) -> Promise<Void> {
        return Promise { seal in
            do {
                try realm.update(changes: changes)
                seal.fulfill(())
            } catch let error {
                seal.reject(error)
            }
        }
    }
    
    // MARK: Delete
    
    func deleteMemory(id: String) -> Promise<Void> {
        return Promise { seal in
            do {
                try realm.delete(type: Memory.self, with: id)
                try documents.delete(file: id, folder: .experiences)
                try documents.delete(file: id, folder: .photos)
                seal.fulfill(())
            } catch let error {
                seal.reject(error)
            }
        }
    }
    
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
