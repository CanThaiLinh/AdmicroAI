//
//  SpeechDetailViewController.swift
//  AdmicroAI_Demo
//
//  Created by Nguyễn Đình Việt on 22/11/2023.
//

import UIKit
import AdmicroAI
import AVFoundation

class SpeechDetailViewController: UIViewController {
    
    let valueHandler = ValueHanderString()
    var titleHeader: String = ""
    var clickCopyData = true
    var clickCopyValue = true
    var player: AVPlayer!
    var audioFile = ""
    
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet weak var dataButton: UIButton!
    @IBOutlet weak var copyDataButton: UIButton!
    @IBOutlet weak var copyValueButton: UIButton!
    @IBOutlet weak var dataTV: UITextView!
    @IBOutlet weak var valueTV: UITextView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var audioView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        urlTextField.addPadding(.left(15))
        setUpLayer()
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
    @IBAction func openFolderOnClick(_ sender: Any) {
        urlTextField.resignFirstResponder()
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.wav, .mp3])
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .overFullScreen
        documentPicker.allowsMultipleSelection = true
        present(documentPicker, animated: true)
    }
    @IBAction func convertDataOnClick(_ sender: Any) {
        dataTV.text = ""
        valueTV.text = ""
        urlTextField.resignFirstResponder()
        activityView.isHidden = false
        activityView.startAnimating()
        guard let urlString = urlTextField.text else { return }
        if !urlString.isEmpty {
            AdmAI_Manager.shared.speechToText(linkOnline: urlString) { [weak self] data, result, error in
                guard let self = self else { return }
                self.handleDataResponse(data: data, value: result, error: error)
            }
            audioFile = urlString
        }
        urlTextField.text = ""
        dataButton.backgroundColor = UIColor.backgroundColorAlphaBT()
    }
    @IBAction func playOnClick(_ sender: Any) {
        guard let audioURL = URL(string: audioFile) else {
            return
        }
        player = AVPlayer(url: audioURL)
        player.play()
    }
}

extension SpeechDetailViewController {
    
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
                        self.topConstraint.constant = 16
                        self.audioView.isHidden = false
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
extension SpeechDetailViewController: UITextFieldDelegate {
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
extension SpeechDetailViewController: UITextViewDelegate {
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

extension SpeechDetailViewController: UIDocumentPickerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        let url = urls[0]
        dataTV.text = ""
        valueTV.text = ""
        activityView.isHidden = false
        activityView.startAnimating()
        AdmAI_Manager.shared.speechToText(fileLocal: url) { [weak self]
            data, result, error in
            guard let self = self else { return }
            self.handleDataResponse(data: data, value: result, error: error)
        }
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("Canceled")
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
