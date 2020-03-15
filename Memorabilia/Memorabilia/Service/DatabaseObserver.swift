//
//  DatabaseObserver.swift
//  Memorabilia
//
//  Created by André Mello Alves on 14/03/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import Foundation

protocol DatabaseObserver: class {
    
    // MARK: Properties
    
    var uid: String { get }
    
    // MARK: Functions
    
    func notify()
    
}
