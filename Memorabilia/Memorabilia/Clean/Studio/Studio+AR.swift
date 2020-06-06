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
        let state = camera.trackingState
        let status = session.currentFrame?.worldMappingStatus
        
        infoView.update(title: state.description, info: state.feedback)
        
        switch (state, status) {
        case (.notAvailable, _), (.limited, _):
            updateState(isLimited: true)
        default:
            updateState(isLimited: false)
        }
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        infoView.update(title: "Sessão AR", info: "A sessão AR foi interrompida.")
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        infoView.update(title: "Sessão AR", info: "A sessão AR foi resumida.")
    }
    
    func sessionShouldAttemptRelocalization(_ session: ARSession) -> Bool {
        true
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
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
                self.startSession(shouldRestart: true)
            }
            alertController.addAction(restartAction)
            self.present(alertController, animated: true, completion: nil)
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
        let sphere = SCNSphere(radius: 0.05)
        sphere.firstMaterial!.diffuse.contents = UIColor.white
        let node = SCNNode(geometry: sphere)

        return node
    }
    
    func renderTextNode(_ anchor: ReminderAnchor) -> SCNNode? {
        guard let reminder = interactor?.readReminder(with: anchor.identifier.uuidString) as? TextReminder,
            let message = reminder.name
            else { return nil }
        
        let text = SCNText(string: message, extrusionDepth: 0)
        text.firstMaterial?.isDoubleSided = true
        text.firstMaterial?.diffuse.contents = UIColor.white
        let node = SCNNode(geometry: text)
        let action = SCNAction.scale(by: 0.01, duration: 0)
        node.runAction(action)
        
        return node
    }
    
    func renderPhotoNode(_ anchor: ReminderAnchor) -> SCNNode? {
        guard let reminder = interactor?.readReminder(with: anchor.identifier.uuidString) as? PhotoReminder,
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
        guard let reminder = interactor?.readReminder(with: anchor.identifier.uuidString) as? VideoReminder,
            let player = reminder.player,
            let aspectRatio = reminder.aspectRatio
            else { return nil }
        
        let plane = SCNPlane(width: 0.3 * aspectRatio, height: 0.3)
        plane.firstMaterial!.diffuse.contents = player
        let node = SCNNode(geometry: plane)
        
        let action: SCNAction
        switch reminder.orientation {
        case .left:
            action = SCNAction.rotate(by: .pi / 2, around: SCNVector3(0, 0, 1), duration: 0)
        case .right:
            action = SCNAction.rotate(by: -.pi / 2, around: SCNVector3(0, 0, 1), duration: 0)
        case .down:
            action = SCNAction.rotate(by: .pi, around: SCNVector3(0, 0, 1), duration: 0)
        default:
            action = SCNAction.rotate(by: 0, around: SCNVector3(0, 0, 1), duration: 0)
        }
        node.runAction(action)
        
        return node
    }
    
    func renderAudioNode() -> SCNNode? {
        let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01)
        box.firstMaterial?.diffuse.contents = UIColor.white
        let node = SCNNode(geometry: box)
        
        return node
    }

}
