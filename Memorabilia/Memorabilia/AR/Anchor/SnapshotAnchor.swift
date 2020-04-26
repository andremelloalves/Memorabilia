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
    
    let photo: Data
    
    // MARK: Initializers
    
    convenience init?(from view: ARSCNView) {
        guard let frame = view.session.currentFrame else { return nil }
        
        let photo = CIImage(cvPixelBuffer: frame.capturedImage)
        let orientation = CGImagePropertyOrientation(cameraOrientation: UIDevice.current.orientation)
        let context = CIContext(options: [.useSoftwareRenderer: false])
        
        guard let data = context.jpegRepresentation(of: photo.oriented(orientation),
                                                    colorSpace: CGColorSpaceCreateDeviceRGB(),
                                                    options: [kCGImageDestinationLossyCompressionQuality
                                                        as CIImageRepresentationOption: 0.7]) else { return nil }
        
        self.init(photo: data, transform: frame.camera.transform)
    }
    
    init(photo: Data, transform: float4x4) {
        self.photo = photo
        super.init(name: "snapshot", transform: transform)
    }
    
    required init(anchor: ARAnchor) {
        let snapshot = anchor as! SnapshotAnchor
        
        self.photo = snapshot.photo
        
        super.init(anchor: anchor)
    }
    
    required init?(coder aDecoder: NSCoder) {
        guard let snapshot = aDecoder.decodeObject(forKey: "snapshot") as? Data else { return nil }
        
        self.photo = snapshot
        
        super.init(coder: aDecoder)
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(photo, forKey: "snapshot")
    }
    
    override class var supportsSecureCoding: Bool {
        true
    }
    
}
