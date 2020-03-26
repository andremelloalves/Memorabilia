//
//  MemoriesViewController.swift
//  Memorabilia
//
//  Created by André Mello Alves on 01/12/19.
//  Copyright © 2019 André Mello Alves. All rights reserved.
//

import UIKit

protocol MemoriesViewInput: class {
    
}

class MemoriesViewController: UIViewController, MemoriesViewInput {
    
    // MARK: Clean Properties
    
    var interactor: MemoriesInteractorInput?
    
    var router: (MemoriesRouterInput & MemoriesRouterOutput)?
    
    // MARK: Properties
    
    let collection: UICollectionView = {
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
        return view
    }()
    
    let navigation: NavigationBarView = {
        let view = NavigationBarView()
        view.leftButton.icon.image = UIImage(systemName: "ellipsis.circle")
        view.titleButton.setTitle("Memórias", for: .normal)
        view.rightButton.icon.image = UIImage(systemName: "ellipsis.circle")
        return view
    }()
    
    let action: ActionBarView = {
        let view = ActionBarView()
        view.button.title.text = "Criar memória"
        return view
    }()
    
    // MARK: View model
    
//    var memoriesSections: [ListSection] = []
    
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
        view.backgroundColor = .systemBlue
        
        // CollectionView
        collection.delegate = self
        collection.dataSource = self
        collection.register(MemoryCollectionViewCell.self,forCellWithReuseIdentifier: MemoryCollectionViewCell.identifier)
        
        // Navigation bar
//        navigation.leftButton.addTarget(self, action: #selector(backButtonAction), for: .primaryActionTriggered)
//        navigation.rightButton.addTarget(self, action: #selector(optionsButtonAction), for: .primaryActionTriggered)
        
        // Action bar
//        action.button.addTarget(self, action: #selector(addItemButtonAction), for: .primaryActionTriggered)
        
        // Subviews
        view.addSubview(collection)
        view.addSubview(navigation)
        view.addSubview(action)
        
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

        view.backgroundColor = .systemBlue
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

extension MemoriesViewController {
    
    // Update
}
