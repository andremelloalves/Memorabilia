//
//  ExperienceViewController.swift
//  Memorabilia
//
//  Created by André Mello Alves on 15/03/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import UIKit
import ARKit
import SceneKit
import MediaPlayer
import MobileCoreServices

protocol ExperienceViewInput: class {
    
    // Update
    
    func loadSnapshot(with data: Data)
    
    func loadWorld(with data: Data)
    
    func reloadReminder(with identifier: String)
    
}

class ExperienceViewController: UIViewController {
    
    // MARK: Clean Properties
    
    var interactor: ExperienceInteractorInput?
    
    var router: (ExperienceRouterInput & ExperienceRouterOutput)?
    
    // MARK: View properties
    
    let exitButton: CircleButton = {
        let button = CircleButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.addTarget(self, action: #selector(exitButtonAction), for: .primaryActionTriggered)
        return button
    }()
    
    let infoView: InfoView = {
        let view = InfoView()
        let state = ARCamera.TrackingState.limited(.initializing)
        view.update(title: state.description, info: state.feedback)
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
        view.alpha = 0
        return view
    }()
    
    // MARK: Control properties
    
    var selectedInfo: InformationType = .experienceLocation
    
    var selectedReminder: ReminderAnchor?
    
    var isLimited: Bool = true
    
    // MARK: AR properties
    
    var world: ARWorldMap?
        
    lazy var arView: ARSCNView = {
        let view = ARSCNView(frame: self.view.frame)
        view.delegate = self
        view.session.delegate = self
        view.autoenablesDefaultLighting = true
        view.debugOptions = [.showFeaturePoints]
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    lazy var worldTrackingConfiguration: ARWorldTrackingConfiguration = {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .vertical
        configuration.initialWorldMap = world
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
            
            // Exit button
            exitButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            exitButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16),
            
            // Info view
            infoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            infoView.leftAnchor.constraint(equalTo: exitButton.rightAnchor, constant: 16),
            infoView.rightAnchor.constraint(equalTo: infoButton.leftAnchor, constant: -16),
            
            // Info button
            infoButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            infoButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16),
            
            // Restart button
            restartButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16),
            restartButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            // Action view
            actionView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            actionView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    // MARK: View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        interactor?.readSnapshot()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // AR support
        guard ARWorldTrackingConfiguration.isSupported else { routeBack(); return }

        // Screen dimming
        UIApplication.shared.isIdleTimerDisabled = true
        
        // Start AR Session
        requestStart()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Screen dimming
        UIApplication.shared.isIdleTimerDisabled = false
        
