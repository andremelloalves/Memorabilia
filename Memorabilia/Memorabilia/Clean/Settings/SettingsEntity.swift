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
        
//        var settings: [Setting]
        
    }
    
    struct Display {
        
        // MARK: Sections
        
        enum SectionType: String {
            case settings
        }
        
        struct SettingSection: SettingsSection {
            
            var uid: String {
                type.rawValue
            }
            
            var type: SectionType {
                .settings
            }
            
            var settings: [SettingItem]
            
            var items: [ItemWrapper] {
                settings.map({ ItemWrapper(uid: $0.uid, item: $0) })
            }
        
        }
        
        // MARK: Items
        
        enum ItemType: String {
            case setting
        }
        
        struct ItemWrapper: Equatable {
            
            var uid: String
            
            var item: SettingsItem
            
            static func ==(lhs: ItemWrapper, rhs: ItemWrapper) -> Bool {
                return lhs.uid == rhs.uid &&
                    lhs.item.uid == rhs.item.uid
            }
            
        }
        
        struct SettingItem: SettingsItem {
            
            var uid: String {
                return type.rawValue
            }
            
            var type: ItemType {
                .setting
            }
            
        }
        
    }
    
}
