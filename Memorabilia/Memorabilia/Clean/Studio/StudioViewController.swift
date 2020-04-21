//
//  StudioViewController.swift
//  Memorabilia
//
//  Created by André Mello Alves on 27/11/19.
//  Copyright © 2019 André Mello Alves. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

protocol StudioViewInput: class {
    
}

class StudioViewController: UIViewController {
    
    // MARK: Clean Properties
    
    var interactor: StudioInteractorInput?
    
    var router: (StudioRouterInput & StudioRouterOutput)?
    
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
    
    let finishButton: PillButton = {
        let button = PillButton()
        button.setTitle("Finalizar", for: .normal)
        button.addTarget(self, action: #selector(finishButtonAction), for: .primaryActionTriggered)
        return button
    }()
    
    lazy var textButton: OptionsBarButton = {
        let button = OptionsBarButton()
        button.addAction(optionButtonAction(option: .text))
        button.setImage(UIImage(systemName: ReminderType.text.symbol), for: .normal)
        return button
    }()
    
    lazy var photoButton: OptionsBarButton = {
        let button = OptionsBarButton()
        button.addAction(optionButtonAction(option: .photo))
        button.setImage(UIImage(systemName: ReminderType.photo.symbol), for: .normal)
        return button
    }()
    
    lazy var videoButton: OptionsBarButton = {
        let button = OptionsBarButton()
        button.addAction(optionButtonAction(option: .video))
        button.setImage(UIImage(systemName: ReminderType.video.symbol), for: .normal)
        return button
    }()
    
    lazy var audioButton: OptionsBarButton = {
        let button = OptionsBarButton()
        button.addAction(optionButtonAction(option: .audio))
        button.setImage(UIImage(systemName: ReminderType.audio.symbol), for: .normal)
        return button
    }()
    
    lazy var optionsBar: OptionsBarView = {
        let view = OptionsBarView()
        view.addButton(textButton)
        view.addButton(photoButton)
        view.addButton(videoButton)
        view.addButton(audioButton)
        return view
    }()
    
    let actionView: ActionView = {
        let view = ActionView()
        view.symbol = "rectangle.3.offgrid.fill"
        view.text = "Retorno visual"
        view.alpha = 0
        return view
    }()
    
    // MARK: Control properties
    
    var selectedOption: ReminderType = .text
    
    // MARK: AR properties
    
    lazy var arView: ARSCNView = {
        let view = ARSCNView(frame: self.view.frame)
        view.session.delegate = self
        view.autoenablesDefaultLighting = true
        view.debugOptions = [.showFeaturePoints, .showWorldOrigin]
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(gesture)
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
    
    // MARK: Action
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        guard !isRelocalizingMap else { return }
        let location = sender.location(in: arView)
        guard let query = arView.raycastQuery(from: location, allowing: .estimatedPlane, alignment: .any) else { return }
        guard let raycast = arView.session.raycast(query).first else { return }
        add(raycast: raycast)
    }
    
    @objc func infoButtonAction() {
        infoView.info = "Esse texto informativo pode ocupar mais de uma linha se preciso."
    }
    
    @objc func backButtonAction() {
        routeBack()
    }
    
    @objc func finishButtonAction() {
        saveARWorld()
    }
    
    func optionButtonAction(option: ReminderType) -> () -> () {
        let action = { [weak self] in
            self?.selectedOption = option
            self?.actionView.text = option.name
            self?.actionView.symbol = option.symbol
            self?.showActionView()
        }
        return action
    }
    
    // MARK: Animation
    
    func showActionView() {
        let fadeIn = { [unowned self] in self.actionView.alpha = 1 }
        let fadeOut = { [unowned self] in self.actionView.alpha = 0 }
        
        let fadeInAnimator = UIViewPropertyAnimator(duration: 0.25, curve: .easeInOut, animations: fadeIn)
        let fadeOutAnimator = UIViewPropertyAnimator(duration: 0.25, curve: .easeInOut, animations: fadeOut)

        fadeInAnimator.startAnimation()
        fadeInAnimator.addCompletion { _ in fadeOutAnimator.startAnimation(afterDelay: 0.5) }
    }
    
    // MARK: Navigation
    
    func routeBack() {
        router?.routeBack()
    }
    
    // MARK: AR
    
    func add(raycast: ARRaycastResult) {
        let anchor = ARAnchor(name: AnchorType.text.rawValue, transform: raycast.worldTransform)
        arView.session.add(anchor: anchor)
        
        let sphere = SCNSphere(radius: 0.1)
        sphere.firstMaterial!.diffuse.contents = UIColor.white
        let node = SCNNode(geometry: sphere)
        node.transform = SCNMatrix4(raycast.worldTransform)
        
        arView.scene.rootNode.addChildNode(node)
    }
    
}

extension StudioViewController {
    
    // MARK: Clean setup
    
    private func cleanSetup() {
        let viewController = self
        let interactor = StudioInteractor()
        let presenter = StudioPresenter()
        let router = StudioRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.interactor = interactor
    }
    
}

extension StudioViewController: StudioViewInput {
    
    // Update
}
