//
//  SnapshotTransition.swift
//  Memorabilia
//
//  Created by André Mello Alves on 03/05/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import UIKit

class SnapshotTransition: NSObject {
    
    let duration = 0.5
    var presenting = true
    
}

extension SnapshotTransition: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let menu = transitionContext.viewController(forKey: .from) as? MenuController,
            let from = menu.getPage(type: MemoriesViewController.self) as? MemoriesViewController,
            let to = transitionContext.viewController(forKey: .to) as? ExperienceViewController,
            let index = from.collection.indexPathsForSelectedItems?.first,
            let cell = from.collection.cellForItem(at: index) as? MemoryCollectionViewCell,
            let frame = cell.superview?.convert(cell.frame, to: nil) else { return }
        
        let image = UIImageView(frame: frame)
        image.image = cell.photo.image
        image.contentMode = cell.photo.contentMode
        image.layer.cornerRadius = cell.layer.cornerRadius
        image.clipsToBounds = true
        
        let container = transitionContext.containerView
        
        container.addSubview(image)
        
        UIView.animate(withDuration: duration, animations: {
            menu.view.alpha = 0
            image.frame = to.snapshotView.frame
            image.layer.cornerRadius = to.snapshotView.layer.cornerRadius
        }) { _ in
            image.removeFromSuperview()
            container.addSubview(to.view)
            transitionContext.completeTransition(true)
        }
    }
    
}
