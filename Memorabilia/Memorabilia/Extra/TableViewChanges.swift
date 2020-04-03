//
//  TableViewChanges.swift
//  Memorabilia
//
//  Created by André Mello Alves on 11/11/19.
//  Copyright © 2019 André Mello Alves. All rights reserved.
//

import Foundation

class SectionChanges {
    
    var insertsInts = [Int]()
    
    var deletesInts = [Int]()
    
    var updates = RowChanges()
    
    var inserts: IndexSet {
        return IndexSet(insertsInts)
    }
    
    var deletes: IndexSet {
        return IndexSet(deletesInts)
    }
    
    init(inserts: [Int] = [], deletes: [Int] = [], updates: RowChanges = RowChanges()) {
        self.insertsInts = inserts
        self.deletesInts = deletes
        self.updates = updates
    }
    
}

class RowChanges {
    
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
    
    var rows: [ReloadableRow<N>]
    
    var index: Int
    
    static func ==(lhs: ReloadableSection, rhs: ReloadableSection) -> Bool {
        return lhs.uid == rhs.uid && lhs.rows == rhs.rows
    }
    
}

struct ReloadableRow<N: Equatable>: Equatable {
    
    var uid: String
    
    var row: N
    
    var index: Int
    
    static func ==(lhs: ReloadableRow, rhs: ReloadableRow) -> Bool {
        return lhs.uid == rhs.uid && lhs.row == rhs.row
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

struct ReloadableRowData<N: Equatable> {
    
    var rows = [ReloadableRow<N>]()
    
    subscript(uid: String) -> ReloadableRow<N>? {
        get {
            return rows.filter { $0.uid == uid }.first
        }
    }
    
    subscript(index: Int) -> ReloadableRow<N>? {
        get {
            return rows.filter { $0.index == index }.first
        }
    }
    
}

class TableViewChange {
    
    static func calculate<N>(old: [ReloadableSection<N>], new: [ReloadableSection<N>]) -> SectionChanges {
        let sectionChanges = SectionChanges()
        let uniqueSectionUids = (old + new)
            .map { $0.uid }
            .filterDuplicates()
        
        let rowChanges = RowChanges()
        
        for sectionUid in uniqueSectionUids {
            
            let oldSection = ReloadableSectionData(sections: old)[sectionUid]
            let newSection = ReloadableSectionData(sections: new)[sectionUid]
            
            if let oldSection = oldSection, let newSection = newSection {
                if oldSection != newSection {
                    let oldRowData = ReloadableRowData(rows: oldSection.rows)
                    let newRowData = ReloadableRowData(rows: newSection.rows)
                    
                    let uniqueRowUids = (oldRowData.rows + newRowData.rows)
                        .map { $0.uid }
                        .filterDuplicates()
                    
                    for rowUid in uniqueRowUids {
                        let oldRow = oldRowData[rowUid]
                        let newRow = newRowData[rowUid]
                        if let oldRow = oldRow, let newRow = newRow {
                            if oldRow != newRow {
                                rowChanges.reloads.append(IndexPath(row: oldRow.index, section: oldSection.index))
                            }
                        } else if let oldRow = oldRow {
                            rowChanges.deletes.append(IndexPath(row: oldRow.index, section: oldSection.index))
                        } else if let newRow = newRow {
                            rowChanges.inserts.append(IndexPath(row: newRow.index, section: newSection.index))
                        }
                    }
                }
            } else if let oldSection = oldSection {
                sectionChanges.deletesInts.append(oldSection.index)
            } else if let newSection = newSection {
                sectionChanges.insertsInts.append(newSection.index)
            }
        }
        
        sectionChanges.updates = rowChanges
        
        return sectionChanges
    }
    
}

extension Array where Element: Hashable {
   
    /// Remove duplicates from the array, preserving the items order
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
