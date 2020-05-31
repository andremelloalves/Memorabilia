//
//  SettingsEntity.swift
//  Memorabilia
//
//  Created by André Mello Alves on 08/04/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import Foundation

protocol SettingsSection {
    
    var uid: String { get }
    
    var type: SettingsEntity.Display.SectionType { get }
    
    var title: String? { get }
    
    var items: [SettingsEntity.Display.ItemWrapper] { get }
    
}

protocol SettingsItem {
    
    var uid: String { get }
    
    var type: SettingsEntity.Display.ItemType { get }
    
}

struct SettingsEntity {
    
    struct Fetch {
        
    }
    
    struct Present {
        
    }
    
    struct Display {
        
        // MARK: Sections
        
        enum SectionType: String {
            case about
            case flag
        }
        
        struct AboutSection: SettingsSection {
            
            var uid: String {
                type.rawValue
            }
            
            var type: SectionType {
                .about
            }
            
            var title: String?
            
            var settings: [MessageItem]
            
            var items: [ItemWrapper] {
                settings.map({ ItemWrapper(uid: $0.uid, item: $0) })
            }
        
        }
        
        struct FlagSection: SettingsSection {
            
            var uid: String {
                type.rawValue
            }
            
            var type: SectionType {
                .flag
            }
            
            var title: String?
            
            var flags: [FlagItem]
            
            var items: [ItemWrapper] {
                flags.map({ ItemWrapper(uid: $0.uid, item: $0) })
            }
        
        }
        
        // MARK: Items
        
        enum ItemType: String {
            case message
            case flag
        }
        
        struct ItemWrapper: Equatable {
            
            var uid: String
            
            var item: SettingsItem
            
            static func ==(lhs: ItemWrapper, rhs: ItemWrapper) -> Bool {
                return lhs.uid == rhs.uid &&
                    lhs.item.uid == rhs.item.uid
            }
            
        }
        
        struct MessageItem: SettingsItem {
            
            var uid: String {
                return type.rawValue + message
            }
            
            var type: ItemType {
                .message
            }
            
            var message: String
            
        }
        
        struct FlagItem: SettingsItem {
            
            var uid: String {
                return type.rawValue + flag
            }
            
            var type: ItemType {
                .flag
            }
            
            var flag: String
            
        }
        
    }
    
}
