//
//  CreateViewController.swift
//  Memorabilia
//
//  Created by André Mello Alves on 27/11/19.
//  Copyright © 2019 André Mello Alves. All rights reserved.
//

import UIKit
import ARKit
import RealityKit

protocol CreateViewInput: class {
    
}

class CreateViewController: UIViewController, CreateViewInput {
    
    // MARK: Clean Properties
    
    var interactor: CreateInteractorInput?
    
    var router: (CreateRouterInput & CreateRouterOutput)?
    
    // MARK: View properties
    
    let backButton: CircleButton = {
        let button = CircleButton()
        button.icon.tintColor = .systemBackground
        button.icon.image = UIImage(systemName: "chevron.left.circle.fill")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(backButtonAction), for: .primaryActionTriggered)
        return button
    }()
    
    let infoView: InfoView = {
        let view = InfoView()
        view.label.text = "Aqui aparecem mensagens de status do AR para auxiliar o usuário no momento de mapeamento."
        return view
    }()
    
    let infoButton: CircleButton = {
        let button = CircleButton()
        button.addTarget(self, action: #selector(action), for: .primaryActionTriggered)
        button.icon.tintColor = .systemBackground
        button.icon.image = UIImage(systemName: "info.circle.fill")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: AR properties
    
    lazy var arView: ARView = {
        let view = ARView(frame: self.view.frame)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tap))
        view.addGestureRecognizer(gesture)
        view.session.delegate = self
        view.debugOptions = [.showFeaturePoints]
        return view
    }()
    
    lazy var worldTrackingConfiguration: ARWorldTrackingConfiguration = {
        let configuration = ARWorldTrackingConfiguration()
//        configuration.automaticImageScaleEstimationEnabled = false
//        configuration.detectionImages
//        configuration.detectionObjects
        configuration.environmentTexturing = .automatic
//        configuration.initialWorldMap = .none
//        configuration.isAutoFocusEnabled = true
//        configuration.isCollaborationEnabled = false
//        configuration.maximumNumberOfTrackedImages = 0
        configuration.planeDetection = .vertical
//        configuration.sceneReconstruction = .mesh
//        configuration.userFaceTrackingEnabled = false
//        configuration.wantsHDREnvironmentTextures = false
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
            infoButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16)
        ])
    }
    
    // MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // AR support
        guard ARWorldTrackingConfiguration.isSupported else { fatalError("ARKit is not available on this device.") }

        // Screen dimming
        UIApplication.shared.isIdleTimerDisabled = true

        // Start AR Session
        arView.session.run(worldTrackingConfiguration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause AR Session
        arView.session.pause()
    }
    
    override var shouldAutorotate: Bool {
        false
    }
    
    // MARK: Action
    
    @objc func action() {
        infoView.message = "Esse texto informativo pode ocupar mais de uma linha se preciso."
    }
    
    @objc func tap(_ sender: UITapGestureRecognizer) {
        if isRelocalizingMap {
            return
        }
        
        guard let hitTestResult = arView
            .hitTest(sender.location(in: arView), types: [.existingPlaneUsingGeometry, .estimatedHorizontalPlane])
            .first
            else { return }
        
        infoView.message = String(Float(hitTestResult.distance))
        addSphere(anchor: hitTestResult.anchor)
    }
    
    @objc func backButtonAction() {
        routeBack()
    }
    
    // MARK: Navigation
    
    func routeBack() {
        router?.routeBack()
    }
    
    // MARK: AR
    
    func addSphere(anchor: ARAnchor?) {
//        guard let anchor = anchor else { return }
        
//        let anchorEntity = AnchorEntity(anchor: anchor)
        let anchorEntity = AnchorEntity(plane: .horizontal)
        arView.scene.addAnchor(anchorEntity)
//        arView.scene.anchors.append(anchorEntity)
        
        let sphere = MeshResource.generateSphere(radius: 1)
        let material = SimpleMaterial(color: .blue, isMetallic: false)
        let entity = ModelEntity(mesh: sphere, materials: [material])
        
        anchorEntity.addChild(entity)
        print(arView.scene.anchors.count)
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

extension CreateViewController {
    
    // Update
}
