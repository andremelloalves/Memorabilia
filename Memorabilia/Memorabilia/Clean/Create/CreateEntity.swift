//
//  CreateEntity.swift
//  Memorabilia
//
//  Created by André Mello Alves on 08/04/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import Foundation

protocol CreateSection {
    
    var uid: String { get }
    
    var type: CreateEntity.Display.SectionType { get }
    
    var title: String? { get }
    
    var items: [CreateEntity.Display.ItemWrapper] { get }
    
}

protocol CreateItem {
    
    var uid: String { get }
    
    var type: CreateEntity.Display.ItemType { get }
    
}

struct CreateEntity {
    
    struct Fetch {
        
    }
    
    struct Present {
        
    }
    
    struct Display {
        
        // MARK: Sections
        
        enum SectionType: String {
            case name
            case cover
        }
        
        struct NameSection: CreateSection {
            
            var uid: String {
                type.rawValue + (title ?? "?")
            }
            
            var type: SectionType {
                .name
            }
            
            var title: String?
            
            var names: [CreateItem]
            
            var items: [ItemWrapper] {
                names.map({ ItemWrapper(uid: $0.uid, item: $0) })
            }
        
        }
        
        struct CoverSection: CreateSection {
            
            var uid: String {
                type.rawValue
            }
            
            var type: SectionType {
                .cover
            }
            
            var title: String?
            
            var covers: [CreateItem]
            
            var items: [ItemWrapper] {
                covers.map({ ItemWrapper(uid: $0.uid, item: $0) })
            }
        
        }
        
        // MARK: Items
        
        enum ItemType: String {
            case name
            case cover
            case spacing
            case studio
        }
        
        struct ItemWrapper: Equatable {
            
            var uid: String
            
            var item: CreateItem
            
            static func ==(lhs: ItemWrapper, rhs: ItemWrapper) -> Bool {
                return lhs.uid == rhs.uid &&
                    lhs.item.uid == rhs.item.uid
            }
            
        }
        
        struct NameItem: CreateItem {
            
            var uid: String {
                return type.rawValue
            }
            
            var type: ItemType {
                .name
            }
            
        }
        
        struct CoverItem: CreateItem {
            
            var uid: String {
                return type.rawValue
            }
            
            var type: ItemType {
                .cover
            }
            
        }
        
        struct SpacingItem: CreateItem {
            
            var uid: String {
                return type.rawValue
            }
            
            var type: ItemType {
                .spacing
            }
            
        }
        
        struct StudioItem: CreateItem {
            
            var uid: String {
                return type.rawValue
            }
            
            var type: ItemType {
                .studio
            }
            
        }
        
    }
    
}
