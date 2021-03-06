//
//  MemoriesViewController.swift
//  Memorabilia
//
//  Created by André Mello Alves on 01/12/19.
//  Copyright © 2019 André Mello Alves. All rights reserved.
//

import UIKit
import ARKit
import Photos

protocol MemoriesViewInput: class {

    // Update
    
    func load(_ snapshot: Data, with id: String, for index: IndexPath)
    
    func load(_ sections: [MemoriesSection])
    
    func reload(_ sections: [MemoriesSection], with changes: SectionChanges)
    
}

class MemoriesViewController: UIViewController, MenuPage {
    
    // MARK: Menu page
    
    var menu: MenuController?
    
    var type: MenuPageType = .memories
    
    // MARK: Clean Properties
    
    var interactor: MemoriesInteractorInput?
    
    var router: (MemoriesRouterInput & MemoriesRouterOutput)?
    
    // MARK: Properties
    
    lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        let viewInsets = UIEdgeInsets(top: 72, left: 16, bottom: 82, right: 16)
        view.contentInset = viewInsets
        view.scrollIndicatorInsets = viewInsets
        view.backgroundColor = .clear
        view.delegate = self
        view.dataSource = self
        view.register(CollectionViewHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionViewHeaderView.identifier)
        view.register(MemoryCollectionViewCell.self,forCellWithReuseIdentifier: MemoryCollectionViewCell.identifier)
        view.register(EmptyMemoryCollectionViewCell.self, forCellWithReuseIdentifier: EmptyMemoryCollectionViewCell.identifier)
        return view
    }()
    
    // MARK: Control properties
    
    var selectedMemory: MemoriesEntity.Display.MemoryItem?
    
    // MARK: View model
    
    var sections: [MemoriesSection] = []
    
    let snapshotDataCache = NSCache<NSString, NSData>()
    
    // MARK: Initializers
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        cleanSetup()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        cleanSetup()
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        // Self
        view.backgroundColor = .clear
        
        // CollectionView
        view.addSubview(collection)
        
        // Constraints
        setupConstraints()
    }
    
    // MARK: Constraints
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Collection
            collection.topAnchor.constraint(equalTo: view.topAnchor),
            collection.leftAnchor.constraint(equalTo: view.leftAnchor),
            collection.rightAnchor.constraint(equalTo: view.rightAnchor),
            collection.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        interactor?.readMemories()
    }
    
    // MARK: Actions
    
    @objc func createButtonAction() {
        routeToCreate()
    }
    
    // MARK: Navigation
    
    func pageWillDisapear() {
        
    }
    
    func routeToCreate() {
        menu?.setPage(type: .create)
    }
    
    func routeToExperience(memoryID: String) {
        guard ARWorldTrackingConfiguration.isSupported else {
            menu?.showActionView(symbol: "exclamationmark.triangle.fill", text: "AR indisponível", duration: 2)
            return
        }
        
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                DispatchQueue.main.async {
                    self.router?.routeToExperienceViewController(memoryID: memoryID)
                }
            default:
                DispatchQueue.main.async {
                    self.menu?.showActionView(symbol: "exclamationmark.triangle.fill", text: "Sem acesso a fotos", duration: 2)
                }
            }
        }
    }
    
    let transition = SnapshotTransition()
    
}

extension MemoriesViewController {
    
    // MARK: Clean setup
    
    private func cleanSetup() {
        let viewController = self
        let interactor = MemoriesInteractor()
        let presenter = MemoriesPresenter()
        let router = MemoriesRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.interactor = interactor
    }
    
}

extension MemoriesViewController: MemoriesViewInput {
    
    // Update
    
    func load(_ snapshot: Data, with id: String, for index: IndexPath) {
        snapshotDataCache.setObject(snapshot as NSData, forKey: NSString(string: id))
        
        collection.reloadItems(at: [index])
    }
    
    func load(_ sections: [MemoriesSection]) {
        self.sections = sections
        
        collection.reloadData()
    }
    
    func reload(_ sections: [MemoriesSection], with changes: SectionChanges) {
        self.sections = sections
        
        collection.performBatchUpdates({
            collection.deleteSections(changes.deletes)
            collection.insertSections(changes.inserts)
            
            collection.reloadItems(at: changes.updates.reloads)
            collection.insertItems(at: changes.updates.inserts)
            collection.deleteItems(at: changes.updates.deletes)
        }, completion: nil)
    }
    
}

extension MemoriesViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition
    }
    
}
