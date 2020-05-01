//
//  Collection.swift
//  Memorabilia
//
//  Created by André Mello Alves on 01/05/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import Foundation

extension Collection {
    
    subscript (optional index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
    
}
