//
//  Memories+Collection.swift
//  Memorabilia
//
//  Created by André Mello Alves on 15/03/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import UIKit

extension MemoriesViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sections[section].items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmptyMemoryCollectionViewCell.identifier, for: indexPath) as? EmptyMemoryCollectionViewCell,
            let empty = sections[indexPath.section].items[indexPath.item].item as? MemoriesEntity.Display.EmptyItem {
            cell.button.update(title: empty.message, image: UIImage(systemName: "plus"))
            cell.button.addTarget(self, action: #selector(createButtonAction), for: .primaryActionTriggered)
            return cell
        } else if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemoryCollectionViewCell.identifier, for: indexPath) as? MemoryCollectionViewCell,
            let memory = sections[indexPath.section].items[indexPath.row].item as? MemoriesEntity.Display.MemoryItem {
            if let data = snapshotDataCache.object(forKey: NSString(string: memory.snapshotID)) {
                cell.updateCover(data as Data)
            } else {
                interactor?.readMemorySnapshot(id: memory.snapshotID, index: indexPath)
            }
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let title = sections[indexPath.section].title ?? ""
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionViewHeaderView.identifier, for: indexPath) as? CollectionViewHeaderView
        header?.updateTitle(title: title)
        
        return header ?? UICollectionReusableView()
    }

}

extension MemoriesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 48) / 2
        let size = CGSize(width: width, height: width)
        
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 0, bottom: 32, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 44)
    }
    
}

extension MemoriesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let memory = sections[indexPath.section].items[indexPath.item].item as? MemoriesEntity.Display.MemoryItem else { return }
        
        routeToExperience(memoryID: memory.memoryID)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        guard let memory = sections[indexPath.section].items[indexPath.item].item as? MemoriesEntity.Display.MemoryItem else { return nil }
        selectedMemory = memory
        
        let delete = UIAction(title: "Exluir memória", image: UIImage(systemName: "trash.fill"), attributes: .destructive) { _ in
            self.interactor?.deleteMemory(id: memory.memoryID)
            self.selectedMemory = nil
        }
        let menu = UIMenu(title: "", image: nil, children: [delete])
        let configuration = UIContextMenuConfiguration(identifier: NSString(string: memory.memoryID), previewProvider: previewProvider) { _ in return menu }
        
        return configuration
    }
    
    func collectionView(_ collectionView: UICollectionView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        guard let identifier = configuration.identifier as? String else { return }
        
        animator.addCompletion {
            self.router?.routeToExperienceViewController(memoryID: identifier)
        }
    }
    
    func previewProvider() -> UIViewController {
        guard let memory = selectedMemory else { return UIViewController() }
        
        let viewController = MemoryContextMenuViewController()
        viewController.update(memory: memory)
        
        return viewController
    }
    
}
