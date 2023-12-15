//
//  FaceRegisterViewController.swift
//  AdmicroAI_Demo
//
//  Created by VietChat on 05/12/2023.
//

import UIKit
import AdmicroAI
import AVFoundation

class FaceRegisterViewController: UIViewController {

    var titleHeader: String = ""
    var sectionTypes: FaceTypes = .FaceRegister
    var clickCopyData = true
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var codeTF: UITextField!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet weak var maskLabel: UILabel!
    @IBOutlet weak var maskTF: UITextField!
    @IBOutlet weak var documnetBT: UIButton!
    @IBOutlet weak var pickerBT: UIButton!
    @IBOutlet weak var dataBT: UIButton!
    @IBOutlet weak var dataTV: UITextView!
    @IBOutlet weak var copyBT: UIButton!
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var topConstraintTV: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraintPhoto: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraintDocument: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTF.addPadding(.left(15))
        emailTF.addPadding(.left(15))
        codeTF.addPadding(.left(15))
        maskTF.addPadding(.left(15))
        setUpLayer()
    }
    func setUpLayer() {
        title = "\(titleHeader)"
        activityView.isHidden = true
        nameTF.layer.borderColor = UIColor.borderColorTF()
        emailTF.layer.borderColor = UIColor.borderColorTF()
        codeTF.layer.borderColor = UIColor.borderColorTF()
        maskTF.layer.borderColor = UIColor.borderColorTF()
        topConstraintTV.constant = -96
        dataBT.backgroundColor = UIColor.backgroundColorAlphaBT()
        dataTV.backgroundColor = UIColor.backgroundTV()
        nameTF.delegate = self
        emailTF.delegate = self
        codeTF.delegate = self
        maskTF.delegate = self
        dataTV.delegate = self
        nameTF.becomeFirstResponder()
        imagePicker.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward.circle"), style: .plain, target: self, action: #selector(backAction))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.backgroundColorBT()
        if sectionTypes == .FaceUpdate {
            documnetBT.isHidden = true
            pickerBT.isHidden = true
            dataBT.isHidden = false
            bottomConstraintPhoto.constant = -44
            bottomConstraintDocument.constant = -44
            topConstraintTV.constant = -36
            dataBT.backgroundColor = UIColor.backgroundColorAlphaBT()
            maskLabel.text = "ID Tele"
            maskTF.placeholder = "Nhập ID Telegram"
        }
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    @objc func backAction() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func openDocument(_ sender: Any) {
        nameTF.resignFirstResponder()
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.image])
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    @IBAction func openPicker(_ sender: Any) {
        nameTF.resignFirstResponder()
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    @IBAction func updateOnClick(_ sender: Any) {
        activityView.isHidden = false
        activityView.startAnimating()
        dataTV.text = ""
        nameTF.resignFirstResponder()
        guard let name = nameTF.text,
              let email = emailTF.text,
              let code = codeTF.text,
              let mask = maskTF.text,
              !name.isEmpty,
              !email.isEmpty,
              !code.isEmpty,
              !mask.isEmpty else {
            return
        }
        AdmAI_Manager.shared.faceUpdateInfo(employeeCode: Int(code) ?? 0, email: email, name: name, telegramID: Int(mask) ?? 0) { data, error in
            DispatchQueue.main.async {
                self.activityView.isHidden = true
                self.activityView.stopAnimating()
            }
            if let data = data {
                DispatchQueue.main.async {
                    self.dataTV.text = data
                }
            }else {
                DispatchQueue.main.async {
                    self.dataTV.text = "Cập nhật thông tin không thành công"
                }
            }
        }
        nameTF.text = ""
        emailTF.text = ""
        codeTF.text = ""
        maskTF.text = ""
        dataBT.backgroundColor = UIColor.backgroundColorAlphaBT()
    }
    @IBAction func copyOnClick(_ sender: Any) {
        if clickCopyData {
            copyBT.setImage(UIImage.imageCopy(), for: .normal)
            copyBT.tintColor = UIColor.backgroundColorAlphaBT()
            clickCopyData = false
            UIPasteboard.general.string = dataTV.text
        }
    }
}

