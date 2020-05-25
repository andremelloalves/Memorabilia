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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InformationCollectionViewCell.identifier,for: indexPath) as? InformationCollectionViewCell,
            let information = sections[indexPath.section].items[indexPath.item].item as? InformationEntity.Display.Item
            else { return EmptyInformationCollectionViewCell() }
        
        cell.update(information: information)
        
        return cell
    }

}
