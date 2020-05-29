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
            
            self.saveMemory(worldMap: worldMap, snapshot: snapshotAnchor.snapshot)
        }
    }
    
    func saveMemory(worldMap: ARWorldMap, snapshot: Data) {
        do {
            let world = try NSKeyedArchiver.archivedData(withRootObject: worldMap, requiringSecureCoding: true)
            self.interactor?.createMemory(world: world, snapshot: snapshot)
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
        guard reminder.name != nil else { return renderDefaultNode() }
        
        let node: SCNNode?

        switch reminder.type {
        case .text:
            node = renderTextNode(reminder)
        case .photo:
            node = renderPhotoNode(reminder)
        case .video:
            node = renderVideoNode(reminder)
        case .audio:
            node = renderAudioNode()
        }
        node?.name = reminder.type.rawValue

        return node
    }
    
    func renderDefaultNode() -> SCNNode {
        let sphere = SCNSphere(radius: 0.1)
        sphere.firstMaterial!.diffuse.contents = UIColor.white
        let node = SCNNode(geometry: sphere)

        return node
    }
    
    func renderTextNode(_ anchor: ReminderAnchor) -> SCNNode? {
        guard let reminder = interactor?.readReminder(identifier: anchor.identifier.uuidString) as? TextReminder,
            let message = reminder.name
            else { return nil }
        
        let text = SCNText(string: message, extrusionDepth: 0)
        text.firstMaterial?.isDoubleSided = true
        text.firstMaterial?.diffuse.contents = UIColor.white
        let node = SCNNode(geometry: text)
        
        return node
    }
    
    func renderPhotoNode(_ anchor: ReminderAnchor) -> SCNNode? {
        guard let reminder = interactor?.readReminder(identifier: anchor.identifier.uuidString) as? PhotoReminder,
            let data = reminder.data,
            let image = UIImage(data: data)?.orientedImage
            else { return nil }
        
        let aspectRatio = image.size.height / image.size.width
        
        let plane = SCNPlane(width: 0.3, height: 0.3 * aspectRatio)
        plane.firstMaterial!.diffuse.contents = image
        let node = SCNNode(geometry: plane)
        
        return node
    }
    
    func renderVideoNode(_ anchor: ReminderAnchor) -> SCNNode? {
        guard let reminder = interactor?.readReminder(identifier: anchor.identifier.uuidString) as? VideoReminder,
            let player = reminder.player,
            let aspectRatio = reminder.aspectRatio
            else { return nil }
        
        let plane = SCNPlane(width: 0.3, height: 0.3 * aspectRatio)
        plane.firstMaterial!.diffuse.contents = player
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
