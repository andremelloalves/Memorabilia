//
//  SeriesChanges.swift
//  Memorabilia
//
//  Created by André Mello Alves on 11/11/19.
//  Copyright © 2019 André Mello Alves. All rights reserved.
//

import Foundation

class SectionChanges {
    
    var insertsInts = [Int]()
    
    var deletesInts = [Int]()
    
    var updates = ItemChanges()
    
    var inserts: IndexSet {
        return IndexSet(insertsInts)
    }
    
    var deletes: IndexSet {
        return IndexSet(deletesInts)
    }
    
    init(inserts: [Int] = [], deletes: [Int] = [], updates: ItemChanges = ItemChanges()) {
        self.insertsInts = inserts
        self.deletesInts = deletes
        self.updates = updates
    }
    
}

class ItemChanges {
    
    var inserts = [IndexPath]()
    
    var deletes = [IndexPath]()
    
    var reloads = [IndexPath]()
    
    
    init(inserts: [IndexPath] = [], deletes: [IndexPath] = [], reloads: [IndexPath] = []) {
        self.inserts = inserts
        self.deletes = deletes
        self.reloads = reloads
    }
    
}

struct ReloadableSection<N: Equatable>: Equatable {
    
    var uid: String
    
    var items: [ReloadableItem<N>]
    
    var index: Int
    
    static func ==(lhs: ReloadableSection, rhs: ReloadableSection) -> Bool {
        return lhs.uid == rhs.uid && lhs.items == rhs.items
    }
    
}

struct ReloadableItem<N: Equatable>: Equatable {
    
    var uid: String
    
    var item: N
    
    var index: Int
    
    static func ==(lhs: ReloadableItem, rhs: ReloadableItem) -> Bool {
        return lhs.uid == rhs.uid && lhs.item == rhs.item
    }
    
}

struct ReloadableSectionData<N: Equatable> {
    
    var sections = [ReloadableSection<N>]()
    
    subscript(uid: String) -> ReloadableSection<N>? {
        get {
            return sections.filter { $0.uid == uid }.first
        }
    }
    
    subscript(index: Int) -> ReloadableSection<N>? {
        get {
            return sections.filter { $0.index == index }.first
        }
    }
    
}

struct ReloadableItemData<N: Equatable> {
    
    var items = [ReloadableItem<N>]()
    
    subscript(uid: String) -> ReloadableItem<N>? {
        get {
            return items.filter { $0.uid == uid }.first
        }
    }
    
    subscript(index: Int) -> ReloadableItem<N>? {
        get {
            return items.filter { $0.index == index }.first
        }
    }
    
}

class SeriesChanges {
    
    static func calculate<N>(old: [ReloadableSection<N>], new: [ReloadableSection<N>]) -> SectionChanges {
        let sectionChanges = SectionChanges()
        let uniqueSectionUids = (old + new)
            .map { $0.uid }
            .filterDuplicates()
        
        let itemChanges = ItemChanges()
        
        for sectionUid in uniqueSectionUids {
            
            let oldSection = ReloadableSectionData(sections: old)[sectionUid]
            let newSection = ReloadableSectionData(sections: new)[sectionUid]
            
            if let oldSection = oldSection, let newSection = newSection {
                if oldSection != newSection {
                    let oldItemData = ReloadableItemData(items: oldSection.items)
                    let newItemData = ReloadableItemData(items: newSection.items)
                    
                    let uniqueItemUids = (oldItemData.items + newItemData.items)
                        .map { $0.uid }
                        .filterDuplicates()
                    
                    for itemUid in uniqueItemUids {
                        let oldItem = oldItemData[itemUid]
                        let newItem = newItemData[itemUid]
                        if let oldItem = oldItem, let newItem = newItem {
                            if oldItem != newItem {
                                itemChanges.reloads.append(IndexPath(item: oldItem.index, section: oldSection.index))
                            }
                        } else if let oldItem = oldItem {
                            itemChanges.deletes.append(IndexPath(item: oldItem.index, section: oldSection.index))
                        } else if let newItem = newItem {
                            itemChanges.inserts.append(IndexPath(item: newItem.index, section: newSection.index))
                        }
                    }
                }
            } else if let oldSection = oldSection {
                sectionChanges.deletesInts.append(oldSection.index)
            } else if let newSection = newSection {
                sectionChanges.insertsInts.append(newSection.index)
            }
        }
        
        sectionChanges.updates = itemChanges
        
        return sectionChanges
    }
    
}

extension Array where Element: Hashable {
   
    func filterDuplicates() -> Array<Element> {
        var set = Set<Element>()
        var filteredArray = Array<Element>()
        for item in self {
            if set.insert(item).inserted {
                filteredArray.append(item)
            }
        }
        return filteredArray
    }
    
}
