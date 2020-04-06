//
//  ExperienceViewController.swift
//  Memorabilia
//
//  Created by André Mello Alves on 15/03/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import UIKit
import ARKit
import RealityKit

protocol ExperienceViewInput: class {
    
    // Update
    
    func loadPhoto(_ photo: Data)
    
    func loadARWorld(_ world: Data)
    
}

class ExperienceViewController: UIViewController {
    
    // MARK: Clean Properties
    
    var interactor: ExperienceInteractorInput?
    
    var router: (ExperienceRouterInput & ExperienceRouterOutput)?
    
    // MARK: View properties
    
    let backButton: CircleButton = {
        let button = CircleButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.addTarget(self, action: #selector(backButtonAction), for: .primaryActionTriggered)
        return button
    }()
    
    let infoView: InfoView = {
        let view = InfoView()
        view.infoLabel.text = "Aqui aparecem mensagens de status do AR para auxiliar o usuário no momento de mapeamento."
        return view
    }()
    
    let infoButton: CircleButton = {
        let button = CircleButton()
        button.setImage(UIImage(systemName: "info"), for: .normal)
        button.addTarget(self, action: #selector(infoButtonAction), for: .primaryActionTriggered)
        return button
    }()
    
    let restartButton: CircleButton = {
        let button = CircleButton()
        button.setImage(UIImage(systemName: "arrow.counterclockwise"), for: .normal)
        button.addTarget(self, action: #selector(restartButtonAction), for: .primaryActionTriggered)
        return button
    }()
    
    lazy var snapshotView: SnapshotView = {
        let view = SnapshotView(frame: self.view.frame)
        return view
    }()
    
    let actionView: ActionView = {
        let view = ActionView()
        view.symbol = "rectangle.3.offgrid.fill"
        view.text = "Retorno visual"
        view.alpha = 0
        return view
    }()
    
    // MARK: AR properties
    
    var world: ARWorldMap?
        
    lazy var arView: ARView = {
        let view = ARView(frame: self.view.frame)
        view.session.delegate = self
        view.debugOptions = [.showFeaturePoints]
        return view
    }()
    
    lazy var worldTrackingConfiguration: ARWorldTrackingConfiguration = {
        let configuration = ARWorldTrackingConfiguration()
        configuration.environmentTexturing = .automatic
        configuration.initialWorldMap = world
        configuration.planeDetection = .vertical
        return configuration
    }()
    
    var isRelocalizingMap: Bool = false
    
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
    
    func setup() {
        // Self
        view.backgroundColor = .systemBackground
        
        // AR view
        view.addSubview(arView)
        
        // Back button
        view.addSubview(backButton)
        
        // Info view
        view.addSubview(infoView)
        
        // Info button
        view.addSubview(infoButton)
        
        // Restart button
        view.addSubview(restartButton)
        
        // Snapshot view
        view.addSubview(snapshotView)
        
        // Action view
        view.addSubview(actionView)
        
        // Constraints
        setupConstraints()
    }
    
    // MARK: Constraints
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            // AR view
            arView.topAnchor.constraint(equalTo: view.topAnchor),
            arView.leftAnchor.constraint(equalTo: view.leftAnchor),
            arView.rightAnchor.constraint(equalTo: view.rightAnchor),
            arView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Back button
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            backButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16),
            
            // Info view
            infoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            infoView.leftAnchor.constraint(equalTo: backButton.rightAnchor, constant: 16),
            infoView.rightAnchor.constraint(equalTo: infoButton.leftAnchor, constant: -16),
            
            // Info button
            infoButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            infoButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16),
            
            // Restart button
            restartButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16),
            restartButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            // Snapshot view
            snapshotView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16),
            snapshotView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            // Action view
            actionView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            actionView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
        ])
    }
    
    // MARK: View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        interactor?.readMemoryPhoto()
        interactor?.readARWorld()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // AR support
        guard ARWorldTrackingConfiguration.isSupported else { fatalError("ARKit is not available on this device.") }

        // Screen dimming
        UIApplication.shared.isIdleTimerDisabled = true
        
        // Start AR Session
//        arView.session.run(worldTrackingConfiguration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause AR Session
        arView.session.pause()
    }
    
    // MARK: Action
    
    @objc func infoButtonAction() {
        infoView.info = "Esse texto informativo pode ocupar mais de uma linha se preciso."
    }
    
    @objc func backButtonAction() {
        routeBack()
    }
    
    @objc func restartButtonAction() {
        
    }
    
    // MARK: Navigation
    
    func routeBack() {
        router?.routeBack()
    }
    
    // MARK: AR
    
    func startARSession() {
        
    }

}

extension ExperienceViewController {
    
    // MARK: Clean setup
    
    private func cleanSetup() {
        let viewController = self
        let interactor = ExperienceInteractor()
        let presenter = ExperiencePresenter()
        let router = ExperienceRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.interactor = interactor
    }
    
}

extension ExperienceViewController: ExperienceViewInput {
    
    // Update
    
    func loadPhoto(_ photo: Data) {
        snapshotView.image = UIImage(data: photo)
    }
    
    func loadARWorld(_ world: Data) {
        do {
            guard let worldMap = try NSKeyedUnarchiver.unarchivedObject(ofClass: ARWorldMap.self, from: world) else { fatalError("No ARWorldMap in archive.") }
            worldMap.anchors.removeAll(where: { $0 is SnapshotAnchor })
            self.world = worldMap
            arView.session.run(worldTrackingConfiguration, options: [.resetTracking, .removeExistingAnchors])
        } catch let error {
            fatalError("Can't unarchive ARWorldMap from file data: \(error)")
        }
    }
    
}
