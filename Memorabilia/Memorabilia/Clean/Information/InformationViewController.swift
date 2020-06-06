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
    
    func load(_ sections: [InformationSection])
    
    func reload(_ sections: [InformationSection], with changes: SectionChanges)
    
}

class InformationViewController: UIViewController {
    
    // MARK: Clean Properties
    
    var interactor: InformationInteractorInput?
    
    var router: (InformationRouterInput & InformationRouterOutput)?
    
    // MARK: View properties
    
    let background: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .systemUltraThinMaterial)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        return blurView
    }()
    
    lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        view.scrollIndicatorInsets = UIEdgeInsets(top: 4, left: 32, bottom: 4, right: 32)
        view.backgroundColor = .clear
        view.dataSource = self
        view.delegate = self
        view.register(InformationCollectionViewCell.self,forCellWithReuseIdentifier: InformationCollectionViewCell.identifier)
        view.register(EmptyInformationCollectionViewCell.self, forCellWithReuseIdentifier: EmptyInformationCollectionViewCell.identifier)
        return view
    }()
    
    let exitButton: PillButton = {
        let button = PillButton()
        button.setTitle("Entendi", for: .normal)
        button.addTarget(self, action: #selector(exitButtonAction), for: .primaryActionTriggered)
        return button
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
        view.backgroundColor = .clear
        
        // Background
        view.addSubview(background)
        
        // CollectionView
        view.addSubview(collection)
        
        // Exit button
        view.addSubview(exitButton)
        
        // Constraints
        setupConstraints()
    }
    
    // MARK: Constraints
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Background
            background.topAnchor.constraint(equalTo: view.topAnchor),
            background.leftAnchor.constraint(equalTo: view.leftAnchor),
            background.rightAnchor.constraint(equalTo: view.rightAnchor),
            background.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Collection
            collection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collection.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            collection.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            collection.bottomAnchor.constraint(equalTo: exitButton.topAnchor),
            
            // Exit button
            exitButton.heightAnchor.constraint(equalToConstant: 50),
            exitButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -32),
            exitButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            exitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    // MARK: View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor?.read()
    }
    
    // MARK: Action
    
    @objc func exitButtonAction() {
        routeBack()
    }

    // MARK: Animation
    
    // MARK: Navigation
    
    func routeBack() {
        router?.routeBack()
    }
    
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
    
    func load(_ sections: [InformationSection]) {
        self.sections = sections
        
        collection.reloadData()
    }
    
    func reload(_ sections: [InformationSection], with changes: SectionChanges) {
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
