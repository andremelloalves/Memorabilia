//
//  App.swift
//  Memorabilia
//
//  Created by André Mello Alves on 08/10/19.
//  Copyright © 2019 André Mello Alves. All rights reserved.
//

import Foundation

class App {
    
    // MARK: Properties
    
    static let session = App()
    
    var db: Database = Database.db
    
    var preferences: Preferences?
    
    // MARK: Initializers
    
    private init() {}
    
    // MARK: Configuration
    
    static func configure() {
        Database.configure()
    }
    
    // MARK: Session
    
    func start() {
        
    }
    
    func finish() {
        
    }
    
    // MARK: Functions
    
    // Create
    
    // Read
    
    // Update
    
    // Delete
    
    // MARK: Preferences
    
    struct Preferences: Codable {
        
        var dictionary: [String:Any] {
            guard let data = try? JSONEncoder().encode(self) else { return [:] }
            if let dictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
                return dictionary
            } else {
                return [:]
            }
        }
        
        init() {}
        
        init(dictionary: [String:Any]) {
            if let preferences = try? JSONDecoder().decode(Preferences.self, from: JSONSerialization.data(withJSONObject: dictionary)) {
                self = preferences
            } else {
                self = Preferences()
            }
        }
        
    }
    
}
