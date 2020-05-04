//
//  Comparable.swift
//  Memorabilia
//
//  Created by André Mello Alves on 03/05/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import Foundation

func signedMax<T>(_ x: T, _ y: T) -> T where T : Comparable & SignedNumeric {
    let xAbs = abs(x)
    let yAbs = abs(y)
    
    if xAbs > yAbs {
        return x
    } else {
        return y
    }
}
