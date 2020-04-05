//
//  Experience+AR.swift
//  Memorabilia
//
//  Created by André Mello Alves on 04/04/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import Foundation
import ARKit
import RealityKit

extension ExperienceViewController: ARSessionDelegate {
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        infoView.info = camera.trackingState.description
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        infoView.info = "Session interrupted"
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        infoView.info = "Session continued"
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        infoView.info = error.localizedDescription
        
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
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        updateSessionInfoLabel(for: frame, trackingState: frame.camera.trackingState)
    }
    
    private func updateSessionInfoLabel(for frame: ARFrame, trackingState: ARCamera.TrackingState) {
        // Update the UI to provide feedback on the state of the AR experience.
        let message: String
        
        hintView.isHidden = true
        switch (trackingState, frame.worldMappingStatus) {
        case (.normal, .mapped),
             (.normal, .extending):
            message = "Mapa encontrado."
            
//        case (.normal, _) where mapDataFromFile != nil:
//            message = "Move around to map the environment or tap 'Load Experience' to load a saved experience."
//
//        case (.normal, _) where mapDataFromFile == nil:
//            message = "Move around to map the environment."
            
        case (.limited(.relocalizing), _):
            message = "Move your device to the location shown in the image."
            hintView.isHidden = false
            
        default:
            message = trackingState.localizedFeedback
        }
        
        infoView.infoLabel.text = message
    }
    
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        for anchor in anchors {
            if anchor.name == "Sphere" {
                add(anchor: anchor)
            }
        }
    }
    
    func add(anchor: ARAnchor) {
        let anchorEntity = AnchorEntity(anchor: anchor)
        
        let sphere = MeshResource.generateSphere(radius: 0.1)
        let material = SimpleMaterial(color: .white, isMetallic: false)
        let entity = ModelEntity(mesh: sphere, materials: [material])
        
        anchorEntity.addChild(entity)
        
        arView.scene.addAnchor(anchorEntity)
    }
    
}
