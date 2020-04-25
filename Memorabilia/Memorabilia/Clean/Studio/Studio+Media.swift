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
        let nsurl: NSURL?
        
        switch selectedReminder?.type {
        case .photo:
            nsurl = info[.imageURL] as? NSURL
            selectedReminder?.fileName = nsurl?.path
        case .video:
            nsurl = info[.mediaURL] as? NSURL
            selectedReminder?.fileName = nsurl?.absoluteString
        default:
            nsurl = nil
        }
        
        replaceNode()

        picker.dismiss(animated: true, completion: nil)
    }
    
}

extension StudioViewController: MPMediaPickerControllerDelegate {
    
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        mediaPicker.dismiss(animated: true, completion: nil)
    }
    
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        let url: URL?
        
        switch selectedReminder?.type {
        case .audio:
            url = mediaItemCollection.items[0].assetURL
            selectedReminder?.fileName = url?.absoluteString
        default:
            url = nil
        }
        
        replaceNode()
        
        mediaPicker.dismiss(animated: true, completion: nil)
    }
    
}
