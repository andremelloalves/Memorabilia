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
    case blue
    case green
    case indigo
    case orange
    case pink
    case purple
    case red
    case teal
    case yellow
    case black
    
    // MARK: Properties
    
    var uiColor: UIColor {
        switch self {
        case .white:
            return .white
        case .blue:
            return .systemBlue
        case .green:
            return .systemGreen
        case .indigo:
            return .systemIndigo
        case .orange:
            return .systemOrange
        case .pink:
            return .systemPink
        case .purple:
            return .systemPurple
        case .red:
            return .systemRed
        case .teal:
            return .systemTeal
        case .yellow:
            return .systemYellow
        case .black:
            return .black
        }
    }
    
    var name: String {
        switch self {
        case .white:
            return "Branco"
        case .blue:
            return "Azul"
        case .green:
            return "Verde"
        case .indigo:
            return "Roxo"
        case .orange:
            return "Laranja"
        case .pink:
            return "Rosa"
        case .purple:
            return "Violeta"
        case .red:
            return "Vermelho"
        case .teal:
            return "Azul-claro"
        case .yellow:
            return "Amarelo"
        case .black:
            return "Preto"
        }
    }
    
    // MARK: Functions
    
}
