//
//  MemoriesPresenter.swift
//  Memorabilia
//
//  Created by André Mello Alves on 15/03/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import Foundation

protocol MemoriesPresenterInput {
    
    // Present
    
    func presentMemorySnapshot(_ data: Data, with id: String, for index: IndexPath)
    
    func present(memories: [MemoriesEntity.Present], shouldUpdate: Bool)
    
}

class MemoriesPresenter: MemoriesPresenterInput {
    
    // MARK: Clean Properties
    
    weak var viewController: MemoriesViewInput?
    
    // MARK: Properties
    
    private var sections: [MemoriesSection] = []
    
    // MARK: Functions
    
    func presentMemorySnapshot(_ data: Data, with id: String, for index: IndexPath) {
        DispatchQueue.main.async {
            self.viewController?.loadSnapshot(data, with: id, for: index)
        }
    }
    
    func present(memories: [MemoriesEntity.Present], shouldUpdate: Bool) {
        var sections: [MemoriesSection] = []
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.dateFormat = "MMMM yyyy"
        
        let groupedMemories = Dictionary(grouping: memories) { formatter.string(from: $0.creationDate) }
            .sorted(by: { $0.value[0].creationDate > $1.value[0].creationDate })
        formatter.dateFormat = "dd/MM/yyyy"
        
        for group in groupedMemories {
            let title = group.key
            var memoryItems: [MemoriesEntity.Display.MemoryItem] = []
            
            for memory in group.value.sorted(by: { $0.creationDate > $1.creationDate }) {
                let memoryID = memory.uid
                let name = memory.name
                let date = formatter.string(from: memory.creationDate)
                let memoryItem = MemoriesEntity.Display.MemoryItem(memoryID: memoryID,name: name, date: date)
                memoryItems.append(memoryItem)
            }
            
            let section = MemoriesEntity.Display.MemorySection(title: title, memories: memoryItems)
            sections.append(section)
        }
        
        if groupedMemories.isEmpty {
            let emptyItem = MemoriesEntity.Display.EmptyItem()
            let section = MemoriesEntity.Display.EmptySection(title: "Sua biblioteca está vazia", empty: [emptyItem])
            sections.append(section)
        }
        
        if shouldUpdate {
            update(sections)
        } else {
            self.sections = sections
            
            DispatchQueue.main.async {
                self.viewController?.loadSections(sections: sections)
            }
        }
    }
    
    private func update(_ newSections: [MemoriesSection]) {
        let oldData = flatten(sections: sections)
        let newData = flatten(sections: newSections)
        let changes = SeriesChanges.calculate(old: oldData, new: newData)

        sections = newSections
        
        DispatchQueue.main.async {
            self.viewController?.reloadSections(changes: changes, sections: newSections)
        }
    }

    private func flatten(sections: [MemoriesSection]) -> [ReloadableSection<MemoriesEntity.Display.ItemWrapper>] {
        let reloadableSections = sections
            .enumerated()
            .map { ReloadableSection(uid: $0.element.uid, items: $0.element.items
                .enumerated()
                .map { ReloadableItem(uid: $0.element.uid, item: $0.element, index: $0.offset)  }, index: $0.offset) }
        return reloadableSections
    }
    
}
