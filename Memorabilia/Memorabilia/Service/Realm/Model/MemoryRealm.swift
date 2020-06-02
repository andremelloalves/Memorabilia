//
//  Memory.swift
//  Memorabilia
//
//  Created by André Mello Alves on 04/04/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import Foundation
import RealmSwift

class MemoryRealm: Object {
    
    // MARK: Properties
    
    @objc dynamic var uid: String = ""
    
    @objc dynamic var name: String = ""
    
    @objc dynamic var creationDate: Date = Date()
    
    let transforms: List<TransformRealm> = List<TransformRealm>()
    
    // MARK: Initializers
    
    convenience init(name: String, transforms: [TransformRealm]) {
        self.init()
        self.uid = UUID().uuidString
        self.name = name
        self.creationDate = Date()
        self.transforms.append(objectsIn: transforms)
    }
    
    // MARK: Realm
    
    override static func primaryKey() -> String? {
        return "uid"
    }
    
}

