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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemoryCollectionViewCell.identifier,for: indexPath) as? MemoryCollectionViewCell,
            let memory = sections[indexPath.section].items[indexPath.row].item as? MemoriesEntity.Display.MemoryItem
            else { return EmptyMemoryCollectionViewCell() }
        
        if let data = photoDataCache.object(forKey: NSString(string: memory.photoID)) {
            cell.updateCover(data as Data)
        } else {
            interactor?.readMemoryPhoto(id: memory.photoID, index: indexPath)
        }
        
        return cell
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
        let width = collectionView.frame.width / 2
        let size = CGSize(width: width, height: width)
        
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
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
        router?.routeToExperienceViewController(memoryID: memory.memoryID)
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
        guard let memory = selectedMemory, let data = photoDataCache.object(forKey: NSString(string: memory.photoID))
             else { return UIViewController() }
        
        let viewController = MemoryContextMenuViewController()
        viewController.cover.image = UIImage(data: data as Data)
        viewController.date.text = memory.date
        viewController.name.text = memory.name
        return viewController
    }
    
}
