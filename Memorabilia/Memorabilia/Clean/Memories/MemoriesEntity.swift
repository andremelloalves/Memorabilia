//
//  MemoriesEntity.swift
//  Memorabilia
//
//  Created by André Mello Alves on 15/03/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import Foundation

protocol MemoriesSection {
    
    var uid: String { get }
    
    var type: MemoriesEntity.Display.SectionType { get }
    
    var items: [MemoriesEntity.Display.ItemWrapper] { get }
    
}

protocol MemoriesItem {
    
    var uid: String { get }
    
    var type: MemoriesEntity.Display.ItemType { get }
    
}

struct MemoriesEntity {
    
    struct Fetch {
        
    }
    
    struct Present {
        
        var memories: [Memory]
        
    }
    
    struct Display {
        
        // MARK: Sections
        
        enum SectionType: String {
            case memories
        }
        
        struct MemorySection: MemoriesSection {
            
            var uid: String {
                type.rawValue
            }
            
            var type: SectionType {
                .memories
            }
            
            var memories: [MemoryItem]
            
            var items: [ItemWrapper] {
                memories.map({ ItemWrapper(uid: $0.uid, item: $0) })
            }
        
        }
        
        // MARK: Items
        
        enum ItemType: String {
            case memory
        }
        
        struct ItemWrapper: Equatable {
            
            var uid: String
            
            var item: MemoriesItem
            
            static func ==(lhs: ItemWrapper, rhs: ItemWrapper) -> Bool {
                return lhs.uid == rhs.uid &&
                    lhs.item.uid == rhs.item.uid
            }
            
        }
        
        struct MemoryItem: MemoriesItem {
            
            var uid: String {
                return type.rawValue + name + date
            }
            
            var type: ItemType {
                .memory
            }
            
            var memoryID: String
            
            var name: String
            
            var date: String
            
            var photoID: String
            
        }
        
    }
    
}
