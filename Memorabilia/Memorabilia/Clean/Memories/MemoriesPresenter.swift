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
    
    func presentMemoryPhoto(_ data: Data, with id: String, for index: IndexPath)
    
    func presentMemories(entity: MemoriesEntity.Present)
    
}

class MemoriesPresenter: MemoriesPresenterInput {
    
    // MARK: Clean Properties
    
    weak var viewController: MemoriesViewInput?
    
    // MARK: Properties
    
    private var sections: [MemoriesSection] = [MemoriesEntity.Display.MemorySection(memories: [])]
    
    // MARK: Functions
    
    func presentMemoryPhoto(_ data: Data, with id: String, for index: IndexPath) {
        viewController?.loadPhoto(data, with: id, for: index)
    }
    
    func presentMemories(entity: MemoriesEntity.Present) {
        var sections: [MemoriesSection] = []
        
        var memoryItems: [MemoriesEntity.Display.MemoryItem] = []
        
        for memory in entity.memories {
            let memoryID = memory.uid
            let name = memory.name
            let format = DateFormatter()
            format.locale = .current
            format.dateFormat = "EEEE, d MMM yy"
            let date = format.string(from: memory.creationDate)
            let photoID = memory.uid
            let memoryItem = MemoriesEntity.Display.MemoryItem(memoryID: memoryID,name: name, date: date, photoID: photoID)
            memoryItems.append(memoryItem)
        }
        
        let memoriesSection = MemoriesEntity.Display.MemorySection(memories: memoryItems)
        sections.append(memoriesSection)
        
        setup(newSections: sections)
    }
    
    private func setup(newSections: [MemoriesSection]) {
        let oldData = flatten(sections: sections)
        let newData = flatten(sections: newSections)
        let changes = SeriesChanges.calculate(old: oldData, new: newData)

        sections = newSections
        viewController?.apply(changes: changes, sections: newSections)
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
