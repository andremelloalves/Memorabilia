//
//  InformationEntity.swift
//  Memorabilia
//
//  Created by André Mello Alves on 24/05/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import Foundation

protocol InformationSection {
    
    var uid: String { get }
    
    var type: InformationEntity.Display.SectionType { get }
    
    var items: [InformationEntity.Display.ItemWrapper] { get }
    
}

protocol InformationItem {
    
    var uid: String { get }
    
    var type: InformationEntity.Display.ItemType { get }
    
}

struct InformationEntity {
    
    struct Fetch {
        
    }
    
    struct Present {
        
        var uid: String
        
    }
    
    struct Display {
        
        // MARK: Sections
        
        enum SectionType: String {
            case informations
        }
        
        struct Section: InformationSection {
            
            var uid: String {
                type.rawValue
            }
            
            var type: SectionType {
                .informations
            }
            
            var informations: [InformationItem]
            
            var items: [ItemWrapper] {
                informations.map({ ItemWrapper(uid: $0.uid, item: $0) })
            }
        
        }
        
        // MARK: Items
        
        enum ItemType: String {
            case information
        }
        
        struct ItemWrapper: Equatable {
            
            var uid: String
            
            var item: InformationItem
            
            static func ==(lhs: ItemWrapper, rhs: ItemWrapper) -> Bool {
                return lhs.uid == rhs.uid &&
                    lhs.item.uid == rhs.item.uid
            }
            
        }
        
        struct Item: InformationItem {
            
            var uid: String {
                return type.rawValue
            }
            
            var type: ItemType {
                .information
            }
            
            var title: String
            
            var message: String
            
            var imageName: String
            
        }
        
    }
    
}
