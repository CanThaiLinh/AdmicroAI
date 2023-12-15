//
//  FaceDetailViewController.swift
//  AdmicroAI_Demo
//
//  Created by Nguyễn Đình Việt on 07/12/2023.
//

import UIKit
import AVFoundation
import AdmicroAI

class FaceDetailViewController: UIViewController {
    
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var photo1Image: UIImageView!
    @IBOutlet weak var dataTV: UITextView!
    @IBOutlet weak var copyBT: UIButton!
    @IBOutlet weak var PhotoBT: UIButton!
    @IBOutlet weak var DocumentBT: UIButton!
    @IBOutlet weak var numberTF: UITextField!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var dataBT: UIButton!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    let valueHandler = ValueHanderString()
    let imagePicker = UIImagePickerController()
    var titleHeader: String = ""
    var clickCopyData = true
    var selectImages: [UIImage] = []
    var selectImageCount = 0
    var faceTypes: FaceTypes = .FaceRegister
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
    }
    
    func setUp() {
        title = "\(titleHeader)"
        activityView.isHidden = true
        numberTF.layer.borderColor = UIColor.borderColorTF()
        numberTF.addPadding(.left(15))
        dataBT.backgroundColor = UIColor.backgroundColorAlphaBT()
        dataTV.backgroundColor = UIColor.backgroundTV()
        numberTF.delegate = self
        numberTF.resignFirstResponder()
        dataTV.delegate = self
        imagePicker.delegate = self
        topConstraint.constant = -96
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward.circle"), style: .plain, target: self, action: #selector(backAction))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.backgroundColorBT()
        if faceTypes == .FaceHistory {
            numberTF.isHidden = false
            dataBT.isHidden = false
            topConstraint.constant = -36
            return
        }else if faceTypes == .FaceGetInfo {
            numberTF.isHidden = false
            numberTF.placeholder = "Nhập địa chỉ email"
            dataBT.setTitle("Lấy thông tin người dùng", for: .normal)
            dataBT.isHidden = false
            topConstraint.constant = -36
            return
        }
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    @objc func backAction() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func copyOnClick(_ sender: Any) {
        if clickCopyData {
            copyBT.setImage(UIImage.imageCopy(), for: .normal)
            copyBT.tintColor = UIColor.backgroundColorAlphaBT()
            clickCopyData = false
            UIPasteboard.general.string = dataTV.text
        }
    }
    @IBAction func photoOnClick(_ sender: Any) {
        numberTF.resignFirstResponder()
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    @IBAction func documentOnClick(_ sender: Any) {
        numberTF.resignFirstResponder()
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.image])
        documentPicker.delegate = self
        if faceTypes == .FaceCompare {
            documentPicker.allowsMultipleSelection = true
        }
        present(documentPicker, animated: true, completion: nil)
    }
    @IBAction func dataOnClick(_ sender: Any) {
        activityView.isHidden = false
        activityView.startAnimating()
        dataTV.text = ""
        guard let number = numberTF.text, !number.isEmpty else { return }
        
        switch faceTypes {
        case .FaceHistory:
            guard let number = Int(number) else {
                return
            }
            AdmAI_Manager.shared.faceCheckinHistory(numberRecord: number) { [weak self] data, error in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.activityView.isHidden = true
                    self.activityView.stopAnimating()
                }
                if let data = data {
                    let stringText = self.valueHandler.stringValue(from: data)
                    DispatchQueue.main.async {
                        self.dataTV.text = stringText
                    }
                }else {
                    DispatchQueue.main.async {
                        self.dataTV.text = "Dữ liệu bạn nhập vào không chính xác"
                    }
                }
            }
        case .FaceGetInfo:
            AdmAI_Manager.shared.faceGetInfo(email: number) { [weak self] data, error in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.activityView.isHidden = true
                    self.activityView.stopAnimating()
                }
                if let data = data {
                    let stringText = self.valueHandler.stringValue(from: data)
                    DispatchQueue.main.async {
                        self.dataTV.text = stringText
                    }
                }else {
                    DispatchQueue.main.async {
                        self.dataTV.text = "Dữ liệu bạn nhập vào không chính xác"
                    }
                }
            }
        default:
            break
        }
        numberTF.text = ""
        dataBT.backgroundColor = UIColor.backgroundColorAlphaBT()
    }
}

extension FaceDetailViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        numberTF.layer.borderColor =  UIColor(red: 0.17, green: 0.53, blue: 0.40, alpha: 1.00).cgColor
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let urlText = (numberTF.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        if !urlText.isEmpty {
            dataBT.backgroundColor = UIColor.backgroundColorBT()
        }else {
            dataBT.backgroundColor = UIColor.backgroundColorAlphaBT()
        }
    }
}

