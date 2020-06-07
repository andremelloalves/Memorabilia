//
//  Settings+Media.swift
//  Memorabilia
//
//  Created by André Mello Alves on 06/06/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import UIKit

extension SettingsViewController: UINavigationControllerDelegate {
    
}

extension SettingsViewController: UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        
        menu?.background.image = image
        
        if let data = image?.pngData() {
            interactor?.updateBackground(with: data)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
}
