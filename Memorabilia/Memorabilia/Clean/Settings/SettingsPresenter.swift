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
    
    func present(_ settings: [SettingsEntity.Present], shouldUpdate: Bool)
    
}

class SettingsPresenter: SettingsPresenterInput {
    
    // MARK: Clean Properties
    
    weak var viewController: SettingsViewInput?
    
    // MARK: Properties
    
    private var sections: [SettingsSection] = []
    
    // MARK: Functions
    
    func present(_ settings: [SettingsEntity.Present], shouldUpdate: Bool) {
        var sections: [SettingsSection] = []
        
        let messageItem = SettingsEntity.Display.MessageItem(message: """
        Este aplicativo foi desenvolvido por André Mello Alves como projeto de graduação em Engenharia da Computação na PUC-Rio.
        """)
        let messageSection = SettingsEntity.Display.AboutSection(title: "Sobre", settings: [messageItem])
        sections.append(messageSection)
        
        let flagItem = SettingsEntity.Display.FlagItem(flag: "bandeira-nacional-brasil")
        let flagSection = SettingsEntity.Display.FlagSection(title: nil, flags: [flagItem])
        sections.append(flagSection)
        
        if shouldUpdate {
            update(sections)
        } else {
            self.sections = sections
            
            DispatchQueue.main.async {
                self.viewController?.load(sections)
            }
        }
    }
    
    private func update(_ newSections: [SettingsSection]) {
        let oldData = flatten(sections: sections)
        let newData = flatten(sections: newSections)
        let changes = SeriesChanges.calculate(old: oldData, new: newData)

        sections = newSections
        
        DispatchQueue.main.async {
            self.viewController?.reload(newSections, with: changes)
        }
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
