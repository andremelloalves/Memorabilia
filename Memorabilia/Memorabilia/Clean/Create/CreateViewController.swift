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

class CreateViewController: UIViewController {
    
    // MARK: Clean Properties
    
    var interactor: CreateInteractorInput?
    
    var router: (CreateRouterInput & CreateRouterOutput)?
    
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
        button.addTarget(self, action: #selector(action), for: .primaryActionTriggered)
        return button
    }()
    
    let finishButton: PillButton = {
        let button = PillButton()
        button.setTitle("Finalizar", for: .normal)
        button.addTarget(self, action: #selector(backButtonAction), for: .primaryActionTriggered)
        return button
    }()
    
    let optionsBar: OptionsBarView = {
        let view = OptionsBarView()
        view.addButton(iconName: "textformat")
        view.addButton(iconName: "photo")
        view.addButton(iconName: "film")
        view.addButton(iconName: "mic")
        return view
    }()
    
    let actionView: ActionView = {
        let view = ActionView()
        view.symbol = "paperplane.fill"
        view.text = "Paperplane"
        return view
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
        
        // Finish button
        view.addSubview(finishButton)
        
        // Options bar
        view.addSubview(optionsBar)
        
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
            
            // Finish button
            finishButton.bottomAnchor.constraint(equalTo: optionsBar.topAnchor, constant: -16),
            finishButton.widthAnchor.constraint(equalToConstant: 120),
            finishButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            // Options bar
            optionsBar.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16),
            optionsBar.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16),
            optionsBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            // Action view
            actionView.widthAnchor.constraint(equalTo: infoView.widthAnchor),
            actionView.heightAnchor.constraint(equalTo: actionView.widthAnchor),
            actionView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            actionView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
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
        infoView.info = "Esse texto informativo pode ocupar mais de uma linha se preciso."
    }
    
    @objc func tap(_ sender: UITapGestureRecognizer) {
        if isRelocalizingMap {
            return
        }
        
        guard let raycast = arView.raycast(from: sender.location(in: arView), allowing: .estimatedPlane, alignment: .any).first else { return }
        guard let hitTestResult = arView
            .hitTest(sender.location(in: arView), types: [.existingPlaneUsingGeometry, .estimatedHorizontalPlane])
            .first
            else { return }
        
        infoView.info = String(Float(hitTestResult.distance))
        //addSphere(anchor: hitTestResult.anchor)
        add(raycast: raycast)
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
    
    func add(raycast: ARRaycastResult) {
        let x = raycast.worldTransform.columns.3.x
        let y = raycast.worldTransform.columns.3.y
        let z = raycast.worldTransform.columns.3.z
        
        let anchorEntity = AnchorEntity()
        anchorEntity.position = [x,y,z]
        
        let sphere = MeshResource.generateSphere(radius: 0.1)
        let material = SimpleMaterial(color: .white, isMetallic: false)
        let entity = ModelEntity(mesh: sphere, materials: [material])
        entity.position = [0,0,0]
        arView.installGestures(.all, for: entity)
        
        anchorEntity.addChild(entity)
        arView.scene.addAnchor(anchorEntity)
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

extension CreateViewController: CreateViewInput {
    
    // Update
}
