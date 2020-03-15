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

class CreateViewController: UIViewController {
    
    // MARK: View properties
    
    let backButton: CircleButton = {
        let button = CircleButton()
        button.icon.tintColor = .systemBackground
        button.icon.image = UIImage(systemName: "chevron.left.circle.fill")
        button.translatesAutoresizingMaskIntoConstraints = false
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
//        arView.session.add(anchor: )
    }
    
}

extension CreateViewController {
    
    func cleanSetup() {
        
    }
    
}

extension CreateViewController: ARSessionDelegate {
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        infoView.message = camera.trackingState.description
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        infoView.message = "Session interrupted"
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        infoView.message = "Session continued"
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        infoView.message = error.localizedDescription
        
        guard error is ARError else { return }
        
        let errorWithInfo = error as NSError
        let messages = [
            errorWithInfo.localizedDescription,
            errorWithInfo.localizedFailureReason,
            errorWithInfo.localizedRecoverySuggestion
        ]
        
        // Remove optional error messages.
        let errorMessage = messages.compactMap({ $0 }).joined(separator: "\n")
        
        DispatchQueue.main.async {
            // Present an alert informing about the error that has occurred.
            let alertController = UIAlertController(title: "The AR session failed.", message: errorMessage, preferredStyle: .alert)
            let restartAction = UIAlertAction(title: "Restart Session", style: .default) { _ in
                alertController.dismiss(animated: true, completion: nil)
                self.resetTracking()
            }
            alertController.addAction(restartAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func sessionShouldAttemptRelocalization(_ session: ARSession) -> Bool {
        true
    }
    
    private func resetTracking() {
        isRelocalizingMap = false
        arView.session.run(worldTrackingConfiguration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    private func saveARWorld() {
        arView.session.getCurrentWorldMap { worldMap, error in
            guard let map = worldMap else { return }

            guard let snapshotAnchor = SnapshotAnchor(from: self.arView) else { return }

            map.anchors.append(snapshotAnchor)

//            do {
//                let data = try NSKeyedArchiver.archivedData(withRootObject: map, requiringSecureCoding: true)
//                try data.write(to: url, options: .atomic)
//                interactor?.saveExperience(data)
//            } catch {
//                fatalError("Can't save map: \(error.localizedDescription)")
//            }
        }
    }
    
}
