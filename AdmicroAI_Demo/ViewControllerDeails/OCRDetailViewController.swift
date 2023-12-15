//
//  OCRDetailViewController.swift
//  AdmicroAI_Demo
//
//  Created by VietChat on 09/11/2023.
//

import UIKit
import AdmicroAI
import AVFoundation

class OCRDetailViewController: UIViewController {
    
    let valueHandler = ValueHanderString()
    let imagePicker = UIImagePickerController()
    var titleHeader: String = ""
    var ocrTypes: OCRTypes = .CardID
    var clickCopyData = true
    var clickCopyValue = true
    
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet weak var dataButton: UIButton!
    @IBOutlet weak var copyDataButton: UIButton!
    @IBOutlet weak var copyValueButton: UIButton!
    @IBOutlet weak var dataTV: UITextView!
    @IBOutlet weak var valueTV: UITextView!
    @IBOutlet weak var DocumentBT: UIButton!
    @IBOutlet weak var PickerBT: UIButton!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var ocrImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        urlTextField.addPadding(.left(15))
        setUpLayer()
    }
    
    func setUpLayer() {
        title = "\(titleHeader)"
        activityView.isHidden = true
        urlTextField.layer.borderColor = UIColor.borderColorTF()
        dataButton.backgroundColor = UIColor.backgroundColorAlphaBT()
        dataTV.backgroundColor = UIColor.backgroundTV()
        valueTV.backgroundColor = UIColor.backgroundTV()
        urlTextField.delegate = self
        urlTextField.becomeFirstResponder()
        dataTV.delegate = self
        valueTV.delegate = self
        imagePicker.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward.circle"), style: .plain, target: self, action: #selector(backAction))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.backgroundColorBT()
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    @objc func backAction() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func dataOnClick(_ sender: Any) {
        activityView.isHidden = false
        activityView.startAnimating()
        dataTV.text = ""
        valueTV.text = ""
        urlTextField.resignFirstResponder()
        guard let urlString = urlTextField.text, !urlString.isEmpty else { return }
        switch ocrTypes{
        case .CardID:
            AdmAI_Manager.shared.getIDCard(linkOnline: urlString) { [weak self] data, value, error in
                guard let self = self else { return }
                self.handleDataResponse(data: data, value: value, error: error)
            }
        case .RegisterCar:
            AdmAI_Manager.shared.getRegisterCar(linkOnline: urlString) { [weak self] data, value, error in
                guard let self = self else { return }
                self.handleDataResponse(data: data, value: value, error: error)
            }
        case .Health:
            AdmAI_Manager.shared.getHealth(linkOnline: urlString) { [weak self] data, value, error in
                guard let self = self else { return }
                self.handleDataResponse(data: data, value: value, error: error)
            }
        case .RegistryCar:
            AdmAI_Manager.shared.getRegistryCar(linkOnline: urlString) { [weak self] data, value, error in
                guard let self = self else { return }
                self.handleDataResponse(data: data, value: value, error: error)
            }
        case .Expenses:
            AdmAI_Manager.shared.getExpenses(linkOnline: urlString) { [weak self] data, value, error in
                guard let self = self else { return }
                self.handleDataResponse(data: data, value: value, error: error)
            }
        case .Business:
            AdmAI_Manager.shared.getBusinessRegister(linkOnline: urlString) { [weak self] data, value, error in
                guard let self = self else { return }
                self.handleDataResponse(data: data, value: value, error: error)
            }
        case .KVP:
            AdmAI_Manager.shared.getKeyValuePair(linkOnline: urlString) { [weak self] data, value, error in
                guard let self = self else { return }
                self.handleDataResponse(data: data, value: value, error: error)
            }
        case .Tabular:
            AdmAI_Manager.shared.getTabular(linkOnline: urlString) { [weak self] data, value, error in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.activityView.isHidden = true
                    self.activityView.stopAnimating()
                }
                if let data = data, let value = value {
                    let stringValue = self.valueHandler.tabularStringValue(from: value)
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                        if let jsonString = String(data: jsonData, encoding: .utf8){
                            DispatchQueue.main.async {
                                self.dataTV.text = jsonString
                                self.valueTV.text = stringValue
                            }
                        }
                    }catch {
                        DispatchQueue.main.async {
                            self.dataTV.text = "Error converting dictionary to JSON string: \(error.localizedDescription)"
                            self.valueTV.text = "Error converting dictionary to JSON string: \(error.localizedDescription)"
                        }
                    }
                }else {
                    DispatchQueue.main.async {
                        self.dataTV.text = "Dữ liệu bạn nhập vào không chính xác"
                        self.valueTV.text = "Dữ liệu bạn nhập vào không chính xác"
                    }
                }
            }
        case .Passport:
            AdmAI_Manager.shared.getPassport(linkOnline: urlString) { [weak self] data, error in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.activityView.isHidden = true
                    self.activityView.stopAnimating()
                }
                if let data = data {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                        if let jsonString = String(data: jsonData, encoding: .utf8){
                            DispatchQueue.main.async {
                                self.dataTV.text = jsonString
                                self.valueTV.text = "Chưa hỗ trợ lấy thông tin chi tiết"
                            }
                        }
                    }catch {
                        DispatchQueue.main.async {
                            self.dataTV.text = "Error converting dictionary to JSON string: \(error.localizedDescription)"
                            self.valueTV.text = "Error converting dictionary to JSON string: \(error.localizedDescription)"
                        }
                    }
                }else {
                    DispatchQueue.main.async {
                        self.dataTV.text = "Dữ liệu bạn nhập vào không chính xác"
                        self.valueTV.text = "Dữ liệu bạn nhập vào không chính xác"
                    }
                }
            }
        case .Visa:
            AdmAI_Manager.shared.getVisa(linkOnline: urlString) { [weak self] data, value, error in
                guard let self = self else { return }
                self.handleDataResponse(data: data, value: value, error: error)
            }
        case .Retail:
            AdmAI_Manager.shared.getRetail(linkOnline: urlString) { [weak self] data, value, error in
                guard let self = self else { return }
                self.handleDataResponse(data: data, value: value, error: error)
            }
        case .Ielts:
            AdmAI_Manager.shared.getIeltsCertificate(linkOnline: urlString) { [weak self] data, value, error in
                guard let self = self else { return }
                self.handleDataResponse(data: data, value: value, error: error)
            }
        case .Driver:
            AdmAI_Manager.shared.getDriver(linkOnline: urlString) { [weak self] data, value, error in
                guard let self = self else { return }
                self.handleDataResponse(data: data, value: value, error: error)
            }
        }
        if let imageURL = URL(string: urlString) {
            loadImage(from: imageURL)
        }
        urlTextField.text = ""
        dataButton.backgroundColor = UIColor.backgroundColorAlphaBT()
    }
    
    func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if error != nil {
                return
            }
            
            if let data = data, let image = UIImage(data: data){
                DispatchQueue.main.async {
                    self.ocrImage.image = image
                }
            }
        }.resume()
    }
    
    @IBAction func copyDataOnClick(_ sender: Any) {
        if clickCopyData {
            copyDataButton.setImage(UIImage.imageCopy(), for: .normal)
            copyDataButton.tintColor = UIColor.backgroundColorAlphaBT()
            clickCopyData = false
            UIPasteboard.general.string = dataTV.text
        }
    }
    @IBAction func copyValueOnClick(_ sender: Any) {
        if clickCopyValue {
            copyValueButton.setImage(UIImage.imageCopy(), for: .normal)
            copyValueButton.tintColor = UIColor.backgroundColorAlphaBT()
            clickCopyValue = false
            UIPasteboard.general.string = valueTV.text
        }
    }
    @IBAction func openAlbumOnClick(_ sender: Any) {
        urlTextField.resignFirstResponder()
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
    @IBAction func openFolderOnClick(_ sender: Any) {
        urlTextField.resignFirstResponder()
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.image])
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    
    func handleDataResponse(data: Dictionary<String, Any>?, value: Any?, error: AdmAIError?) {
        DispatchQueue.main.async {
            self.activityView.isHidden = true
            self.activityView.stopAnimating()
        }
        if let data = data, let value = value {
            let stringText = valueHandler.stringValue(from: value)
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                if let jsonString = String(data: jsonData, encoding: .utf8){
                    DispatchQueue.main.async {
                        self.dataTV.text = jsonString
                        self.valueTV.text = stringText
                        self.topConstraint.constant = 4
                        self.ocrImage.isHidden = false
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.dataTV.text = "Error converting dictionary to JSON string: \(error.localizedDescription)"
                    self.valueTV.text = "Error converting dictionary to JSON string: \(error.localizedDescription)"
                }
            }
        }else {
            DispatchQueue.main.async {
                self.dataTV.text = "Dữ liệu bạn nhập vào không chính xác"
                self.valueTV.text = "Dữ liệu bạn nhập vào không chính xác"
            }
        }
    }
}

