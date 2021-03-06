//
//  UserDefaultsDatabase.swift
//  Memorabilia
//
//  Created by André Mello Alves on 10/10/19.
//  Copyright © 2019 André Mello Alves. All rights reserved.
//

import Foundation

class UserDefaultsDatabase {
    
    // MARK: Properties
    
    static let db = UserDefaultsDatabase()
    
    private var defaults: UserDefaults = UserDefaults.standard
    
    // MARK: Initializers
    
    private init() {}
    
    // MARK: Create
    
    func createUpdate(object: Any, for key: Keys) {
        defaults.set(object, forKey: key.code)
    }
    
    // MARK: Read
    
    func readDictionary(for key: Keys) -> [String:Any]? {
        return defaults.dictionary(forKey: key.code)
    }
    
    func readObject(for key: Keys) -> Any? {
        return defaults.object(forKey: key.code)
    }
    
    // MARK: Update
    
    // MARK: Delete
    
    func delete(for key: String) {
        defaults.removeObject(forKey: key)
    }
    
    // MARK: Keys
    
    enum Keys {
        
        case id
        case preferences
        
        var code: String {
            switch self {
            case .id:
                return "memorabilia-user-id"
            case .preferences:
                return "memorabilia-user-preferences"
            }
        }
        
    }
    
}
