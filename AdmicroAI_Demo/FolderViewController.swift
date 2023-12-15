//
//  FolderViewController.swift
//  AdmicroAI_Demo
//
//  Created by VietChat on 09/11/2023.
//

import UIKit
import AdmicroAI

class FolderViewController: UIViewController {

    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self

    }
    @IBAction func openFolderButton(_ sender: Any) {
        imagePicker.delegate = self
        imagePicker.modalPresentationStyle = .overFullScreen
//        imagePicker.allowsMultipleSelection = true
        present(imagePicker, animated: true)
    }
}

extension FolderViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            return
        }
        
        AdmAI_Manager.shared.postIDCard(imageData: imageData, fileName: "test.jepg") { model, error in
            print("data: \(model)")
            print("eror: \(error)")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
}
