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
    
    private var realm: Realm? {
        do {
            return try Realm()
        } catch {
            return nil
        }
    }
    
    private var token: NotificationToken?
    
    private var observers: [RealmObserver] = []
    
    // MARK: Initializers
    
    init() {
        token = realm?.observe({ (notification, realm) in
            self.observers.forEach({ $0.notify() })
        })
    }
    
    deinit {
        token?.invalidate()
    }
    
    // MARK: Create
    
    func createUpdate<RealmObject: Object>(object: RealmObject) throws {
        guard let realm = realm else { throw RealmError.realm }
        try realm.write {
            realm.create(RealmObject.self, value: object, update: .modified)
        }
    }
    
    // MARK: Read
    
    func get<RealmObject: Object>(type: RealmObject.Type, with primaryKey: String) throws -> RealmObject {
        guard let realm = realm else { throw RealmError.realm }
        if let object = realm.object(ofType: type, forPrimaryKey: primaryKey) {
            return object
        } else {
            throw RealmError.notFound
        }
    }
    
    func query<RealmObject: Object>(with predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]) throws -> Results<RealmObject> {
        guard let realm = realm else { throw RealmError.realm }
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
        guard let realm = realm else { throw RealmError.realm }
        try realm.write {
            changes()
        }
    }
    
    // MARK: Delete
    
    func delete<RealmObject: Object>(type: RealmObject.Type, with primaryKey: String) throws {
        guard let realm = realm else { throw RealmError.realm }
        if let object = realm.object(ofType: type, forPrimaryKey: primaryKey) {
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
    
    // MARK: Error
    
    enum RealmError: Error {
        
        case realm
        case notFound
        
        var localizedDescription: String {
            switch self {
            case .realm:
                return "Realm failure."
            case .notFound:
                return "File not found."
            }
        }
    }
    
}
