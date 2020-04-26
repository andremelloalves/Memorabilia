//
//  ReminderAnchor.swift
//  Memorabilia
//
//  Created by André Mello Alves on 23/04/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import ARKit

class ReminderAnchor: ARAnchor {
    
    // MARK: Properties
    
    var uid: String
    
    var type: ReminderType
    
    var fileName: String?
    
    override var name: String {
        type.rawValue
    }
    
    // MARK: Initializers
    
    init(type: ReminderType, transform: simd_float4x4) {
        self.uid = UUID().uuidString
        self.type = type
        super.init(name: type.name, transform: transform)
    }
    
    required init(anchor: ARAnchor) {
        let new = anchor as! ReminderAnchor
        
        self.uid = new.uid
        self.type = new.type
        self.fileName = new.fileName
        
        super.init(anchor: anchor)
    }
    
    required init?(coder aDecoder: NSCoder) {
        guard let uid = aDecoder.decodeObject(forKey: "uid") as? String else { return nil }
        guard let value = aDecoder.decodeObject(forKey: "type") as? String else { return nil }
        guard let type = ReminderType(rawValue: value) else { return nil }
        let fileName = aDecoder.decodeObject(forKey: "fileName") as? String
        
        self.uid = uid
        self.type = type
        self.fileName = fileName
        
        super.init(coder: aDecoder)
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(uid, forKey: "uid")
        aCoder.encode(type.rawValue, forKey: "type")
        aCoder.encode(fileName, forKey: "fileName")
    }
    
    override class var supportsSecureCoding: Bool {
        true
    }
    
}