        // Pause AR Session
        arView.session.pause()
    }
    
    // MARK: Control
    
    func controlMediaPlayback(for anchor: ARAnchor?, play: Bool = true) {
        guard let anchor = anchor,
            let node = arView.node(for: anchor),
            let reminder = interactor?.readReminder(with: anchor.identifier.uuidString) else { return }
        
        if let video = reminder as? VideoReminder, let player = video.player {
            if player.timeControlStatus == .playing || !play {
                player.pause()
                player.seek(to: .zero)
            } else {
                player.play()
            }
        } else if let audio = reminder as? AudioReminder, let player = audio.player {
            if player.isPlaying || !play {
                player.pause()
                animate(node, play: false)
            } else {
                player.play(atTime: .zero)
                animate(node, play: true)
            }
        }
    }
    
    func updateState(isLimited: Bool) {
        self.isLimited = isLimited
        snapshotView.isHidden = !isLimited
        if isLimited {
            arView.debugOptions = [.showFeaturePoints]
        } else {
            arView.debugOptions = []
        }
    }
    
    // MARK: Action
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        guard !isLimited else { return }
        
        let point = sender.location(in: arView)
        
        if let node = arView.hitTest(point).first?.node, let anchor = arView.anchor(for: node) as? ReminderAnchor {
            guard selectedReminder?.identifier != anchor.identifier else { return }
            
            controlMediaPlayback(for: selectedReminder, play: false)
            controlMediaPlayback(for: anchor)
            selectedReminder = anchor
        } else {
            controlMediaPlayback(for: selectedReminder, play: false)
            selectedReminder = nil
        }
    }
    
    @objc func infoButtonAction() {
        controlMediaPlayback(for: selectedReminder, play: false)
        routeToInformation()
    }
    
    @objc func exitButtonAction() {
        routeBack()
    }
    
    @objc func restartButtonAction() {
        controlMediaPlayback(for: selectedReminder, play: false)
        selectedReminder = nil
        startSession(shouldRestart: true)
    }
    
    // MARK: Animation
    
    func showAction(with symbol: String, and text: String, for duration: TimeInterval) {
        actionView.update(symbol: symbol, text: text)
        
        let fadeIn = { [unowned self] in self.actionView.alpha = 1 }
        let fadeOut = { [unowned self] in self.actionView.alpha = 0 }
        
        let fadeInAnimator = UIViewPropertyAnimator(duration: duration / 4, curve: .easeInOut, animations: fadeIn)
        let fadeOutAnimator = UIViewPropertyAnimator(duration: duration / 4, curve: .easeInOut, animations: fadeOut)

        fadeInAnimator.startAnimation()
        fadeInAnimator.addCompletion { _ in fadeOutAnimator.startAnimation(afterDelay: duration / 2) }
    }
    
    func animate(_ node: SCNNode, play: Bool) {
        if play {
            let scaleUp = SCNAction.scale(to: 1.5, duration: 0.5)
            let scaleDown = SCNAction.scale(to: 1, duration: 0.5)
            let sequence = SCNAction.sequence([scaleUp, scaleDown])
            let forever = SCNAction.repeatForever(sequence)
            node.runAction(forever)
        } else {
            let scaleDown = SCNAction.scale(to: 1, duration: 0.5)
            node.runAction(scaleDown) {
                node.removeAllActions()
            }
        }
    }
    
    // MARK: Navigation
    
    func routeBack() {
        router?.routeBack()
    }
    
    func routeToInformation() {
        router?.routeToInformation(type: selectedInfo)
    }
    
    // MARK: Request
    
    func requestStart() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            interactor?.readWorld()
        case .denied:
            showAction(with: "exclamationmark.triangle.fill", and: "Sem acesso à camera", for: 2)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    DispatchQueue.main.async {
                        self.interactor?.readWorld()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.showAction(with: "exclamationmark.triangle.fill", and: "Sem acesso à camera", for: 2)
                    }
                }
            }
        default:
            routeBack()
        }
    }
    
    // MARK: AR
    
    func startSession(shouldRestart: Bool = false) {
        var options: ARSession.RunOptions = []
        if shouldRestart {
            options.insert([.resetTracking, .removeExistingAnchors])
        }
        arView.session.run(worldTrackingConfiguration, options: options)
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
    
    func loadSnapshot(with data: Data) {
        snapshotView.image = UIImage(data: data)
    }
    
    func loadWorld(with data: Data) {
        do {
            guard let world = try NSKeyedUnarchiver.unarchivedObject(ofClass: ARWorldMap.self, from: data) else {
                routeBack()
                return
            }
            
            var anchors = world.anchors
            anchors.removeAll(where: { $0 is SnapshotAnchor })
            
            self.world = world
            
            guard let reminderAnchors = anchors.filter({ $0.isMember(of: ReminderAnchor.self) }) as? [ReminderAnchor] else { return }
            let reminders = reminderAnchors.map({ ExperienceEntity.Fetch(identifier: $0.identifier.uuidString, type: $0.type, name: $0.name)})
            interactor?.create(reminders)
            
            startSession(shouldRestart: true)
        } catch let error {
            print(error.localizedDescription)
            routeBack()
        }
    }
    
    func reloadReminder(with identifier: String) {
        guard !isLimited, let anchor = world?.anchors.first(where: { $0.identifier.uuidString == identifier }) else { return }
        
        arView.session.remove(anchor: anchor)
        arView.session.add(anchor: anchor)
    }
    
}
