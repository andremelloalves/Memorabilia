//
//  CGPoint.swift
//  Memorabilia
//
//  Created by André Mello Alves on 04/04/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import UIKit

infix operator <-> : AdditionPrecedence

extension CGPoint {
    
    static func <->(left: CGPoint, right: CGPoint) -> CGFloat {
        let x = left.x - right.x
        let y = left.y - right.y
        return sqrt(pow(x, 2) + pow(y, 2))
    }
    
}
