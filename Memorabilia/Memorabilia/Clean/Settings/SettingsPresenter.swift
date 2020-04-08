//
//  SettingsPresenter.swift
//  Memorabilia
//
//  Created by André Mello Alves on 08/04/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import Foundation

protocol SettingsPresenterInput {
    
    // Present
    
}

class SettingsPresenter: SettingsPresenterInput {
    
    // MARK: Clean Properties
    
    weak var viewController: SettingsViewInput?
    
    // MARK: Properties
    
    private var sections: [SettingsSection] = [SettingsEntity.Display.SettingSection(settings: [])]
    
    // MARK: Functions
    
    private func setup(newSections: [SettingsSection]) {
        let oldData = flatten(sections: sections)
        let newData = flatten(sections: newSections)
        let changes = SeriesChanges.calculate(old: oldData, new: newData)

        sections = newSections
        viewController?.reloadSections(changes: changes, sections: newSections)
    }

    private func flatten(sections: [SettingsSection]) -> [ReloadableSection<SettingsEntity.Display.ItemWrapper>] {
        let reloadableSections = sections
            .enumerated()
            .map { ReloadableSection(uid: $0.element.uid, items: $0.element.items
                .enumerated()
                .map { ReloadableItem(uid: $0.element.uid, item: $0.element, index: $0.offset)  }, index: $0.offset) }
        return reloadableSections
    }
    
}
