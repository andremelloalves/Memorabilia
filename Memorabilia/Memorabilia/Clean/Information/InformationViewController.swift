//
//  InformationViewController.swift
//  Memorabilia
//
//  Created by André Mello Alves on 24/05/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import UIKit

protocol InformationViewInput: class {

    // Update
    
    func loadSections(sections: [InformationSection])
    
    func reloadSections(changes: SectionChanges, sections: [InformationSection])
    
}

class InformationViewController: UIViewController {
    
    // MARK: Clean Properties
    
    var interactor: InformationInteractorInput?
    
    var router: (InformationRouterInput & InformationRouterOutput)?
    
    // MARK: View properties
    
    lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        let width = UIScreen.main.bounds.width - 16
        let height = width
        layout.itemSize = CGSize(width: width, height: height)
//        layout.estimatedItemSize = CGSize(width: 343, height: 612)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        let viewInsets = UIEdgeInsets(top: 72, left: 0, bottom: 82, right: 0)
        view.contentInset = viewInsets
        view.scrollIndicatorInsets = viewInsets
        view.backgroundColor = .clear
        view.isPagingEnabled = true
        view.dataSource = self
        view.register(InformationCollectionViewCell.self,forCellWithReuseIdentifier: InformationCollectionViewCell.identifier)
        view.register(EmptyInformationCollectionViewCell.self, forCellWithReuseIdentifier: EmptyInformationCollectionViewCell.identifier)
        return view
    }()

    // MARK: Control properties

    // MARK: ... properties
    
    // MARK: View model
    
    var sections: [InformationSection] = []
    
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
        // Self
        view.backgroundColor = .systemBackground
        
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
        interactor?.readInformations()
    }
    
    // MARK: Action

    // MARK: Animation
    
    // MARK: Navigation
    
}

extension InformationViewController {
    
    // MARK: Clean setup
    
    private func cleanSetup() {
        let viewController = self
        let interactor = InformationInteractor()
        let presenter = InformationPresenter()
        let router = InformationRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.interactor = interactor
    }
    
}

extension InformationViewController: InformationViewInput {
    
    // Update
    
    func loadSections(sections: [InformationSection]) {
        self.sections = sections
        
        collection.reloadData()
    }
    
    func reloadSections(changes: SectionChanges, sections: [InformationSection]) {
        self.sections = sections
        
        collection.deleteSections(changes.deletes)
        collection.insertSections(changes.inserts)
        
        collection.reloadItems(at: changes.updates.reloads)
        collection.insertItems(at: changes.updates.inserts)
        collection.deleteItems(at: changes.updates.deletes)
    }
    
}
