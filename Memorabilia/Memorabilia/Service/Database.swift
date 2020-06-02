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
    
    func createMemory(name: String, world: Data, snapshot: Data, cover: Data, transforms: [Transform]) -> Promise<Void> {
        let transforms = transforms.map({ TransformRealm(id: $0.identifier,
                                                         scale: $0.scale, pitch: $0.pitch,
                                                         yaw: $0.yaw,
                                                         roll: $0.roll) })
        let memory = MemoryRealm(name: name, transforms: transforms)
        return Promise { seal in
            do {
                try realm.createUpdate(object: memory)
                try documents.create(file: memory.uid, folder: .experiences, data: world)
                try documents.create(file: memory.uid, folder: .snapshots, data: snapshot)
                try documents.create(file: memory.uid, folder: .photos, data: cover)
                seal.fulfill(())
            } catch let error {
                seal.reject(error)
            }
        }
    }
    
    // MARK: Read
    
    func readInformations(type: InformationType) -> Promise<[Information]> {
        return Promise { seal in
            do {
                let url = Bundle.main.url(forResource: "InformationData", withExtension: "jscsrc")!
                let data = try Data(contentsOf: url)
                let informations = try JSONDecoder().decode([Information].self, from: data)
                seal.fulfill(informations.filter({ $0.type == type }))
            } catch let error {
                seal.reject(error)
            }
        }
    }
    
    func readMemories() -> Promise<[Memory]> {
        return Promise { seal in
            do {
                let sort = NSSortDescriptor(key: "creationDate", ascending: false)
                let results: Results<MemoryRealm> = try realm.query(with: nil, sortDescriptors: [sort])
                let memories: [Memory] = Array(results.map({ Memory(identifier: $0.uid, name: $0.name, creationDate: $0.creationDate) }))
                seal.fulfill(memories)
            } catch let error {
                seal.reject(error)
            }
        }
    }
    
    func readMemorySnapshot(id: String) -> Promise<Data> {
        return Promise { seal in
            do {
                let snapshot = try documents.read(file: id, folder: .snapshots)
                seal.fulfill(snapshot)
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
    
    func readMemoryTransforms(id: String) -> Promise<[Transform]> {
        return Promise { seal in
            do {
                let memory = try realm.get(type: MemoryRealm.self, with: id)
                let results = memory.transforms.map({ Transform(identifier: $0.uid,
                                                                scale: $0.scale,
                                                                pitch: $0.pitch,
                                                                yaw: $0.yaw,
                                                                roll: $0.roll) })
                let transforms = Array(results)
                seal.fulfill(transforms)
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
                try realm.delete(type: MemoryRealm.self, with: id)
                try documents.delete(file: id, folder: .experiences)
                try documents.delete(file: id, folder: .snapshots)
                try documents.delete(file: id, folder: .photos)
                seal.fulfill(())
            } catch let error {
                seal.reject(error)
            }
        }
    }
    
    func deleteMemoryTransforms(id: String) -> Promise<Void> {
        return Promise { seal in
            do {
                let memory = try realm.get(type: MemoryRealm.self, with: id)
                try memory.transforms.forEach({ try realm.delete(type: TransformRealm.self, with: $0.uid) })
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
