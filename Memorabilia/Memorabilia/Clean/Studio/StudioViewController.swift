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
import MediaPlayer
import MobileCoreServices

protocol StudioViewInput: class {
    
}

class StudioViewController: UIViewController {
    
    // MARK: Clean Properties
    
    var interactor: StudioInteractorInput?
    
    var router: (StudioRouterInput & StudioRouterOutput)?
    
    // MARK: View properties
    
    let exitButton: CircleButton = {
        let button = CircleButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.addTarget(self, action: #selector(exitButtonAction), for: .primaryActionTriggered)
        return button
    }()
    
    let backButton: CircleButton = {
        let button = CircleButton()
        button.setImage(UIImage(systemName: "arrow.turn.up.left"), for: .normal)
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
    
    let deleteButton: CircleButton = {
        let button = CircleButton()
        button.setImage(UIImage(systemName: "trash.fill"), for: .normal)
        button.addTarget(self, action: #selector(deleteButtonAction), for: .primaryActionTriggered)
        return button
    }()
    
    let editButton: CircleButton = {
        let button = CircleButton()
        button.setImage(UIImage(systemName: "square.and.arrow.down.fill"), for: .normal)
        button.addTarget(self, action: #selector(editButtonAction), for: .primaryActionTriggered)
        return button
    }()
    
    let snapshotButton: CircleButton = {
        let button = CircleButton()
        button.setImage(UIImage(systemName: "largecircle.fill.circle"), for: .normal)
        button.addTarget(self, action: #selector(snapshotButtonAction), for: .primaryActionTriggered)
        let configuration = UIImage.SymbolConfiguration(pointSize: 64, weight: .regular, scale: .medium)
        button.setPreferredSymbolConfiguration(configuration, forImageIn: .normal)
        button.layer.cornerRadius = 40
        button.removeConstraints(button.constraints)
        return button
    }()
    
    let textInput: InputTextView = {
        let view = InputTextView()
        view.placeholder = "Digite aqui"
        return view
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
    
    // MARK: Media properties
    
    lazy var photoPicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = false
        picker.imageExportPreset = .compatible
        picker.mediaTypes = [kUTTypeImage as String]
        picker.sourceType = .photoLibrary
        return picker
    }()
    
    lazy var videoPicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = false
        picker.videoExportPreset = AVAssetExportPresetMediumQuality
        picker.mediaTypes = [kUTTypeMovie as String]
        picker.sourceType = .photoLibrary
        return picker
    }()
    
    lazy var audioPicker: MPMediaPickerController = {
        let picker = MPMediaPickerController(mediaTypes: .music)
        picker.delegate = self
        picker.allowsPickingMultipleItems = false
        picker.showsCloudItems = false
        picker.showsItemsWithProtectedAssets = false
        return picker
    }()
    
    var player: AVPlayer?
    
    // MARK: Control properties
    
    var reminderCount: Int = 0
    
    var selectedOption: ReminderType = .text
    
    var selectedReminder: ReminderAnchor?
    
    var canTakeSnapshot: Bool {
        reminderCount > 0
    }
    
    var isTakingSnapshot: Bool = false
    
    var isEditingReminder: Bool = false
    
    var isRelocalizingMap: Bool = false
    
    // MARK: AR properties
    
    lazy var arView: ARSCNView = {
        let view = ARSCNView(frame: self.view.frame)
        view.delegate = self
        view.session.delegate = self
        view.autoenablesDefaultLighting = true
//        view.debugOptions = [.showFeaturePoints, .showWorldOrigin]
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
        
        // Exit button
        view.addSubview(exitButton)
        
        // Back button
        view.addSubview(backButton)
        
        // Info view
        view.addSubview(infoView)
        
        // Info button
        view.addSubview(infoButton)
        
        // Finish button
        view.addSubview(finishButton)
        
        // Delete button
        view.addSubview(deleteButton)
        
        // Edit button
        view.addSubview(editButton)
        
        // Snapshot button
        view.addSubview(snapshotButton)
        
        // Text input
        view.addSubview(textInput)
        
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
            
            // Exit button
            exitButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            exitButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16),
            
            // Back button
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            backButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16),
            
            // Info view
            infoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            infoView.leftAnchor.constraint(equalTo: exitButton.rightAnchor, constant: 16),
            infoView.rightAnchor.constraint(equalTo: infoButton.leftAnchor, constant: -16),
            
            // Info button
            infoButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            infoButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16),
            
            // Finish button
            finishButton.bottomAnchor.constraint(equalTo: optionsBar.topAnchor, constant: -16),
            finishButton.widthAnchor.constraint(equalToConstant: 120),
            finishButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            // Delete button
            deleteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            deleteButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16),
            
            // Edit button
            editButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            editButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16),
            
