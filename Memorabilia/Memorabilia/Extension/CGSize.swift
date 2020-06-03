//
//  CGSize.swift
//  Memorabilia
//
//  Created by André Mello Alves on 03/05/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import UIKit

extension CGSize {
    
    static func +(left: CGSize, right: CGSize) -> CGSize {
        return CGSize(width: left.width + right.width, height: left.height + right.height)
    }
    
    static func -(left: CGSize, right: CGSize) -> CGSize {
        return CGSize(width: left.width - right.width, height: left.height - right.height)
    }
    
    var aspectRatio: CGFloat {
        width / height
    }
    
}
