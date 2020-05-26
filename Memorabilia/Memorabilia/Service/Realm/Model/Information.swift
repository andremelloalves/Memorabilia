//
//  Information.swift
//  Memorabilia
//
//  Created by André Mello Alves on 24/05/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import Foundation

struct Information: Decodable {
    
    var uid: String
    
    var type: InformationType
    
    var title: String
    
    var message: String
    
    var imageName: String
    
}
