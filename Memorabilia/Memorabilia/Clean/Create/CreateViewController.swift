//
//  CreateViewController.swift
//  Memorabilia
//
//  Created by André Mello Alves on 08/04/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import UIKit
import ARKit
import Photos
import MobileCoreServices

protocol CreateViewInput: class {

    // Update
    
    func loadSections(sections: [CreateSection])
    
}

class CreateViewController: UIViewController, MenuPage {
    
    // MARK: Menu page
    
    var menu: MenuController?
    
    var type: MenuPageType = .create
    
    // MARK: Clean Properties
    
    var interactor: CreateInteractorInput?
    
    var router: (CreateRouterInput & CreateRouterOutput)?
    
    // MARK: View properties
    
    lazy var table: UITableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        view.backgroundColor = .clear
        view.allowsSelection = false
        view.dataSource = self
        view.delegate = self
        view.estimatedRowHeight = 40
        view.estimatedSectionHeaderHeight = 60
        let insets = UIEdgeInsets(top: 72, left: 0, bottom: 72, right: 0)
        view.contentInset = insets
        view.scrollIndicatorInsets = insets
        view.separatorStyle = .none
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(TableViewHeaderView.self, forHeaderFooterViewReuseIdentifier: TableViewHeaderView.identifier)
        view.register(TextInputTableViewCell.self, forCellReuseIdentifier: TextInputTableViewCell.identifier)
        view.register(ImageInputTableViewCell.self, forCellReuseIdentifier: ImageInputTableViewCell.identifier)
        view.register(SpacingTableViewCell.self, forCellReuseIdentifier: SpacingTableViewCell.identifier)
        view.register(ButtonTableViewCell.self, forCellReuseIdentifier: ButtonTableViewCell.identifier)
        return view
    }()
    
    var nameInput: InputTextView?
    
    var coverInput: PillButton?
    
    var studioButton: PillButton?

    // MARK: Control properties
    
    var selectedCover: UIImage?

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
    
    var sections: [CreateSection] = []
    
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
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap)
        
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
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        nameInput?.resignFirstResponder()
    }
    
    @objc func coverInputButtonAction() {
        nameInput?.resignFirstResponder()
        routeToPicker()
    }
    
    @objc func studioButtonAction() {
        if let name = nameInput?.text, let cover = selectedCover?.pngData(), !name.isEmpty {
            routeToStudio(name: name, cover: cover)
            nameInput?.text = nil
            coverInput?.update(title: "Escolha uma foto de capa aqui", image: nil)
        } else {
            // Alert
        }
    }

    // MARK: Animation
    
    // MARK: Navigation
    
    func pageWillDisapear() {
        nameInput?.resignFirstResponder()
    }
    
    private func routeToPicker() {
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                DispatchQueue.main.async {
                    self.menu?.present(self.photoPicker, animated: true, completion: nil)
                }
            default:
//                self.showActionView()
                break
            }
        }
    }
    
    private func routeToStudio(name: String, cover: Data) {
        if ARWorldTrackingConfiguration.isSupported {
            router?.routeToStudioViewController(name: name, cover: cover)
        } else {
//            self.showActionView()
        }
    }
    
}

extension CreateViewController {
    
    // MARK: Clean setup
    
    private func cleanSetup() {
        let viewController = self
        let interactor = CreateInteractor()
        let presenter = CreatePresenter()
        let router = CreateRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.interactor = interactor
    }
    
}

extension CreateViewController: CreateViewInput {
    
    // Update
    
    func loadSections(sections: [CreateSection]) {
        self.sections = sections
        
        table.reloadData()
    }
    
}
