//
//  AVAssetTrack.swift
//  Memorabilia
//
//  Created by André Mello Alves on 26/04/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import AVFoundation

extension AVAssetTrack {
    
    var transformedSize: CGSize {
        naturalSize.applying(preferredTransform)
    }
    
    var preferredSize: CGSize {
        CGSize(width: abs(transformedSize.width), height: abs(transformedSize.height))
    }
    
    var orientation: Orientation {
        let isWidthPositive = transformedSize.width > 0
        let isHeightPositive = transformedSize.height > 0
        
        switch (isWidthPositive, isHeightPositive) {
            case (true, true):
                return .up
            case (true, false):
                return .left
            case (false, false):
                return .down
            case (false, true):
                return .right
        }
    }
    
    enum Orientation {
        
        case up
        case left
        case right
        case down
        
    }
    
}
