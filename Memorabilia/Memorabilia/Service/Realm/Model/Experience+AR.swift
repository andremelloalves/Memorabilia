//
//  Experience+AR.swift
//  Memorabilia
//
//  Created by André Mello Alves on 04/04/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import Foundation
import ARKit
import SceneKit

extension ExperienceViewController: ARSessionDelegate {
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        let state = camera.trackingState
        let status = session.currentFrame?.worldMappingStatus
        
        switch state {
        case .normal:
            infoView.update(title: "Explorando", info: "Mapeie o ambiente e interaja com os lembretes AR.")
        case .limited(.relocalizing):
            infoView.update(title: "Localizando", info: "Mova o dispositivo para a perspectiva da imagem.")
        default:
            infoView.update(title: state.description, info: state.feedback)
        }
        
        switch (state, status) {
        case (.notAvailable, _), (.limited(.relocalizing), _), (.limited(.initializing), _), (_, .notAvailable):
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

extension ExperienceViewController: ARSCNViewDelegate {

    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        return renderNode(for: anchor)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let transform = interactor?.readTransform(with: anchor.identifier.uuidString) else { return }
        
        let scale = SCNAction.scale(to: CGFloat(transform.scale), duration: 1)
        node.runAction(scale)

        let rotation = SCNAction.rotateTo(x: CGFloat(transform.pitch),
                                          y: CGFloat(transform.yaw),
                                          z: CGFloat(transform.roll),
                                          duration: 1)
        node.runAction(rotation)
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
        sphere.firstMaterial!.diffuse.contents = interactor?.readPreferredColor()
        let node = SCNNode(geometry: sphere)

        return node
    }
    
    func renderLoadingNode() -> SCNNode {
        let torus = SCNTorus(ringRadius: 0.05, pipeRadius: 0.01)
        torus.firstMaterial!.diffuse.contents = interactor?.readPreferredColor()
        let node = SCNNode(geometry: torus)
        
        let rotation = SCNAction.rotateBy(x: .pi, y: .pi, z: .pi, duration: 1)
        let forever = SCNAction.repeatForever(rotation)
        node.runAction(forever)

        return node
    }
    
    func renderTextNode(_ anchor: ReminderAnchor) -> SCNNode? {
        guard let reminder = interactor?.readReminder(with: anchor.identifier.uuidString) as? TextReminder,
            let message = reminder.name
            else { return renderLoadingNode() }
        
        let text = SCNText(string: message, extrusionDepth: 0)
        text.firstMaterial?.isDoubleSided = true
        text.firstMaterial?.diffuse.contents = interactor?.readPreferredColor()
        let node = SCNNode(geometry: text)
        
        return node
    }
    
    func renderPhotoNode(_ anchor: ReminderAnchor) -> SCNNode? {
        guard let reminder = interactor?.readReminder(with: anchor.identifier.uuidString) as? PhotoReminder,
            let data = reminder.data,
            let image = UIImage(data: data)?.orientedImage
            else { return renderLoadingNode() }
        
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
            else { return renderLoadingNode() }
        
        let plane = SCNPlane(width: 0.3 * aspectRatio, height: 0.3)
        plane.firstMaterial!.diffuse.contents = player
        let node = SCNNode(geometry: plane)
        
        return node
    }
    
    func renderAudioNode() -> SCNNode? {
        let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01)
        box.firstMaterial?.diffuse.contents = interactor?.readPreferredColor()
        let node = SCNNode(geometry: box)
        
        return node
    }

}
