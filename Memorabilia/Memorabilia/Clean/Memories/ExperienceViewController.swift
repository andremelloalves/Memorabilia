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
    
    func loadPhoto(_ photo: Data)
    
    func loadARWorld(_ world: Data)
    
    func reloadReminder(identifier: String)
    
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
    
    // MARK: Control properties
    
    var selectedReminder: ReminderAnchor?
    
    var isRelocalizingMap: Bool = false
    
    // MARK: AR properties
    
    var world: ARWorldMap?
        
    lazy var arView: ARSCNView = {
        let view = ARSCNView(frame: self.view.frame)
        view.delegate = self
        view.session.delegate = self
        view.autoenablesDefaultLighting = true
//        view.debugOptions = [.showFeaturePoints, .showWorldOrigin]
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    lazy var worldTrackingConfiguration: ARWorldTrackingConfiguration = {
        let configuration = ARWorldTrackingConfiguration()
        configuration.environmentTexturing = .automatic
        configuration.initialWorldMap = world
        configuration.planeDetection = .vertical
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
        guard !isRelocalizingMap else { return }
        
        let point = sender.location(in: arView)
        
        if let node = arView.hitTest(point).first?.node, let anchor = arView.anchor(for: node) as? ReminderAnchor {
            guard selectedReminder?.identifier != anchor.identifier else { return }
            
            controlMediaPlayback(with: selectedReminder?.identifier.uuidString, play: false)
            controlMediaPlayback(with: anchor.identifier.uuidString)
            selectedReminder = anchor
        } else {
            controlMediaPlayback(with: selectedReminder?.identifier.uuidString, play: false)
            selectedReminder = nil
        }
    }
    
    @objc func infoButtonAction() {
        infoView.info = "Esse texto informativo pode ocupar mais de uma linha se preciso."
    }
    
    @objc func exitButtonAction() {
        routeBack()
    }
    
    @objc func restartButtonAction() {
        infoView.info = "O mundo AR será reiniciado."
    }
    
    // MARK: Navigation
    
    func routeBack() {
        router?.routeBack()
    }
    
    // MARK: AR

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
            guard let worldMap = try NSKeyedUnarchiver.unarchivedObject(ofClass: ARWorldMap.self, from: world)
                else { fatalError("No ARWorldMap in archive.") }
            
            var anchors = worldMap.anchors
            anchors.removeAll(where: { $0 is SnapshotAnchor })
            
            self.world = worldMap
            
            guard let reminderAnchors = anchors.filter({ $0.isMember(of: ReminderAnchor.self) }) as? [ReminderAnchor] else { return }
            let reminders = reminderAnchors.map({ ExperienceEntity.Fetch(identifier: $0.identifier.uuidString, type: $0.type, name: $0.name)})
            interactor?.createReminders(reminders)
            interactor?.readVisualReminders()
            
            arView.session.run(worldTrackingConfiguration, options: [.resetTracking, .removeExistingAnchors])
        } catch let error {
            fatalError("Can't unarchive ARWorldMap from file data: \(error)")
        }
    }
    
    func reloadReminder(identifier: String) {
        guard let anchor = world?.anchors.first(where: { $0.identifier.uuidString == identifier }) else { return }
        
        arView.session.remove(anchor: anchor)
        arView.session.add(anchor: anchor)
    }
    
}
