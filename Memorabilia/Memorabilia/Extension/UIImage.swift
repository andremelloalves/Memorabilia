//
//  UIImage.swift
//  Memorabilia
//
//  Created by André Mello Alves on 26/04/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import UIKit

extension UIImage {
    
    var orientedImage: UIImage {
        UIGraphicsBeginImageContext(size)
        draw(at: .zero)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? self
    }
    
}

extension UIImage.Orientation {
    
    init(cg: CGImagePropertyOrientation) {
        switch cg {
        case .up:self = .up
        case .upMirrored:self = .upMirrored
        case .down:self = .down
        case .downMirrored:self = .downMirrored
        case .left:self = .left
        case .leftMirrored:self = .leftMirrored
        case .right:self = .right
        case .rightMirrored:
            self = .rightMirrored
        }
    }
    
}

extension CGImagePropertyOrientation {
    
    init(ui: UIImage.Orientation) {
        switch ui {
        case .up: self = .up
        case .upMirrored: self = .upMirrored
        case .down: self = .down
        case .downMirrored: self = .downMirrored
        case .left: self = .left
        case .leftMirrored: self = .leftMirrored
        case .right: self = .right
        case .rightMirrored: self = .rightMirrored
        @unknown default:
            fatalError()
        }
    }
    
    init(device: UIDeviceOrientation) {
        switch device {
        case .portrait:
            self = .right
        case .portraitUpsideDown:
            self = .left
        case .landscapeLeft:
            self = .up
        case .landscapeRight:
            self = .down
        default:
            self = .right
        }
    }
    
}
