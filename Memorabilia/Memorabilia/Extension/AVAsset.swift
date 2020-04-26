//
//  AVAsset.swift
//  Memorabilia
//
//  Created by André Mello Alves on 26/04/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import AVFoundation

extension AVAsset {
    
    var pointSize: CGSize? {
        guard let track = tracks(withMediaType: .video).first else { return nil }
        let size = track.naturalSize.applying(track.preferredTransform)
        return CGSize(width: abs(size.width), height: abs(size.height))
    }
    
    var aspectRatio: CGFloat? {
        guard let size = pointSize else { return nil }
        return size.height / size.width
    }
    
}
