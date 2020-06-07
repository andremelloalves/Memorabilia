//
//  Preference.swift
//  Memorabilia
//
//  Created by André Mello Alves on 06/06/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import Foundation

class Preference: Codable {
    
    var color: Color
    
    var dictionary: [String:Any] {
        guard let data = try? JSONEncoder().encode(self) else { return [:] }
        if let dictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
            return dictionary
        } else {
            return [:]
        }
    }
    
    init(color: Color) {
        self.color = color
    }
    
    init(dictionary: [String:Any]) throws {
        let preference = try JSONDecoder().decode(Preference.self, from: JSONSerialization.data(withJSONObject: dictionary))
        self.color = preference.color
    }
    
}
