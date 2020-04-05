//
//  CGRect.swift
//  Memorabilia
//
//  Created by André Mello Alves on 04/04/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import UIKit

extension CGRect {
    
    var center: CGPoint {
        return CGPoint(x: (maxX + minX) / 2, y: (maxY + minY) / 2)
    }
    
    static func +(rect: CGRect, point: CGPoint) -> CGRect {
        return CGRect(x: rect.origin.x + point.x, y: rect.origin.y + point.y, width: rect.width, height: rect.height)
    }
    
    static func -(rect: CGRect, point: CGPoint) -> CGRect {
        return CGRect(x: rect.origin.x - point.x, y: rect.origin.y - point.y, width: rect.width, height: rect.height)
    }
    
}
