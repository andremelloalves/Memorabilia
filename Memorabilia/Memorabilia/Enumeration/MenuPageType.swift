//
//  MenuPageType.swift
//  Memorabilia
//
//  Created by André Mello Alves on 06/04/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import Foundation

enum MenuPageType: String {
    
    case create
    case memories
    case settings
    
    var symbol: String {
        switch self {
        case .create:
            return "plus"
        case .memories:
            return "square.stack.3d.down.right.fill"
        case .settings:
            return "ellipsis"
        }
    }
    
    var name: String {
        switch self {
        case .create:
            return "Criar"
        case .memories:
            return "Memórias"
        case .settings:
            return "Ajustes"
        }
    }
    
}
