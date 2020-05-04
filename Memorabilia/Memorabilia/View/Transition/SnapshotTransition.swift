//
//  SnapshotTransition.swift
//  Memorabilia
//
//  Created by André Mello Alves on 03/05/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import UIKit

class SnapshotTransition: NSObject {
    
    // MARK: Properties
    
    let duration = 0.5
    
    var isPresenting = false
    
    var cellFrame: CGRect = .zero
    
    var snapshotFrame: CGRect = .zero
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }()
    
}

extension SnapshotTransition: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresenting {
            animateFrom(using: transitionContext)
        } else {
            animateTo(using: transitionContext)
        }

        isPresenting.toggle()
    }
    
    private func animateTo(using transitionContext: UIViewControllerContextTransitioning) {
        guard let menu = transitionContext.viewController(forKey: .from) as? MenuController,
            let from = menu.getPage(type: MemoriesViewController.self) as? MemoriesViewController,
            let to = transitionContext.viewController(forKey: .to) as? ExperienceViewController,
            let index = from.collection.indexPathsForSelectedItems?.first,
            let cell = from.collection.cellForItem(at: index) as? MemoryCollectionViewCell,
            let frame = cell.superview?.convert(cell.frame, to: nil)
            else {
                transitionContext.completeTransition(false)
                return
        }
        
        self.cellFrame = frame
        self.snapshotFrame = to.snapshotView.frame
        
        imageView.frame = cellFrame
        imageView.image = cell.photo.image
        
        let container = transitionContext.containerView
        container.addSubview(imageView)

        UIView.animate(withDuration: duration, animations: {
            self.imageView.frame = self.snapshotFrame
            menu.view.alpha = 0
        }) { _ in
            self.imageView.removeFromSuperview()
            container.addSubview(to.view)
            transitionContext.completeTransition(true)
        }
    }
    
    private func animateFrom(using transitionContext: UIViewControllerContextTransitioning) {
        guard let menu = transitionContext.viewController(forKey: .to) as? MenuController,
            let from = transitionContext.viewController(forKey: .from) as? ExperienceViewController else {
            transitionContext.completeTransition(false)
            return
        }
        
        imageView.frame = from.snapshotView.frame
        
        let container = transitionContext.containerView
        from.view.removeFromSuperview()
        container.addSubview(imageView)

        UIView.animate(withDuration: duration, animations: {
            self.imageView.frame = self.cellFrame
            menu.view.alpha = 1
        }) { _ in
            self.imageView.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
    
}
