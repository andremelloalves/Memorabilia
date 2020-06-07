//
//  SettingsViewController.swift
//  Memorabilia
//
//  Created by André Mello Alves on 08/04/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import UIKit
import Photos
import MobileCoreServices

protocol SettingsViewInput: class {

    // Update
    
    func load(_ sections: [SettingsSection])
    
    func reload(_ sections: [SettingsSection], with changes: SectionChanges)
    
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
        view.allowsSelection = true
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
        view.register(ColorTableViewCell.self, forCellReuseIdentifier: ColorTableViewCell.identifier)
        view.register(ButtonTableViewCell.self, forCellReuseIdentifier: ButtonTableViewCell.identifier)
        view.register(MessageTableViewCell.self, forCellReuseIdentifier: MessageTableViewCell.identifier)
        view.register(FlagTableViewCell.self, forCellReuseIdentifier: FlagTableViewCell.identifier)
        return view
    }()
    
    var chooseButton: PillButton?
    
    var deleteButton: PillButton?

    // MARK: Control properties

    // MARK: Media properties
    
    lazy var photoPicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.imageExportPreset = .compatible
        picker.mediaTypes = [kUTTypeImage as String]
        picker.sourceType = .photoLibrary
        return picker
    }()
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        interactor?.read()
    }
    
    // MARK: Action
    
    @objc func chooseButtonAction() {
        routeToPicker()
    }
    
    @objc func deleteButtonAction() {
        menu?.background.image = nil

        interactor?.deleteBackground()
    }

    // MARK: Animation
    
    // MARK: Navigation
    
    func pageWillDisapear() {
        
    }
    
    private func routeToPicker() {
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                DispatchQueue.main.async {
                    self.menu?.present(self.photoPicker, animated: true, completion: nil)
                }
            default:
                DispatchQueue.main.async {
                    self.menu?.showActionView(symbol: "exclamationmark.triangle.fill", text: "Sem acesso a fotos", duration: 2)
                }
            }
        }
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
    
    func load(_ sections: [SettingsSection]) {
        self.sections = sections
        
        table.reloadData()
    }
    
    func reload(_ sections: [SettingsSection], with changes: SectionChanges) {
        self.sections = sections
        
        table.performBatchUpdates({
            table.deleteSections(changes.deletes, with: .fade)
            table.insertSections(changes.inserts, with: .fade)
            
            table.reloadRows(at: changes.updates.reloads, with: .none)
            table.insertRows(at: changes.updates.inserts, with: .none)
            table.deleteRows(at: changes.updates.deletes, with: .none)
        }, completion: nil)
    }
    
}
