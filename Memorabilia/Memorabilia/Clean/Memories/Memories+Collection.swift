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
        memoriesSections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        memoriesSections[section].items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemoryCollectionViewCell.identifier,for: indexPath) as? MemoryCollectionViewCell else { return UICollectionViewCell() }
        guard let memory = memoriesSections[indexPath.section].items[indexPath.row].item as? MemoriesEntity.Display.MemoryItem else { return UICollectionViewCell() }
        
        cell.infoView.layer.cornerRadius = 12
        cell.update(memory: memory)
        if let data = photoDataCache.object(forKey: NSString(string: memory.photoID)) {
            cell.updatePhoto(data as Data)
        } else {
            interactor?.readMemoryPhoto(id: memory.photoID, index: indexPath)
        }
        
        return cell
    }

}

extension MemoriesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let memory = memoriesSections[indexPath.section].items[indexPath.item].item as? MemoriesEntity.Display.MemoryItem else { return }
        router?.routeToExperienceViewController(memoryID: memory.memoryID)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        guard let memory = memoriesSections[indexPath.section].items[indexPath.item].item as? MemoriesEntity.Display.MemoryItem else { return nil }
        
        let delete = UIAction(title: "Exluir memória", image: UIImage(named: "trash.fill"), attributes: .destructive) { _ in
            self.interactor?.deleteMemory(id: memory.memoryID)
        }
        let menu = UIMenu(title: "", image: nil, children: [delete])
        let configuration = UIContextMenuConfiguration(identifier: NSString(string: memory.memoryID), previewProvider: nil) { _ in return menu }
        
        return configuration
    }
    
    func collectionView(_ collectionView: UICollectionView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        guard let identifier = configuration.identifier as? String else { return }
        
        animator.addCompletion {
            self.router?.routeToExperienceViewController(memoryID: identifier)
        }
    }
    
}