extension FaceRegisterViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor =  UIColor(red: 0.17, green: 0.53, blue: 0.40, alpha: 1.00).cgColor
    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let name = (nameTF.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let email = (emailTF.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let code = (codeTF.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let idTele = (maskTF.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        if !name.isEmpty && !email.isEmpty && !code.isEmpty && !idTele.isEmpty {
            dataBT.backgroundColor = UIColor.backgroundColorBT()
        }else {
            dataBT.backgroundColor = UIColor.backgroundColorAlphaBT()
        }
    }
}

extension FaceRegisterViewController: UITextViewDelegate {
    func textViewDidChangeSelection(_ textView: UITextView) {
        let isDataEmpty = dataTV.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        copyBT.isHidden = isDataEmpty
        copyBT.setImage(UIImage.imageCopyAlpha(), for: .normal)
        copyBT.tintColor = UIColor.backgroundColorBT()
    }
}

extension FaceRegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        activityView.isHidden = false
        activityView.startAnimating()
        dataTV.text = ""
        guard let name = nameTF.text,
              let email = emailTF.text,
              let code = codeTF.text,
              let mask = maskTF.text,
              !name.isEmpty,
              !email.isEmpty,
              !code.isEmpty,
              !mask.isEmpty else {
            DispatchQueue.main.async {
                self.activityView.isHidden = true
                self.activityView.stopAnimating()
                self.dataTV.text = "Bạn chưa nhập đủ thông tin"
            }
            self.dismiss(animated: true)
            return
        }
        topConstraintTV.constant = 16
        photoImage.isHidden = false
        photoImage.image = image
        AdmAI_Manager.shared.faceRegister(image: image, name: name, email: email, employeeCode: Int(code) ?? 0, faceMask: (Int(mask) ?? 0)) { data, error in
            DispatchQueue.main.async {
                self.activityView.isHidden = true
                self.activityView.stopAnimating()
            }
            if let data = data {
                DispatchQueue.main.async {
                    self.dataTV.text = data
                }
            }else {
                DispatchQueue.main.async {
                    self.dataTV.text = "Dữ liệu không chính xác"
                }
            }
        }
        nameTF.text = ""
        emailTF.text = ""
        codeTF.text = ""
        maskTF.text = ""
        self.dismiss(animated: true)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

extension FaceRegisterViewController: UIDocumentPickerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        let imageURL = urls[0]
        activityView.isHidden = false
        activityView.startAnimating()
        dataTV.text = ""
        guard let name = nameTF.text,
              let email = emailTF.text,
              let code = codeTF.text,
              let mask = maskTF.text,
              !name.isEmpty,
              !email.isEmpty,
              !code.isEmpty,
              !mask.isEmpty else {
            DispatchQueue.main.async {
                self.activityView.isHidden = true
                self.activityView.stopAnimating()
                self.dataTV.text = "Bạn chưa nhập đủ thông tin"
            }
            return
        }
        topConstraintTV.constant = 16
        photoImage.isHidden = false
        if FileManager.default.fileExists(atPath: imageURL.path) {
            if let image = UIImage(contentsOfFile: imageURL.path) {
                photoImage.image = image
            }else {
                print("Lỗi khởi tạo ảnh từ file")
            }
        }else {
            print("Đường dẫn file ảnh bị lỗi")
        }
        AdmAI_Manager.shared.faceRegister(fileLocal: imageURL, name: name, email: email, employeeCode: Int(code) ?? 0, faceMask: Int(mask) ?? 1) { data, error in
            DispatchQueue.main.async {
                self.activityView.isHidden = true
                self.activityView.stopAnimating()
            }
            if let data = data {
                DispatchQueue.main.async {
                    self.dataTV.text = data
                }
            }else {
                DispatchQueue.main.async {
                    self.dataTV.text = "Dữ liệu không chính xác"
                }
            }
        }
        nameTF.text = ""
        emailTF.text = ""
        codeTF.text = ""
        maskTF.text = ""
    }
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        dismiss(animated: true)
        
        guard url.startAccessingSecurityScopedResource() else {
            return
        }
        
        do {
            url.stopAccessingSecurityScopedResource()
        }
    }
}
