//
//  CreatePresenter.swift
//  Memorabilia
//
//  Created by André Mello Alves on 08/04/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import Foundation

protocol CreatePresenterInput {
    
    // Present
    
    func present()
    
}

class CreatePresenter: CreatePresenterInput {
    
    // MARK: Clean Properties
    
    weak var viewController: CreateViewInput?
    
    // MARK: Properties
    
    // MARK: Functions
    
    func present() {
        var sections: [CreateSection] = []
        
        let spacingItem = CreateEntity.Display.SpacingItem()
        let studioItem = CreateEntity.Display.StudioItem()
        
        let nameItem = CreateEntity.Display.NameItem()
        let nameSection = CreateEntity.Display.NameSection(title: "Nome", names: [nameItem])
        sections.append(nameSection)
        
        let coverItem = CreateEntity.Display.CoverItem()
        let coverSection = CreateEntity.Display.CoverSection(title: "Foto de capa", covers: [coverItem, spacingItem, studioItem])
        sections.append(coverSection)
        
        viewController?.loadSections(sections: sections)
    }
    
}

