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
        
//        var names: [Information]
        
    }
    
    struct Display {
        
        // MARK: Sections
        
        enum SectionType: String {
            case names
        }
        
        struct Section: InformationSection {
            
            var uid: String {
                type.rawValue
            }
            
            var type: SectionType {
                .names
            }
            
            var names: [InformationItem]
            
            var items: [ItemWrapper] {
                names.map({ ItemWrapper(uid: $0.uid, item: $0) })
            }
        
        }
        
        // MARK: Items
        
        enum ItemType: String {
            case name
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
                .name
            }
            
        }
        
    }
    
}
