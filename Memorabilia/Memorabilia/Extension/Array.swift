//
//  Array.swift
//  Memorabilia
//
//  Created by André Mello Alves on 08/04/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import Foundation

extension Array where Element: Hashable {
   
    func filterDuplicates() -> Array<Element> {
        var set = Set<Element>()
        var filteredArray = Array<Element>()
        for item in self {
            if set.insert(item).inserted {
                filteredArray.append(item)
            }
        }
        return filteredArray
    }
    
}

extension Array where Element: Equatable {
    
    mutating func remove(object: Element) {
        guard let index = firstIndex(of: object) else { return }
        remove(at: index)
    }
    
}
