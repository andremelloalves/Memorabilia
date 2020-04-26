//
//  Studio+Media.swift
//  Memorabilia
//
//  Created by André Mello Alves on 21/04/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import UIKit
//import ARKit
//import SceneKit
import MediaPlayer
//import MobileCoreServices

extension StudioViewController: UINavigationControllerDelegate {
    
}

extension StudioViewController: UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let name: String?
        
        switch selectedReminder?.type {
        case .photo:
            let nsurl = info[.imageURL] as? NSURL
            name = nsurl?.path
        case .video:
            let nsurl = info[.mediaURL] as? NSURL
            name = nsurl?.absoluteString
        default:
            name = nil
        }
        
        updateReminderAnchor(name: name)

        picker.dismiss(animated: true, completion: nil)
    }
    
}

extension StudioViewController: MPMediaPickerControllerDelegate {
    
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        mediaPicker.dismiss(animated: true, completion: nil)
    }
    
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        let name: String?
        
        switch selectedReminder?.type {
        case .audio:
            let url = mediaItemCollection.items[0].assetURL
            name = url?.absoluteString
        default:
            name = nil
        }
        
        updateReminderAnchor(name: name)
        
        mediaPicker.dismiss(animated: true, completion: nil)
    }
    
}

extension StudioViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        let name = textField.text
        
        updateReminderAnchor(name: name)
        
        return false
    }
    
}
