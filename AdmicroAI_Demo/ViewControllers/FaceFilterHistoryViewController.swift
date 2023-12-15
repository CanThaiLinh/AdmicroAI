//
//  FaceFilterHistoryViewController.swift
//  AdmicroAI_Demo
//
//  Created by VietChat on 07/12/2023.
//

import UIKit
import AdmicroAI

class FaceFilterHistoryViewController: UIViewController {

    var titleHeader: String = ""
    var clickCopyData = true
    let valueHandler = ValueHanderString()
    @IBOutlet weak var codeTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var toDatePicker: UIDatePicker!
    @IBOutlet weak var fromDatePicker: UIDatePicker!
    @IBOutlet weak var dataTV: UITextView!
    @IBOutlet weak var convertBT: UIButton!
    @IBOutlet weak var copyBT: UIButton!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    func setUp() {
        title = "\(titleHeader)"
        activityView.isHidden = true
        codeTF.layer.borderColor = UIColor.borderColorTF()
        emailTF.layer.borderColor = UIColor.borderColorTF()
        codeTF.addPadding(.left(15))
        emailTF.addPadding(.left(15))
        dataTV.backgroundColor = UIColor.backgroundColorAlphaBT()
        dataTV.delegate = self
        codeTF.delegate = self
        emailTF.delegate = self
        codeTF.becomeFirstResponder()
        convertBT.backgroundColor = UIColor.backgroundColorAlphaBT()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward.circle"), style: .plain, target: self, action: #selector(backAction))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.backgroundColorBT()
        print(toDatePicker.date)
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    @objc func backAction() {
        navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func convertOnClick(_ sender: Any) {
        activityView.isHidden = false
        activityView.startAnimating()
        dataTV.text = ""
        let dateStringFrom = dateFormat(date: "\(fromDatePicker.date)")
        let dateStringTo = dateFormat(date: "\(toDatePicker.date)")
        guard let code = codeTF.text,
              let number = Int(code),
              let email = emailTF.text,
              !code.isEmpty,
              !email.isEmpty else {
            return
        }
        let emailArray = email.components(separatedBy: ",")
        AdmAI_Manager.shared.faceCheckinFilter(employeeCode: number, fromDate: dateStringFrom, toDate: dateStringTo, listEmail: emailArray) { [weak self] data, error in
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
        
        codeTF.text = ""
        emailTF.text = ""
        convertBT.backgroundColor = UIColor.backgroundColorAlphaBT()
    }
    @IBAction func copyOnClick(_ sender: Any) {
        if clickCopyData {
            copyBT.setImage(UIImage.imageCopy(), for: .normal)
            copyBT.tintColor = UIColor.backgroundColorAlphaBT()
            clickCopyData = false
            UIPasteboard.general.string = dataTV.text
        }
    }
    
    func dateFormat(date: String) -> Int {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        dateFormat.timeZone = TimeZone(abbreviation: "UTC")
        
        if let date = dateFormat.date(from: date) {
            return Int(date.timeIntervalSince1970)
        }else {
            return 0
        }
    }
}

extension FaceFilterHistoryViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor =  UIColor(red: 0.17, green: 0.53, blue: 0.40, alpha: 1.00).cgColor
    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let email = (emailTF.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let code = (codeTF.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        if !email.isEmpty && !code.isEmpty {
            convertBT.backgroundColor = UIColor.backgroundColorBT()
        }else {
            convertBT.backgroundColor = UIColor.backgroundColorAlphaBT()
        }
    }
}

extension FaceFilterHistoryViewController: UITextViewDelegate {
    func textViewDidChangeSelection(_ textView: UITextView) {
        let isDataEmpty = dataTV.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        copyBT.isHidden = isDataEmpty
        copyBT.setImage(UIImage.imageCopyAlpha(), for: .normal)
        copyBT.tintColor = UIColor.backgroundColorBT()
    }
}

