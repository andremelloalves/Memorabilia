//
//  Memories+Collection.swift
//  Memorabilia
//
//  Created by André Mello Alves on 15/03/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import UIKit

extension MemoriesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemoryCollectionViewCell.identifier, for: indexPath) as? MemoryCollectionViewCell else { return UICollectionViewCell() }
        cell.infoView.layer.cornerRadius = 12
        cell.infoView.title = "Sala de estar"
        cell.infoView.info = "14 de setembro de 2019"
        return cell
    }

}

extension MemoriesViewController: UICollectionViewDelegate {
    
}
