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
    
    let mediaButton: CircleButton = {
        let button = CircleButton()
        button.setImage(UIImage(systemName: "square.and.arrow.down.fill"), for: .normal)
        button.addTarget(self, action: #selector(mediaButtonAction), for: .primaryActionTriggered)
        return button
    }()
    
    let snapshotButton: CircleButton = {
        let button = CircleButton()
        button.setImage(UIImage(systemName: "largecircle.fill.circle"), for: .normal)
        button.addTarget(self, action: #selector(snapshotButtonAction), for: .primaryActionTriggered)
        let configuration = UIImage.SymbolConfiguration(pointSize: 64, weight: .regular, scale: .medium)
        button.setPreferredSymbolConfiguration(configuration, forImageIn: .normal)
        button.layer.cornerRadius = 40
        button.background.removeFromSuperview()
        button.removeConstraints(button.constraints)
        return button
    }()
    
    lazy var textInput: InputTextView = {
        let view = InputTextView()
        view.delegate = self
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
    
    // MARK: Control properties
    
    var selectedOption: ReminderType = .text
    
    var selectedReminder: ReminderAnchor?
    
    var canTakeSnapshot: Bool {
        interactor?.readReminderCount() ?? 0 > 0
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
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap)
        let press = UILongPressGestureRecognizer(target: self, action: #selector(handlePress))
        view.addGestureRecognizer(press)
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        view.addGestureRecognizer(pan)
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch))
        view.addGestureRecognizer(pinch)
        let rotation = UIRotationGestureRecognizer(target: self, action: #selector(handleRotation))
        view.addGestureRecognizer(rotation)
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
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
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
        
        // Media button
        view.addSubview(mediaButton)
        
        // Snapshot button
        view.addSubview(snapshotButton)
        
        // Text input
        view.addSubview(textInput)
        
        // Options bar
        view.addSubview(optionsBar)
        
        // Action view
        view.addSubview(actionView)
        
        // Keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Constraints
        setupConstraints()
    }
    
    // MARK: Constraints
    
    lazy var bottomAnchor: NSLayoutConstraint = {
        deleteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
    }()
    
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
            bottomAnchor,
            deleteButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16),
            
            // Media button
            mediaButton.bottomAnchor.constraint(equalTo: deleteButton.bottomAnchor),
            mediaButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16),
            
            // Snapshot button
            snapshotButton.heightAnchor.constraint(equalToConstant: 80),
            snapshotButton.widthAnchor.constraint(equalToConstant: 80),
            snapshotButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            snapshotButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            // Text input
            textInput.heightAnchor.constraint(equalToConstant: 40),
            textInput.leftAnchor.constraint(equalTo: deleteButton.rightAnchor, constant: 16),
            textInput.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16),
            textInput.bottomAnchor.constraint(equalTo: deleteButton.bottomAnchor),
            
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
        selectedReminder = nil
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
        textInput.text = selectedReminder?.name
        hideView(view: exitButton, hidden: isTakingSnapshot || isEditingReminder)
        hideView(view: backButton, hidden: !(isTakingSnapshot || isEditingReminder))
        hideView(view: finishButton, hidden: !canTakeSnapshot || isTakingSnapshot || isEditingReminder)
        hideView(view: deleteButton, hidden: !isEditingReminder)
        hideView(view: mediaButton, hidden: !isEditingReminder || selectedReminder?.type == .some(.text))
        hideView(view: snapshotButton, hidden: !isTakingSnapshot)
        hideView(view: textInput, hidden: !(isEditingReminder && selectedReminder?.type == .some(.text)))
        hideView(view: optionsBar, hidden: isTakingSnapshot || isEditingReminder)
    }
    
    func hideView(view: UIView, hidden: Bool) {
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            view.isHidden = hidden
        })
    }
    
    // MARK: Control
    
    func controlMediaPlayback(with identifier: String?, play: Bool = true) {
        guard let identifier = identifier else { return }
        guard let reminder = interactor?.readReminder(identifier: identifier) else { return }
        
        if let video = reminder as? VideoReminder, let player = video.player {
            if player.timeControlStatus == .playing || !play {
                player.pause()
            } else {
                player.play()
            }
        } else if let audio = reminder as? AudioReminder, let player = audio.player {
            if player.isPlaying || !play {
                player.pause()
            } else {
                player.play()
            }
        }
    }
    
    // MARK: Action
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        guard !isTakingSnapshot else { return }
        guard !isRelocalizingMap else { return }
        
        let point = sender.location(in: arView)
        
        if let node = arView.hitTest(point).first?.node, let anchor = arView.anchor(for: node) as? ReminderAnchor {
            controlMediaPlayback(with: selectedReminder?.identifier.uuidString, play: false)
            selectedReminder = anchor
            showEditing()
        } else {
            guard !isEditingReminder else { return }
            guard let query = arView.raycastQuery(from: point, allowing: .estimatedPlane, alignment: .any) else { return }
            guard let raycast = arView.session.raycast(query).first else { return }
            addReminderAnchor(with: raycast)
        }
    }
    
    @objc func handlePress(_ sender: UILongPressGestureRecognizer) {
        guard let anchor = selectedReminder else { return }
        
        switch sender.state {
        case .began:
            controlMediaPlayback(with: anchor.identifier.uuidString)
        default:
            return
        }
    }
    
    @objc func handlePinch(_ sender: UIPinchGestureRecognizer) {
        guard let anchor = selectedReminder else { return }
        guard let node = arView.node(for: anchor) else { return }
        
        switch sender.state {
        case .changed:
            let scale = Float(sender.scale)
            
            node.scale = SCNVector3(scale * node.scale.x, scale * node.scale.y, scale * node.scale.z)
            
            sender.scale = 1
        default:
            return
        }
    }
    
    var angles: SCNVector3 = SCNVector3(0, 0, 0)
    
    @objc func handlePan(_ sender: UIPanGestureRecognizer) {
        guard let anchor = selectedReminder else { return }
        guard let node = arView.node(for: anchor) else { return }
        
        switch sender.state {
        case .began:
            angles = node.eulerAngles
        case .changed:
            let translation = sender.translation(in: sender.view)
            
            let x = Float(translation.y) * .pi / 180
            let y = Float(translation.x) * .pi / 180
            
            node.eulerAngles = SCNVector3(angles.x + x, angles.y + y, angles.z)
        default:
            return
        }
    }
    
    @objc func handleRotation(_ sender: UIRotationGestureRecognizer) {
        guard let anchor = selectedReminder else { return }
        guard let node = arView.node(for: anchor) else { return }
        
        switch sender.state {
        case .began:
            angles = node.eulerAngles
        case .changed:
            let rotation = Float(sender.rotation)
            
            node.eulerAngles = SCNVector3(angles.x, angles.y, angles.z - rotation)
        default:
            return
        }
    }
    
    @objc func infoButtonAction() {
        infoView.info = "Esse texto informativo pode ocupar mais de uma linha se preciso."
    }
    
    @objc func exitButtonAction() {
        routeBack()
    }
    
    @objc func backButtonAction() {
        controlMediaPlayback(with: selectedReminder?.identifier.uuidString, play: false)
        showCreating()
    }
    
    @objc func finishButtonAction() {
        showSaving()
    }
    
    @objc func deleteButtonAction() {
        removeReminderAnchor()
        showCreating()
    }
    
    @objc func mediaButtonAction() {
        reminderMediaAction()
    }
    
    @objc func snapshotButtonAction() {
        saveARWorld()
    }
    
    func reminderMediaAction() {
        let picker: UIViewController
        
        switch selectedReminder?.type {
        case .photo:
            picker = photoPicker
        case .video:
            picker = videoPicker
        case .audio:
            picker = audioPicker
        default:
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
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        let height = value.cgRectValue.size.height
        
        UIView.animate(withDuration: duration) {
            self.bottomAnchor.constant = self.view.safeAreaInsets.bottom - height - 16
            self.view.layoutIfNeeded()
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        UIView.animate(withDuration: duration) {
            self.bottomAnchor.constant = -16
            self.view.layoutIfNeeded()
        }
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
        
        interactor?.createReminder(identifier: anchor.identifier.uuidString, type: selectedOption, name: nil)
        arView.session.add(anchor: anchor)
        
        selectedReminder = anchor
        showEditing()
    }
    
    func updateReminderAnchor(name: String?) {
        guard let reminder = selectedReminder else { return }
        let anchor = ReminderAnchor(name: name, type: reminder.type, transform: reminder.transform)
        
        interactor?.deleteReminder(identifier: reminder.identifier.uuidString)
        arView.session.remove(anchor: reminder)
        
        interactor?.createReminder(identifier: anchor.identifier.uuidString, type: reminder.type, name: name)
        arView.session.add(anchor: anchor)
        
        selectedReminder = anchor
        showEditing()
    }
    
    func removeReminderAnchor() {
        guard let anchor = selectedReminder else { return }
        
        interactor?.deleteReminder(identifier: anchor.identifier.uuidString)
        arView.session.remove(anchor: anchor)
        
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
