//
//  InformationPresenter.swift
//  Memorabilia
//
//  Created by André Mello Alves on 24/05/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import Foundation

protocol InformationPresenterInput {
    
    // Present
    
}

class InformationPresenter: InformationPresenterInput {
    
    // MARK: Clean Properties
    
    weak var viewController: InformationViewInput?
    
    // MARK: Properties
    
    private var sections: [InformationSection] = [InformationEntity.Display.Section(names: [])]
    
    // MARK: Functions
    
    private func setup(newSections: [InformationSection]) {
        let oldData = flatten(sections: sections)
        let newData = flatten(sections: newSections)
        let changes = SeriesChanges.calculate(old: oldData, new: newData)

        sections = newSections
        viewController?.reloadSections(changes: changes, sections: newSections)
    }

    private func flatten(sections: [InformationSection]) -> [ReloadableSection<InformationEntity.Display.ItemWrapper>] {
        let reloadableSections = sections
            .enumerated()
            .map { ReloadableSection(uid: $0.element.uid, items: $0.element.items
                .enumerated()
                .map { ReloadableItem(uid: $0.element.uid, item: $0.element, index: $0.offset)  }, index: $0.offset) }
        return reloadableSections
    }
    
}
