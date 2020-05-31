//
//  SettingsViewController.swift
//  Memorabilia
//
//  Created by André Mello Alves on 08/04/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import UIKit

protocol SettingsViewInput: class {

    // Update
    
    func loadSections(sections: [SettingsSection])
    
    func reloadSections(changes: SectionChanges, sections: [SettingsSection])
    
}

class SettingsViewController: UIViewController, MenuPage {

    // MARK: Menu page

    var menu: MenuController?
    
    var type: MenuPageType = .settings
    
    // MARK: Clean Properties
    
    var interactor: SettingsInteractorInput?
    
    var router: (SettingsRouterInput & SettingsRouterOutput)?
    
    // MARK: View properties
    
    lazy var table: UITableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        view.backgroundColor = .clear
        view.allowsSelection = false
        view.dataSource = self
        view.delegate = self
        view.rowHeight = UITableView.automaticDimension
        view.estimatedRowHeight = 40
        view.estimatedSectionHeaderHeight = 60
        let insets = UIEdgeInsets(top: 72, left: 0, bottom: 72, right: 0)
        view.contentInset = insets
        view.scrollIndicatorInsets = insets
        view.separatorStyle = .none
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(TableViewHeaderView.self, forHeaderFooterViewReuseIdentifier: TableViewHeaderView.identifier)
        view.register(MessageTableViewCell.self, forCellReuseIdentifier: MessageTableViewCell.identifier)
        view.register(FlagTableViewCell.self, forCellReuseIdentifier: FlagTableViewCell.identifier)
        return view
    }()

    // MARK: Control properties
    
    // MARK: View model
    
    var sections: [SettingsSection] = []
    
    // MARK: Initializers
    
    override init(nibName nibSettingsOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibSettingsOrNil, bundle: nibBundleOrNil)
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
        
        // Table
        view.addSubview(table)
        
        // Constraints
        setupConstraints()
    }
    
    // MARK: Constraints
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Self
            
            // Table
            table.topAnchor.constraint(equalTo: view.topAnchor),
            table.leftAnchor.constraint(equalTo: view.leftAnchor),
            table.rightAnchor.constraint(equalTo: view.rightAnchor),
            table.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interactor?.read()
    }
    
    // MARK: Action

    // MARK: Animation
    
    // MARK: Navigation
    
    func pageWillDisapear() {
        
    }
    
}

extension SettingsViewController {
    
    // MARK: Clean setup
    
    private func cleanSetup() {
        let viewController = self
        let interactor = SettingsInteractor()
        let presenter = SettingsPresenter()
        let router = SettingsRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.interactor = interactor
    }
    
}

extension SettingsViewController: SettingsViewInput {
    
    // Update
    
    func loadSections(sections: [SettingsSection]) {
        self.sections = sections
        
        table.reloadData()
    }
    
    func reloadSections(changes: SectionChanges, sections: [SettingsSection]) {
        self.sections = sections
        
        table.performBatchUpdates({
            table.deleteSections(changes.deletes, with: .automatic)
            table.insertSections(changes.inserts, with: .automatic)
            
            table.reloadRows(at: changes.updates.reloads, with: .automatic)
            table.insertRows(at: changes.updates.inserts, with: .automatic)
            table.deleteRows(at: changes.updates.deletes, with: .automatic)
        }, completion: nil)
    }
    
}
