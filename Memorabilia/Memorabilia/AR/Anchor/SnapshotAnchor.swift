//
//  SnapshotAnchor.swift
//  Memorabilia
//
//  Created by André Mello Alves on 27/11/19.
//  Copyright © 2019 André Mello Alves. All rights reserved.
//

import ARKit
import SceneKit

class SnapshotAnchor: ARAnchor {
    
    // MARK: Properties
    
    let image: Data
    
    // MARK: Initializers
    
    convenience init?(from view: ARSCNView) {
        guard let frame = view.session.currentFrame else { return nil }
        
        let image = CIImage(cvPixelBuffer: frame.capturedImage)
        let orientation = CGImagePropertyOrientation(cameraOrientation: UIDevice.current.orientation)
        let context = CIContext(options: [.useSoftwareRenderer: false])
        
        guard let data = context.jpegRepresentation(of: image.oriented(orientation), colorSpace: CGColorSpaceCreateDeviceRGB(), options: [kCGImageDestinationLossyCompressionQuality as CIImageRepresentationOption: 0.7]) else { return nil }
        
        self.init(image: data, transform: frame.camera.transform)
    }
    
    init(image: Data, transform: float4x4) {
        self.image = image
        super.init(name: "snapshot", transform: transform)
    }
    
    required init(anchor: ARAnchor) {
        self.image = (anchor as! SnapshotAnchor).image
        super.init(anchor: anchor)
    }
    
    required init?(coder aDecoder: NSCoder) {
        if let snapshot = aDecoder.decodeObject(forKey: "snapshot") as? Data {
            self.image = snapshot
        } else {
            return nil
        }
        
        super.init(coder: aDecoder)
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(image, forKey: "snapshot")
    }
    
    override class var supportsSecureCoding: Bool {
        true
    }
    
}
