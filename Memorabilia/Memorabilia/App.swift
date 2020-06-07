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
    
    var preference: Preference?
    
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
    
}
