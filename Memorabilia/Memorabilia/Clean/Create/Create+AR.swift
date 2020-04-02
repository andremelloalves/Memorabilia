//
//  Create+AR.swift
//  Memorabilia
//
//  Created by André Mello Alves on 29/03/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import Foundation
import ARKit

extension CreateViewController: ARSessionDelegate {
    
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
