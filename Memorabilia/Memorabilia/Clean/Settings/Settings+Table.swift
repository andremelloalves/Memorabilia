//
//  Settings+Table.swift
//  Memorabilia
//
//  Created by André Mello Alves on 30/05/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import UIKit

extension SettingsViewController: UITableViewDataSource {
    
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
        case .message:
            let aboutCell = tableView.dequeueReusableCell(withIdentifier: MessageTableViewCell.identifier, for: indexPath) as? MessageTableViewCell
            let about = item.item as? SettingsEntity.Display.MessageItem
            aboutCell?.update(message: about?.message, width: tableView.bounds.width - 64)
            cell = aboutCell
        case .flag:
            let flagCell = tableView.dequeueReusableCell(withIdentifier: FlagTableViewCell.identifier, for: indexPath) as? FlagTableViewCell
            let flag = item.item as? SettingsEntity.Display.FlagItem
            flagCell?.updatePhoto(name: flag?.flag ?? "")
            cell = flagCell
        }
        
        return cell ?? UITableViewCell()
    }
    
}

extension SettingsViewController: UITableViewDelegate {
    
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
    
}