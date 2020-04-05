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
    
    func apply(changes: SectionChanges, sections: [MemoriesSection])
    
}

class MemoriesViewController: UIViewController {
    
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
        let viewInsets = UIEdgeInsets(top: 72, left: 0, bottom: 72, right: 0)
        view.contentInset = viewInsets
        view.scrollIndicatorInsets = viewInsets
        view.backgroundColor = .clear
        view.isPagingEnabled = false
        view.delegate = self
        view.dataSource = self
        view.register(MemoryCollectionViewCell.self,forCellWithReuseIdentifier: MemoryCollectionViewCell.identifier)
        view.register(EmptyMemoryCollectionViewCell.self, forCellWithReuseIdentifier: EmptyMemoryCollectionViewCell.identifier)
        return view
    }()
    
    let navigation: NavigationBarView = {
        let view = NavigationBarView()
        view.leftButton.setImage(UIImage(systemName: "cloud.moon.fill"), for: .normal)
        view.titleButton.setTitle("Memórias", for: .normal)
        view.rightButton.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        return view
    }()
    
    let action: ActionBarView = {
        let view = ActionBarView()
        view.button.setTitle("Criar memória", for: .normal)
        view.button.addTarget(self, action: #selector(actionBarButtonAction), for: .primaryActionTriggered)
        return view
    }()
    
    // MARK: View model
    
    var memoriesSections: [MemoriesSection] = [MemoriesEntity.Display.MemorySection(memories: [])]
    
    let photoDataCache = NSCache<NSString, NSData>()
    
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
        view.backgroundColor = .systemGray
        
        // CollectionView
        view.addSubview(collection)
        
        // Navigation bar
        view.addSubview(navigation)
//        navigation.leftButton.addTarget(self, action: #selector(backButtonAction), for: .primaryActionTriggered)
//        navigation.rightButton.addTarget(self, action: #selector(optionsButtonAction), for: .primaryActionTriggered)
        
        // Action bar
        view.addSubview(action)
//        action.button.addTarget(self, action: #selector(addItemButtonAction), for: .primaryActionTriggered)
        
        // Constraints
        setupConstraints()
    }
    
    // MARK: Constraints
    
    internal var navigationHeightAnchor: NSLayoutConstraint = NSLayoutConstraint()
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Collection
            collection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collection.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            collection.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            collection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            // Navigation bar
            navigation.leftButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            navigation.topAnchor.constraint(equalTo: view.topAnchor),
            navigation.leftAnchor.constraint(equalTo: view.leftAnchor),
            navigation.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            // Action bar
            action.button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            action.leftAnchor.constraint(equalTo: view.leftAnchor),
            action.rightAnchor.constraint(equalTo: view.rightAnchor),
            action.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        interactor?.readMemories()
    }
    
    // MARK: Actions
    
    @objc func actionBarButtonAction() {
        routeToCreate()
    }
    
    // MARK: Navigation
    
    func routeToCreate() {
        router?.routeToCreateViewController()
    }

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
    
    func apply(changes: SectionChanges, sections: [MemoriesSection]) {
        memoriesSections = sections
        
        collection.deleteSections(changes.deletes)
        collection.insertSections(changes.inserts)
        
        collection.reloadItems(at: changes.updates.reloads)
        collection.insertItems(at: changes.updates.inserts)
        collection.deleteItems(at: changes.updates.deletes)
    }
    
}
