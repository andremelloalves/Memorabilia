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
        print("Chosen!")
        picker.dismiss(animated: true, completion: nil)
    }
    
}

extension StudioViewController: MPMediaPickerControllerDelegate {
    
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        mediaPicker.dismiss(animated: true, completion: nil)
    }
    
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        print(mediaItemCollection)
        mediaPicker.dismiss(animated: true, completion: nil)
    }
    
}