            // Snapshot button
            snapshotButton.heightAnchor.constraint(equalToConstant: 80),
            snapshotButton.widthAnchor.constraint(equalToConstant: 80),
            snapshotButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            snapshotButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            // Text input
            textInput.heightAnchor.constraint(equalToConstant: 40),
            textInput.leftAnchor.constraint(equalTo: deleteButton.rightAnchor, constant: 16),
            textInput.rightAnchor.constraint(equalTo: editButton.leftAnchor, constant: -16),
            textInput.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
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
        showCreating()
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
    
    // MARK: View
    
    func showCreating() {
        isTakingSnapshot = false
        isEditingReminder = false
        updateLayout()
    }
    
    func showEditing() {
        isTakingSnapshot = false
        isEditingReminder = true
        updateLayout()
    }
    
    func showSaving() {
        isTakingSnapshot = true
        isEditingReminder = false
        updateLayout()
    }
    
    func updateLayout() {
        hideView(view: exitButton, hidden: isTakingSnapshot || isEditingReminder)
        hideView(view: backButton, hidden: !(isTakingSnapshot || isEditingReminder))
        hideView(view: finishButton, hidden: !canTakeSnapshot || isTakingSnapshot || isEditingReminder)
        hideView(view: deleteButton, hidden: !isEditingReminder)
        hideView(view: editButton, hidden: !isEditingReminder)
        hideView(view: snapshotButton, hidden: !isTakingSnapshot)
        hideView(view: textInput, hidden: !(isEditingReminder && selectedReminder?.type == .some(.text)))
        hideView(view: optionsBar, hidden: isTakingSnapshot || isEditingReminder)
    }
    
    func hideView(view: UIView, hidden: Bool) {
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            view.isHidden = hidden
        })
    }
    
    // MARK: Action
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        guard !isTakingSnapshot else { return }
        guard !isRelocalizingMap else { return }
        
        let point = sender.location(in: arView)
        
        if let node = arView.hitTest(point).first?.node, let reminder = arView.anchor(for: node) as? ReminderAnchor {
            selectedReminder = reminder
            showEditing()
        } else {
            guard !isEditingReminder else { return }
            guard let query = arView.raycastQuery(from: point, allowing: .estimatedPlane, alignment: .any) else { return }
            guard let raycast = arView.session.raycast(query).first else { return }
            addReminderAnchor(with: raycast)
        }
    }
    
    @objc func infoButtonAction() {
        infoView.info = "Esse texto informativo pode ocupar mais de uma linha se preciso."
    }
    
    @objc func exitButtonAction() {
        routeBack()
    }
    
    @objc func backButtonAction() {
        showCreating()
    }
    
    @objc func finishButtonAction() {
        showSaving()
    }
    
    @objc func deleteButtonAction() {
        removeReminderAnchor(selectedReminder)
        showCreating()
    }
    
    @objc func editButtonAction() {
        reminderEditAction()
    }
    
    @objc func snapshotButtonAction() {
        saveARWorld()
    }
    
    func reminderEditAction() {
        let picker: UIViewController
        
        switch selectedReminder?.type {
        case .text:
            return
        case .photo:
            picker = photoPicker
        case .video:
            picker = videoPicker
        case .audio:
            picker = audioPicker
        case .none:
            return
        }
        
        present(picker, animated: true, completion: nil)
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
    
    func addReminderAnchor(with raycast: ARRaycastResult) {
        let anchor = ReminderAnchor(type: selectedOption, transform: raycast.worldTransform)
        arView.session.add(anchor: anchor)
        selectedReminder = anchor
        reminderCount += 1
        showEditing()
    }
    
    func removeReminderAnchor(_ anchor: ARAnchor?) {
        guard let anchor = anchor else { return }
        arView.session.remove(anchor: anchor)
        reminderCount -= 1
        showCreating()
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
