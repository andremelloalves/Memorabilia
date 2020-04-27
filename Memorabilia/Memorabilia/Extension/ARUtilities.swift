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
            return "Normal"
        case .notAvailable:
            return "Not Available"
        case .limited(.initializing):
            return "Initializing"
        case .limited(.excessiveMotion):
            return "Excessive Motion"
        case .limited(.insufficientFeatures):
            return "Insufficient Features"
        case .limited(.relocalizing):
            return "Relocalizing"
        default:
            return "Default"
        }
    }
    
}

extension ARCamera.TrackingState {
    
    var localizedFeedback: String {
        switch self {
        case .normal:
            // No planes detected; provide instructions for this app's AR interactions.
            return "Move around to map the environment."
            
        case .notAvailable:
            return "Tracking unavailable."
            
        case .limited(.excessiveMotion):
            return "Move the device more slowly."
            
        case .limited(.insufficientFeatures):
            return "Point the device at an area with visible surface detail, or improve lighting conditions."
            
        case .limited(.relocalizing):
            return "Resuming session — move to where you were when the session was interrupted."
            
        case .limited(.initializing):
            return "Initializing AR session."
            
        default:
            return "Default"
        }
    }
    
}

extension ARWorldMap {
    
    var snapshotAnchor: SnapshotAnchor? {
        return anchors.compactMap { $0 as? SnapshotAnchor }.first
    }
    
}
