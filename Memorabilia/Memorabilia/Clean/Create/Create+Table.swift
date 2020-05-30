//
//  Create+Table.swift
//  Memorabilia
//
//  Created by André Mello Alves on 28/05/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import UIKit

extension CreateViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell?
        let item = sections[indexPath.section].items[indexPath.item]
        
        switch item.item.type {
        case .name:
            let textInputCell = tableView.dequeueReusableCell(withIdentifier: TextInputTableViewCell.identifier, for: indexPath) as? TextInputTableViewCell
            nameInput = textInputCell?.input
            nameInput?.updateInput(delegate: self, placeholder: "Digite um nome aqui")
            cell = textInputCell
        case .cover:
            let imageInputCell = tableView.dequeueReusableCell(withIdentifier: ImageInputTableViewCell.identifier, for: indexPath) as? ImageInputTableViewCell
            coverInput = imageInputCell?.input
            coverInput?.updateInput(title: "Escolha uma foto de capa aqui", image: nil)
            coverInput?.addTarget(self, action: #selector(coverInputButtonAction), for: .primaryActionTriggered)
            cell = imageInputCell
        case .spacing:
            let spacingCell = tableView.dequeueReusableCell(withIdentifier: SpacingTableViewCell.identifier, for: indexPath) as? SpacingTableViewCell
            spacingCell?.updateHeight(height: 16)
            cell = spacingCell
        case .studio:
            let studioCell = tableView.dequeueReusableCell(withIdentifier: ButtonTableViewCell.identifier, for: indexPath) as? ButtonTableViewCell
            studioButton = studioCell?.button
            studioButton?.updateInput(title: "Criar em AR", image: nil)
            studioButton?.addTarget(self, action: #selector(studioButtonAction), for: .primaryActionTriggered)
            cell = studioCell
        }
        
        return cell ?? UITableViewCell()
    }
    
}

extension CreateViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard sections[section].title != nil else { return 0 }
        
        return 36
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let title = sections[section].title else { return nil }
        
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TableViewHeaderView.identifier) as? TableViewHeaderView
        header?.updateTitle(title: title)
        
        return header
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        for section in 0..<sections.count {
            let header = table.headerView(forSection: section) as? TableViewHeaderView
            let frame = table.rectForHeader(inSection: section)
            
            let offset = frame.origin.y - scrollView.contentOffset.y - table.contentInset.top - view.safeAreaInsets.top
            if offset < -8 {
                header?.titleLabel.alpha = 0
            } else if offset < 0 {
                header?.titleLabel.alpha = 1 / -offset
            } else {
                header?.titleLabel.alpha = 1
            }
        }
    }
    
}
