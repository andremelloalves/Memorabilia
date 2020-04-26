//
//  Studio+AR.swift
//  Memorabilia
//
//  Created by André Mello Alves on 29/03/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import Foundation
import ARKit
import SceneKit

extension StudioViewController: ARSessionDelegate {
    
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
    
    func saveARWorld() {
        arView.session.getCurrentWorldMap { arWorld, error in
            guard let worldMap = arWorld else { return }
            
            guard let snapshotAnchor = SnapshotAnchor(from: self.arView) else { return }
            worldMap.anchors.append(snapshotAnchor)
            
            self.saveMemory(worldMap: worldMap, photo: snapshotAnchor.photo)
        }
    }
    
    func saveMemory(worldMap: ARWorldMap, photo: Data) {
        do {
            let worldData = try NSKeyedArchiver.archivedData(withRootObject: worldMap, requiringSecureCoding: true)
            self.interactor?.createMemory(with: worldData, photo: photo)
            self.routeBack()
        } catch let error {
            print(error)
        }
    }
    
}

extension StudioViewController: ARSCNViewDelegate {

    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        return renderNode(for: anchor)
    }
    
    func renderNode(for anchor: ARAnchor) -> SCNNode? {
        guard let reminder = anchor as? ReminderAnchor else { return nil }
        guard let fileName = reminder.name else { return renderDefaultNode() }
        
        let node: SCNNode?

        switch reminder.type {
        case .text:
            node = renderTextNode(fileName)
        case .photo:
            node = renderPhotoNode(fileName)
        case .video:
            node = renderVideoNode(reminder)
        case .audio:
            node = renderAudioNode()
        }
        node?.name = reminder.name

        return node
    }
    
    func renderDefaultNode() -> SCNNode {
        let sphere = SCNSphere(radius: 0.1)
        sphere.firstMaterial!.diffuse.contents = UIColor.white
        let node = SCNNode(geometry: sphere)

        return node
    }
    
    func renderTextNode(_ message: String) -> SCNNode? {
        guard !message.isEmpty else { return nil }
        
        let text = SCNText(string: message, extrusionDepth: 0)
        text.firstMaterial?.isDoubleSided = true
        text.firstMaterial?.diffuse.contents = UIColor.white
        let node = SCNNode(geometry: text)
        
        return node
    }
    
    func renderPhotoNode(_ fileName: String) -> SCNNode? {
        guard let image = UIImage(contentsOfFile: fileName) else { return nil }
        
        let plane = SCNPlane(width: image.size.width / 10000, height: image.size.height / 10000)
        plane.firstMaterial!.diffuse.contents = image
        let node = SCNNode(geometry: plane)
        
        return node
    }
    
    func renderVideoNode(_ anchor: ReminderAnchor) -> SCNNode? {
        guard let reminder = interactor?.readReminder(identifier: anchor.identifier.uuidString) as? VideoReminder else { return nil }
        
        let plane = SCNPlane(width: 0.3, height: 0.4)
        plane.firstMaterial!.diffuse.contents = reminder.player
        let node = SCNNode(geometry: plane)
        
        return node
    }
    
    func renderAudioNode() -> SCNNode? {
        let sphere = SCNSphere(radius: 0.1)
        sphere.firstMaterial?.diffuse.contents = UIColor.white
        let node = SCNNode(geometry: sphere)
        
        return node
    }

}
