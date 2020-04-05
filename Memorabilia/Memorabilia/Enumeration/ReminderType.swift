//
//  ReminderType.swift
//  Memorabilia
//
//  Created by André Mello Alves on 05/04/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import Foundation

enum ReminderType: String {
    
    case text
    case photo
    case video
    case audio
    
    var symbol: String {
        switch self {
        case .text:
            return "textformat"
        case .photo:
            return "photo"
        case .video:
            return "film"
        case .audio:
            return "mic"
        }
    }
    
    var name: String {
        switch self {
        case .text:
            return "Texto"
        case .photo:
            return "Foto"
        case .video:
            return "Vídeo"
        case .audio:
            return "Áudio"
        }
    }
    
}
