//
//  RealmDatabase.swift
//  Memorabilia
//
//  Created by André Mello Alves on 03/10/19.
//  Copyright © 2019 André Mello Alves. All rights reserved.
//
import Foundation
import RealmSwift

class RealmDatabase {
    
    // MARK: Properties
    
    static let db = RealmDatabase()
    
    private var realm: Realm {
        let realm: Realm
        do {
            try realm = Realm()
        } catch let error {
            fatalError(error.localizedDescription)
        }
        return realm
    }
    
    private var token: NotificationToken?
    
    private var observers: [RealmObserver] = []
    
    // MARK: Initializers
    
    init() {
        token = realm.observe({ (notification, realm) in
            self.observers.forEach({ $0.notify() })
        })
    }
    
    deinit {
        token?.invalidate()
    }
    
    // MARK: Create
    
    func createUpdate<RealmObject: Object>(object: RealmObject) throws {
        try realm.write {
            realm.create(RealmObject.self, value: object, update: .modified)
        }
    }
    
    // MARK: Read
    
    func get<RealmObject: Object>(type: RealmObject.Type, with primaryKey: String) throws -> RealmObject {
        if let object = realm.object(ofType: type, forPrimaryKey: primaryKey) {
            return object
        } else {
            throw RealmError.notFound
        }
    }
    
    func query<RealmObject: Object>(with predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]) -> Results<RealmObject> {
        var results = realm.objects(RealmObject.self)
        if let predicate = predicate {
            results = results.filter(predicate)
        }
        for sort in sortDescriptors {
            results = results.sorted(byKeyPath: sort.key ?? "uid", ascending: sort.ascending)
        }
        return results
    }
    
    // MARK: Update
    
    func update(changes: () -> ()?) throws {
        try realm.write {
            changes()
        }
    }
    
    // MARK: Delete
    
    func delete<RealmObject: Object>(type: RealmObject.Type, with primaryKey: String) throws {
        let object = realm.object(ofType: type, forPrimaryKey: primaryKey)
        if let object = object {
            try realm.write {
                realm.delete(object)
            }
        } else {
            throw RealmError.notFound
        }
    }
    
    // MARK: Notification
    
    func startNotifications(observer: RealmObserver) {
        self.observers.append(observer)
    }
    
    func stopNotifications(observer: RealmObserver) {
        self.observers.removeAll(where: { $0.uid == observer.uid })
    }
    
    enum RealmError: Error {
        
        case notFound
        
        var localizedDescription: String {
            switch self {
            case .notFound:
                return "File not found."
            }
        }
    }
    
}
