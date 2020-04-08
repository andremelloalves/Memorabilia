//
//  MemoriesViewController.swift
//  Memorabilia
//
//  Created by André Mello Alves on 01/12/19.
//  Copyright © 2019 André Mello Alves. All rights reserved.
//

import UIKit

protocol MemoriesViewInput: class {

    // Update
    
    func loadPhoto(_ photo: Data, with id: String, for index: IndexPath)
    
    func loadSections(sections: [MemoriesSection])
    
    func reloadSections(changes: SectionChanges, sections: [MemoriesSection])
    
}

class MemoriesViewController: UIViewController, MenuPage {
    
    // MARK: Clean Properties
    
    var interactor: MemoriesInteractorInput?
    
    var router: (MemoriesRouterInput & MemoriesRouterOutput)?
    
    // MARK: Properties
    
    lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: 283, height: 503)
//        layout.estimatedItemSize = CGSize(width: 343, height: 612)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
//        let viewInsets = UIEdgeInsets(top: 72, left: 0, bottom: 72, right: 0)
//        view.contentInset = viewInsets
//        view.scrollIndicatorInsets = viewInsets
        view.backgroundColor = .clear
        view.isPagingEnabled = false
        view.delegate = self
        view.dataSource = self
        view.register(MemoryCollectionViewCell.self,forCellWithReuseIdentifier: MemoryCollectionViewCell.identifier)
        view.register(EmptyMemoryCollectionViewCell.self, forCellWithReuseIdentifier: EmptyMemoryCollectionViewCell.identifier)
        return view
    }()
    
    // MARK: View model
    
    var memoriesSections: [MemoriesSection] = [MemoriesEntity.Display.MemorySection(memories: [])]
    
    let photoDataCache = NSCache<NSString, NSData>()
    
    // MARK: Menu page
    
    var menu: MenuController?
    
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
        // Background
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
    
    // MARK: Navigation
    
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
    
    func loadPhoto(_ photo: Data, with id: String, for index: IndexPath) {
        photoDataCache.setObject(photo as NSData, forKey: NSString(string: id))
        
        collection.reloadItems(at: [index])
    }
    
    func loadSections(sections: [MemoriesSection]) {
        memoriesSections = sections
        
        collection.reloadData()
    }
    
    func reloadSections(changes: SectionChanges, sections: [MemoriesSection]) {
        memoriesSections = sections
        
        collection.deleteSections(changes.deletes)
        collection.insertSections(changes.inserts)
        
        collection.reloadItems(at: changes.updates.reloads)
        collection.insertItems(at: changes.updates.inserts)
        collection.deleteItems(at: changes.updates.deletes)
    }
    
}
