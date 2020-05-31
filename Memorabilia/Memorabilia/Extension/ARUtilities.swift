//
//  ARUtilities.swift
//  Memorabilia
//
//  Created by André Mello Alves on 27/11/19.
//  Copyright © 2019 André Mello Alves. All rights reserved.
//

import ARKit

extension ARFrame.WorldMappingStatus: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .notAvailable:
            return "Not Available"
        case .limited:
            return "Limited"
        case .extending:
            return "Extending"
        case .mapped:
            return "Mapped"
        default:
            return "Default"
        }
    }
    
}

extension ARCamera.TrackingState: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .normal:
            return "Personalizando"
        case .notAvailable:
            return "Indisponível"
        case .limited(.initializing):
            return "Inicializando"
        case .limited(.insufficientFeatures):
            return "Poucos detalhes"
        case .limited(.excessiveMotion):
            return "Movimento demais"
        case .limited(.relocalizing):
            return "Relocalizando"
        default:
            return "Personalizando"
        }
    }
    
    var feedback: String {
        switch self {
        case .normal:
            return "Mapeie o ambiente e adicione lembretes AR."
        case .notAvailable:
            return "Mapeamento indisponível."
        case .limited(.initializing):
            return "Sessão AR está sendo inicializada."
        case .limited(.insufficientFeatures):
            return "Aponte o dispositivo para uma área com detalhes na superfícies, ou melhore as condições de iluminação."
        case .limited(.excessiveMotion):
            return "Mova o dispositivo mais lentamente."
        case .limited(.relocalizing):
            return "Mova o dispositivo para a perspectiva da imagem."
        default:
            return "Mapeie o ambiente e adicione lembretes AR."
        }
    }
    
}

extension ARWorldMap {
    
    var snapshotAnchor: SnapshotAnchor? {
        return anchors.compactMap { $0 as? SnapshotAnchor }.first
    }
    
}
