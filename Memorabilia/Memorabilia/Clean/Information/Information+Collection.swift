//
//  Information+Collection.swift
//  Memorabilia
//
//  Created by André Mello Alves on 24/05/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import UIKit

extension InformationViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sections[section].items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InformationCollectionViewCell.identifier, for: indexPath) as? InformationCollectionViewCell,
            let information = sections[indexPath.section].items[indexPath.item].item as? InformationEntity.Display.Item {
            update(cell: cell, with: information)
            return cell
        } else if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmptyInformationCollectionViewCell.identifier, for: indexPath) as? EmptyInformationCollectionViewCell,
            let information = sections[indexPath.section].items[indexPath.item].item as? InformationEntity.Display.Empty {
            update(cell: cell, with: information)
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func update(cell: InformationCollectionViewCell, with information: InformationEntity.Display.Item) {
        cell.update(information: information)
        
        if let data = photoDataCache.object(forKey: NSString(string: information.photoID)) {
            cell.updatePhoto(data as Data)
        } else {
            let image = UIImage(named: information.photoID)
            if let data = image?.pngData() {
                cell.updatePhoto(data)
                photoDataCache.setObject(data as NSData, forKey: NSString(string: information.photoID))
            }
        }
    }
    
    func update(cell: EmptyInformationCollectionViewCell, with empty: InformationEntity.Display.Empty) {
        cell.update(information: empty)
    }

}
