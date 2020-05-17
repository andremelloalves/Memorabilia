//
//  Studio+Media.swift
//  Memorabilia
//
//  Created by André Mello Alves on 21/04/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import UIKit
import Photos
import MediaPlayer

extension StudioViewController: UINavigationControllerDelegate {
    
}

extension StudioViewController: UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let asset = info[.phAsset] as? PHAsset
        let nsurl: NSURL?
        
        switch selectedReminder?.type {
        case .photo:
            nsurl = info[.imageURL] as? NSURL
        case .video:
            nsurl = info[.mediaURL] as? NSURL
        default:
            nsurl = nil
            break
        }

        updateReminderAnchor(name: asset?.localIdentifier, url: nsurl?.absoluteURL)
        
        picker.dismiss(animated: true, completion: nil)
    }
    
}

extension StudioViewController: MPMediaPickerControllerDelegate {
    
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        mediaPicker.dismiss(animated: true, completion: nil)
    }
    
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        let item = mediaItemCollection.items.first
        let url: URL?
        
        switch selectedReminder?.type {
        case .audio:
            url = item?.assetURL
        default:
            url = nil
            break
        }
        
        updateReminderAnchor(name: url?.absoluteString, url: url)
        
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
