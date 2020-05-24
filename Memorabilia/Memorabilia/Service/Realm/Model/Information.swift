//
//  Information.swift
//  Memorabilia
//
//  Created by André Mello Alves on 24/05/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import Foundation
import RealmSwift

class Information: Object {
    
    // MARK: Properties
    
    @objc dynamic var uid: String = ""
    
    // MARK: Initializers
    
    convenience init(name: String) {
        self.init()
        self.uid = UUID().uuidString
    }
    
    // MARK: Realm
    
    override static func primaryKey() -> String? {
        return "uid"
    }
    
}