extension FaceDetailViewController: UITextViewDelegate {
    func textViewDidChangeSelection(_ textView: UITextView) {
        let isDataEmpty = dataTV.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        copyBT.isHidden = isDataEmpty
        copyBT.setImage(UIImage.imageCopyAlpha(), for: .normal)
        copyBT.tintColor = UIColor.backgroundColorBT()
    }
}

extension FaceDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        selectImages.append(image)
        selectImageCount += 1
        dataTV.text = ""
        activityView.isHidden = false
        activityView.startAnimating()
        switch faceTypes {
        case .FacePredict:
            topConstraint.constant = 16
            photoImage.isHidden = false
            photoImage.image = image
            AdmAI_Manager.shared.facePredict(image: image) { [weak self] data, error in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.activityView.isHidden = true
                    self.activityView.stopAnimating()
                }
                if let data = data {
                    DispatchQueue.main.async {
                        self.dataTV.text = "Latitude: \(data.latitude), Longitude: \(data.longitude)"
                    }
                }else {
                    DispatchQueue.main.async {
                        self.dataTV.text = "Lỗi: \(String(describing: error))"
                    }
                }
            }
        case .FaceFas:
            topConstraint.constant = 16
            photoImage.isHidden = false
            photoImage.image = image
            AdmAI_Manager.shared.faceFasPredict(image: image) { [weak self] data, error in
                guard let self = self else { return }
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
                        self.dataTV.text = "\(String(describing: error))"
                    }
                }
            }
        case .FaceCompare:
            if selectImageCount == 2 {
                topConstraint.constant = 16
                photoImage.isHidden = false
                photo1Image.isHidden = false
                photoImage.image = selectImages[0]
                photo1Image.image = selectImages[1]
                AdmAI_Manager.shared.faceCompare(image1: selectImages[0], image2: selectImages[1]) { [weak self] data, error in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        self.activityView.isHidden = true
                        self.activityView.stopAnimating()
                    }
                    if let data = data {
                        DispatchQueue.main.async {
                            self.dataTV.text = "Độ tương đồng 2 bức là \(data)"
                        }
                    }else {
                        DispatchQueue.main.async {
                            self.dataTV.text = "\(String(describing: error))"
                        }
                    }
                }
                self.dismiss(animated: true, completion: nil)
                selectImages = []
                selectImageCount = 0
            }
        default:
            break
        }
        if faceTypes != .FaceCompare {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

extension FaceDetailViewController: UIDocumentPickerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        let imageURL = urls[0]
        dataTV.text = ""
        activityView.isHidden = false
        activityView.startAnimating()
        switch faceTypes {
        case .FacePredict:
            topConstraint.constant = 16
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
            AdmAI_Manager.shared.facePredict(fileLocal: imageURL) { [weak self] data, error in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.activityView.isHidden = true
                    self.activityView.stopAnimating()
                }
                if let data = data {
                    DispatchQueue.main.async {
                        self.dataTV.text = "Latitude: \(data.latitude), Longitude: \(data.longitude)"
                    }
                }else {
                    DispatchQueue.main.async {
                        self.dataTV.text = "\(String(describing: error))"
                    }
                }
            }
        case .FaceFas:
            topConstraint.constant = 16
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
            AdmAI_Manager.shared.faceFasPredict(fileLocal: imageURL) { [weak self] data, error in
                guard let self = self else { return }
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
                        self.dataTV.text = "\(String(describing: error))"
                    }
                }
            }
        case .FaceCompare:
            if urls.count > 1 {
                topConstraint.constant = 16
                photoImage.isHidden = false
                photo1Image.isHidden = false
                let imageURL1 = urls[1]
                if FileManager.default.fileExists(atPath: imageURL.path), FileManager.default.fileExists(atPath: imageURL1.path)  {
                    if let image = UIImage(contentsOfFile: imageURL.path), let image1 = UIImage(contentsOfFile: imageURL1.path) {
                        photoImage.image = image
                        photo1Image.image = image1
                    }else {
                        print("Lỗi khởi tạo ảnh từ file")
                    }
                }else {
                    print("Đường dẫn file ảnh bị lỗi")
                }
                AdmAI_Manager.shared.faceCompare(fileLocal1: imageURL, fileLocal2: imageURL) { [weak self] data, error in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        self.activityView.isHidden = true
                        self.activityView.stopAnimating()
                    }
                    if let data = data {
                        DispatchQueue.main.async {
                            self.dataTV.text = "Độ tương đồng 2 bức là \(data)"
                        }
                    }else {
                        DispatchQueue.main.async {
                            self.dataTV.text = "\(String(describing: error))"
                        }
                    }
                }
            }
        default:
            break
        }
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
