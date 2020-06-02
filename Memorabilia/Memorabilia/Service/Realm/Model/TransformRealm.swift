//
//  TransformRealm.swift
//  Memorabilia
//
//  Created by André Mello Alves on 01/06/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import Foundation
import RealmSwift

class TransformRealm: Object {
    
    // MARK: Properties
    
    @objc dynamic var uid: String = ""
    
    @objc dynamic var scale: Float = 1
    
    @objc dynamic var pitch: Float = 0
    
    @objc dynamic var yaw: Float = 0
    
    @objc dynamic var roll: Float = 0
    
    // MARK: Initializers
    
    convenience init(id: String, scale: Float, pitch: Float, yaw: Float, roll: Float) {
        self.init()
        self.uid = id
        self.scale = scale
        self.pitch = pitch
        self.yaw = yaw
        self.roll = roll
    }
    
    // MARK: Realm
    
    override static func primaryKey() -> String? {
        return "uid"
    }
    
}