//MARK: TextFieldDelegate
extension OCRDetailViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        urlTextField.layer.borderColor =  UIColor(red: 0.17, green: 0.53, blue: 0.40, alpha: 1.00).cgColor
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let urlText = (urlTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        if !urlText.isEmpty {
            dataButton.backgroundColor = UIColor.backgroundColorBT()
        }else {
            dataButton.backgroundColor = UIColor.backgroundColorAlphaBT()
        }
    }
}

//MARK: TextViewDelegate
extension OCRDetailViewController: UITextViewDelegate {
    func textViewDidChangeSelection(_ textView: UITextView) {
        let isDataEmpty = dataTV.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        copyDataButton.isHidden = isDataEmpty
        copyDataButton.setImage(UIImage.imageCopyAlpha(), for: .normal)
        copyDataButton.tintColor = UIColor.backgroundColorBT()
        
        let isValueEmpty = valueTV.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        copyValueButton.isHidden = isValueEmpty
        copyValueButton.setImage(UIImage.imageCopyAlpha(), for: .normal)
        copyValueButton.tintColor = UIColor.backgroundColorBT()
    }
}

//MARK: ImagePicker
extension OCRDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        dataTV.text = ""
        valueTV.text = ""
        activityView.isHidden = false
        activityView.startAnimating()
        ocrImage.image = image
        switch ocrTypes {
        case .CardID:
            AdmAI_Manager.shared.getIDCard(image: image) { [weak self] data, value, error in
                guard let self = self else { return }
                self.handleDataResponse(data: data, value: value, error: error)
            }
        case .RegisterCar:
            AdmAI_Manager.shared.getRegisterCar(image: image) { [weak self] data, value, error in
                guard let self = self else { return }
                self.handleDataResponse(data: data, value: value, error: error)
            }
        case .Health:
            AdmAI_Manager.shared.getHealth(image: image) { [weak self] data, value, error in
                guard let self = self else { return }
                self.handleDataResponse(data: data, value: value, error: error)
            }
        case .RegistryCar:
            AdmAI_Manager.shared.getRegistryCar(image: image) { [weak self] data, value, error in
                guard let self = self else { return }
                self.handleDataResponse(data: data, value: value, error: error)
            }
        case .Expenses:
            AdmAI_Manager.shared.getExpenses(image: image) { [weak self] data, value, error in
                guard let self = self else { return }
                self.handleDataResponse(data: data, value: value, error: error)
            }
        case .Business:
            AdmAI_Manager.shared.getBusinessRegister(image: image) { [weak self] data, value, error in
                guard let self = self else { return }
                self.handleDataResponse(data: data, value: value, error: error)
            }
        case .KVP:
            AdmAI_Manager.shared.getKeyValuePair(image: image) { [weak self] data, value, error in
                guard let self = self else { return }
                self.handleDataResponse(data: data, value: value, error: error)
            }
        case .Tabular:
            AdmAI_Manager.shared.getTabular(image: image) { [weak self] data, value, error in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.activityView.isHidden = true
                    self.activityView.stopAnimating()
                }
                if let data = data, let value = value {
                    let stringValue = self.valueHandler.tabularStringValue(from: value)
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                        if let jsonString = String(data: jsonData, encoding: .utf8){
                            DispatchQueue.main.async {
                                self.dataTV.text = jsonString
                                self.valueTV.text = stringValue
                            }
                        }
                    }catch {
                        DispatchQueue.main.async {
                            self.dataTV.text = "Error converting dictionary to JSON string: \(error.localizedDescription)"
                            self.valueTV.text = "Error converting dictionary to JSON string: \(error.localizedDescription)"
                        }
                    }
                }else {
                    DispatchQueue.main.async {
                        self.dataTV.text = "Dữ liệu bạn nhập vào không chính xác"
                        self.valueTV.text = "Dữ liệu bạn nhập vào không chính xác"
                    }
                }
            }
        case .Passport:
            AdmAI_Manager.shared.getPassport(image: image) { [weak self] data, error in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.activityView.isHidden = true
                    self.activityView.stopAnimating()
                }
                if let data = data {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                        if let jsonString = String(data: jsonData, encoding: .utf8){
                            DispatchQueue.main.async {
                                self.dataTV.text = jsonString
                                self.valueTV.text = "Chưa hỗ trợ lấy thông tin chi tiết"
                            }
                        }
                    }catch {
                        DispatchQueue.main.async {
                            self.dataTV.text = "Error converting dictionary to JSON string: \(error.localizedDescription)"
                            self.valueTV.text = "Error converting dictionary to JSON string: \(error.localizedDescription)"
                        }
                    }
                }else {
                    DispatchQueue.main.async {
                        self.dataTV.text = "Dữ liệu bạn nhập vào không chính xác"
                        self.valueTV.text = "Dữ liệu bạn nhập vào không chính xác"
                    }
                }
            }
        case .Visa:
            AdmAI_Manager.shared.getVisa(image: image) { [weak self] data, value, error in
                guard let self = self else { return }
                self.handleDataResponse(data: data, value: value, error: error)
            }
        case .Retail:
            AdmAI_Manager.shared.getRetail(image: image) { [weak self] data, value, error in
                guard let self = self else { return }
                self.handleDataResponse(data: data, value: value, error: error)
            }
        case .Ielts:
            AdmAI_Manager.shared.getIeltsCertificate(image: image){ [weak self] data, value, error in
                guard let self = self else { return }
                self.handleDataResponse(data: data, value: value, error: error)
            }
        case .Driver:
            AdmAI_Manager.shared.getDriver(image: image){ [weak self] data, value, error in
                guard let self = self else { return }
                self.handleDataResponse(data: data, value: value, error: error)
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

//MARK: DocumentPicker
extension OCRDetailViewController: UIDocumentPickerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        let imageURL = urls[0]
        dataTV.text = ""
        valueTV.text = ""
        activityView.isHidden = false
        activityView.startAnimating()
        if FileManager.default.fileExists(atPath: imageURL.path) {
            if let image = UIImage(contentsOfFile: imageURL.path) {
                ocrImage.image = image
            }else {
                print("Lỗi khởi tạo ảnh từ file")
            }
        }else {
            print("Đường dẫn file ảnh bị lỗi")
        }
        switch ocrTypes {
        case .CardID:
            AdmAI_Manager.shared.getIDCard(fileLocal: imageURL) { [weak self] data, value , error in
                guard let self = self else { return }
                self.handleDataResponse(data: data, value: value, error: error)
            }
        case .RegisterCar:
            AdmAI_Manager.shared.getRegisterCar(fileLocal: imageURL) { [weak self] data, value , error in
                guard let self = self else { return }
                self.handleDataResponse(data: data, value: value, error: error)
            }
        case .Health:
            AdmAI_Manager.shared.getHealth(fileLocal: imageURL) { [weak self] data, value , error in
                guard let self = self else { return }
                self.handleDataResponse(data: data, value: value, error: error)
            }
        case .RegistryCar:
            AdmAI_Manager.shared.getRegistryCar(fileLocal: imageURL) { [weak self] data, value , error in
                guard let self = self else { return }
                self.handleDataResponse(data: data, value: value, error: error)
            }
        case .Expenses:
            AdmAI_Manager.shared.getExpenses(fileLocal: imageURL) { [weak self] data, value , error in
                guard let self = self else { return }
                self.handleDataResponse(data: data, value: value, error: error)
            }
        case .Business:
            AdmAI_Manager.shared.getBusinessRegister(fileLocal: imageURL) { [weak self] data, value , error in
                guard let self = self else { return }
                self.handleDataResponse(data: data, value: value, error: error)
            }
        case .KVP:
            AdmAI_Manager.shared.getKeyValuePair(fileLocal: imageURL) { [weak self] data, value , error in
                guard let self = self else { return }
                self.handleDataResponse(data: data, value: value, error: error)
            }
        case .Tabular:
            AdmAI_Manager.shared.getTabular(fileLocal: imageURL) { [weak self] data, value , error in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.activityView.isHidden = true
                    self.activityView.stopAnimating()
                }
                if let data = data, let value = value {
                    let stringValue = self.valueHandler.tabularStringValue(from: value)
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                        if let jsonString = String(data: jsonData, encoding: .utf8){
                            DispatchQueue.main.async {
                                self.dataTV.text = jsonString
                                self.valueTV.text = stringValue
                            }
                        }
                    }catch {
                        DispatchQueue.main.async {
                            self.dataTV.text = "Error converting dictionary to JSON string: \(error.localizedDescription)"
                            self.valueTV.text = "Error converting dictionary to JSON string: \(error.localizedDescription)"
                        }
                    }
                }else {
                    DispatchQueue.main.async {
                        self.dataTV.text = "Dữ liệu bạn nhập vào không chính xác"
                        self.valueTV.text = "Dữ liệu bạn nhập vào không chính xác"
                    }
                }
            }
        case .Passport:
            AdmAI_Manager.shared.getPassport(fileLocal: imageURL) { [weak self] data, error in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.activityView.isHidden = true
                    self.activityView.stopAnimating()
                }
                if let data = data {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                        if let jsonString = String(data: jsonData, encoding: .utf8){
                            DispatchQueue.main.async {
                                self.dataTV.text = jsonString
                                self.valueTV.text = "Chưa hỗ trợ lấy thông tin chi tiết"
                            }
                        }
                    }catch {
                        DispatchQueue.main.async {
                            self.dataTV.text = "Error converting dictionary to JSON string: \(error.localizedDescription)"
                            self.valueTV.text = "Error converting dictionary to JSON string: \(error.localizedDescription)"
                        }
                    }
                }else {
                    DispatchQueue.main.async {
                        self.dataTV.text = "Dữ liệu bạn nhập vào không chính xác"
                        self.valueTV.text = "Dữ liệu bạn nhập vào không chính xác"
                    }
                }
            }
        case .Visa:
            AdmAI_Manager.shared.getVisa(fileLocal: imageURL) { [weak self] data, value , error in
                guard let self = self else { return }
                self.handleDataResponse(data: data, value: value, error: error)
            }
        case .Retail:
            AdmAI_Manager.shared.getRetail(fileLocal: imageURL) { [weak self] data, value , error in
                guard let self = self else { return }
                self.handleDataResponse(data: data, value: value, error: error)
            }
        case .Ielts:
            AdmAI_Manager.shared.getIeltsCertificate(fileLocal: imageURL) { [weak self] data, value , error in
                guard let self = self else { return }
                self.handleDataResponse(data: data, value: value, error: error)
            }
        case .Driver:
            AdmAI_Manager.shared.getDriver(fileLocal: imageURL){ [weak self] data, value, error in
                guard let self = self else { return }
                self.handleDataResponse(data: data, value: value, error: error)
            }
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
