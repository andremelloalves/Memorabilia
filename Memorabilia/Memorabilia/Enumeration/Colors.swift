//
//  Colors.swift
//  Memorabilia
//
//  Created by André Mello Alves on 06/06/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import UIKit

enum Color: String, Codable, CaseIterable {
    
    // MARK: Cases
    
    case white
    case black
    
    // MARK: Properties
    
    var uiColor: UIColor {
        switch self {
        case .white:
            return .white
        case .black:
            return .black
        }
    }
    
    var name: String {
        switch self {
        case .white:
            return "Branco"
        case .black:
            return "Preto"
        }
    }
    
    // MARK: Functions
    
}
