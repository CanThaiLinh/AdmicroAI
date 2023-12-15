//
//  SpeechTTSViewController.swift
//  AdmicroAI_Demo
//
//  Created by VietChat on 16/11/2023.
//

import UIKit
import AdmicroAI
import AVFoundation

class SpeechTTSViewController: UIViewController {
    
    let valueHandler = ValueHanderString()
    var clickCopy = true
    var clickValueCopy = true
    var isCheck = true
    
    var speakType: [SpeechSpeakerID] = SpeechSpeakerID.allCases
    var rateType: [SpeechSampleRate] = SpeechSampleRate.allCases
    var formatType: [SpeechFormat] = SpeechFormat.allCases
    
    var selectSpeak = 0
    var selectRate = 0
    var selectFormat = 0
    var player: AVPlayer!
    var audioFile = ""
    
    @IBOutlet weak var textTF: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var valueTV: UITextView!
    @IBOutlet weak var textSpeechButton: UIButton!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet weak var copyButton: UIButton!
    @IBOutlet weak var copyValueButton: UIButton!
    @IBOutlet weak var speakPicker: UIPickerView!
    @IBOutlet weak var ratePicker: UIPickerView!
    @IBOutlet weak var formatPicker: UIPickerView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var audioView: UIView!
    @IBOutlet weak var audioButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textTF.addPadding(.left(15))
        setUpLayer()
        
    }
    
    func setUpLayer() {
        title = "Chuyển đổi văn bản sang giọng nói"
        activityView.isHidden = true
        textSpeechButton.backgroundColor = UIColor.backgroundColorAlphaBT()
        textTF.layer.borderColor = UIColor.borderColorTF()
        textView.backgroundColor = UIColor.backgroundTV()
        valueTV.backgroundColor = UIColor.backgroundTV()
        textTF.delegate = self
        textTF.becomeFirstResponder()
        textView.delegate = self
        valueTV.delegate = self
        speakPicker.delegate = self
        ratePicker.delegate = self
        formatPicker.delegate = self
        speakPicker.dataSource = self
        ratePicker.dataSource = self
        formatPicker.dataSource = self
        audioView.isHidden = true
        topConstraint.constant = -32
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

    @IBAction func playOnClick(_ sender: UIButton) {
        if let audioURL = URL(string: audioFile) {
            player = AVPlayer(url: audioURL)
        }
        player.play()
    }
    
    @IBAction func textToSpeechButton(_ sender: Any) {
        self.view.endEditing(true)
        isCheck = true
        textTF.resignFirstResponder()
        textView.text = ""
        valueTV.text = ""
        activityView.isHidden = false
        activityView.startAnimating()
        guard let text = textTF.text, !text.isEmpty else {
            return
        }
        AdmAI_Manager.shared.textToSpeech(text: text, speakerID: SpeechSpeakerID.caseAtIndex(index: selectSpeak), sampleRate: SpeechSampleRate.caseAtIndex(index: selectRate), outputFormat: SpeechFormat.caseAtIndex(index: selectFormat)) { [weak self] data, value, error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.activityView.isHidden = true
                self.activityView.stopAnimating()
                if self.isCheck {
                    self.textView.text = "Thông tin bạn nhập chưa chính xác"
                }
            }
            if let data = data, let value = value {
                let stringValue = self.valueHandler.textToSpeechString(from: value)
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                    if let jsonString = String(data: jsonData, encoding: .utf8) {
                        DispatchQueue.main.async { [self] in
                            self.textView.text = jsonString
                            self.valueTV.text = stringValue
                            self.topConstraint.constant = 4
                            self.audioView.isHidden = false
                        }
                    }
                    self.audioFile = value.filePath ?? ""
                    self.isCheck = false
                } catch {
                    DispatchQueue.main.async {
                        self.textView.text = "Error converting dictionary to JSON string: \(error.localizedDescription)"
                    }
                }
            }else {
                DispatchQueue.main.async {
                    self.textView.text = "Dữ liệu bạn nhập vào không chính xác"
                    self.valueTV.text = "Dữ liệu bạn nhập vào không chính xác"
                }
            }
        }
        
        textTF.text = ""
        textSpeechButton.backgroundColor = UIColor.backgroundColorAlphaBT()
    }
    
    @IBAction func copyOnClick(_ sender: Any) {
        if clickCopy {
            copyButton.setImage(UIImage(systemName: "doc.on.doc.fill"), for: .normal)
            copyButton.tintColor = UIColor.backgroundColorAlphaBT()
            clickCopy = false
            UIPasteboard.general.string = textView.text
        }
    }
    @IBAction func copyValueOnClick(_ sender: Any) {
        if clickValueCopy {
            copyValueButton.setImage(UIImage(systemName: "doc.on.doc.fill"), for: .normal)
            copyValueButton.tintColor = UIColor.backgroundColorAlphaBT()
            clickValueCopy = false
            UIPasteboard.general.string = valueTV.text
        }
    }
}

extension SpeechTTSViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor =  UIColor(red: 0.17, green: 0.53, blue: 0.40, alpha: 1.00).cgColor
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let text = (textTF.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        if !text.isEmpty {
            textSpeechButton.backgroundColor = UIColor.backgroundColorBT()
        }else {
            textSpeechButton.backgroundColor = UIColor.backgroundColorAlphaBT()
        }
    }
}

extension SpeechTTSViewController: UITextViewDelegate {
    func textViewDidChangeSelection(_ textView: UITextView) {
        let isDataEmpty = textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        let isValueEmpty = valueTV.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        
        copyButton.isHidden = isDataEmpty
        copyButton.setImage(UIImage(systemName: "doc.on.doc"), for: .normal)
        copyButton.tintColor = UIColor.backgroundColorBT()
        
        copyValueButton.isHidden = isValueEmpty
        copyValueButton.setImage(UIImage(systemName: "doc.on.doc"), for: .normal)
        copyValueButton.tintColor = UIColor.backgroundColorBT()
    }
}

extension SpeechTTSViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case speakPicker:
            return speakType.count
        case ratePicker:
            return rateType.count
        case formatPicker:
            return formatType.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case speakPicker:
            return speakType[row].title
        case ratePicker:
            return rateType[row].title
        case formatPicker:
            return formatType[row].title
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        switch pickerView {
        case speakPicker:
            label.text = "\(speakType[row].title)"
        case ratePicker:
            label.text  = "\(rateType[row].title)"
        case formatPicker:
            label.text = "\(formatType[row].title)"
        default:
            label.text = ""
        }
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case speakPicker:
            selectSpeak = row
        case ratePicker:
            selectRate = row
        case formatPicker:
            selectFormat = row
        default:
            selectSpeak = 0
            selectRate = 0
            selectFormat = 0
        }
    }
}
