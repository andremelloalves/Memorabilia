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
    
    // MARK: AR properties
    
    var isRelocalizingMap: Bool = false
    
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
    
    // MARK: Scene properties
    
    lazy var arView: ARView = {
        let view = ARView(frame: self.view.frame)
        return view
    }()
    
    // MARK: Initializers
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        cleanSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        cleanSetup()
    }
    
    // MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // AR support
        guard ARWorldTrackingConfiguration.isSupported else { fatalError("ARKit is not available on this device.") }

        // Screen dimming
        UIApplication.shared.isIdleTimerDisabled = true

        // Start AR Session
        arView.session.delegate = self
        arView.session.run(worldTrackingConfiguration)
        arView.debugOptions = [.showWorldOrigin, .showFeaturePoints]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause AR Session
        arView.session.pause()
    }
    
    override var shouldAutorotate: Bool {
        false
    }
    
}

extension CreateViewController {
    
    func cleanSetup() {
        
    }
    
}

extension CreateViewController: ARSessionDelegate {
    
    func sessionShouldAttemptRelocalization(_ session: ARSession) -> Bool {
        true
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
