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
            case color
            case background
            case about
            case flag
        }
        
        struct ColorSection: SettingsSection {
            
            var uid: String {
                type.rawValue
            }
            
            var type: SectionType {
                .about
            }
            
            var title: String?
            
            var colors: [ColorItem]
            
            var items: [ItemWrapper] {
                colors.map({ ItemWrapper(uid: $0.uid, item: $0) })
            }
        
        }
        
        struct BackgroundSection: SettingsSection {
            
            var uid: String {
                type.rawValue
            }
            
            var type: SectionType {
                .about
            }
            
            var title: String?
            
            var backgrounds: [BackgroundItem]
            
            var items: [ItemWrapper] {
                backgrounds.map({ ItemWrapper(uid: $0.uid, item: $0) })
            }
        
        }
        
        struct AboutSection: SettingsSection {
            
            var uid: String {
                type.rawValue
            }
            
            var type: SectionType {
                .about
            }
            
            var title: String?
            
            var messages: [MessageItem]
            
            var items: [ItemWrapper] {
                messages.map({ ItemWrapper(uid: $0.uid, item: $0) })
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
            case background
            case color
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
        
        struct ColorItem: SettingsItem {
            
            var uid: String {
                return type.rawValue + color.rawValue + selected.description
            }
            
            var type: ItemType {
                .color
            }
            
            var color: Color
            
            var selected: Bool
            
        }
        
        struct BackgroundItem: SettingsItem {
            
            var uid: String {
                return type.rawValue + action
            }
            
            var type: ItemType {
                .background
            }
            
            var action: String
            
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
