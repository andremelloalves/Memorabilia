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
    
    var type: ReminderType
    
    // MARK: Initializers
    
    init(name: String? = nil, type: ReminderType, transform: simd_float4x4) {
        self.type = type
        
        if let name = name {
            super.init(name: name, transform: transform)
        } else {
            super.init(transform: transform)
        }
    }
    
    required init(anchor: ARAnchor) {
        let reminder = anchor as! ReminderAnchor
        
        self.type = reminder.type
        
        super.init(anchor: anchor)
    }
    
    required init?(coder aDecoder: NSCoder) {
        guard let value = aDecoder.decodeObject(forKey: "type") as? String else { return nil }
        guard let type = ReminderType(rawValue: value) else { return nil }
        
        self.type = type
        
        super.init(coder: aDecoder)
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(type.rawValue, forKey: "type")
    }
    
    override class var supportsSecureCoding: Bool {
        true
    }
    
}
