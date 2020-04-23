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
    
    var fileName: String?
    
    override var name: String {
        type.rawValue
    }
    
    // MARK: Initializers
    
    init(type: ReminderType, transform: simd_float4x4) {
        self.type = type
        super.init(name: type.name, transform: transform)
    }
    
    required init(anchor: ARAnchor) {
        let new = anchor as! ReminderAnchor
        
        self.type = new.type
        self.fileName = new.fileName
        
        super.init(anchor: anchor)
    }
    
    required init?(coder aDecoder: NSCoder) {
        guard let type = aDecoder.decodeObject(forKey: "type") as? ReminderType else { return nil }
        let fileName = aDecoder.decodeObject(forKey: "fileName") as? String
        
        self.type = type
        self.fileName = fileName
        
        super.init(coder: aDecoder)
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(type, forKey: "type")
        aCoder.encode(fileName, forKey: "fileName")
    }
    
    override class var supportsSecureCoding: Bool {
        true
    }
    
}
