//
//  Constants.swift
//  AdmicroAI_Demo
//
//  Created by VietChat on 17/11/2023.
//

import UIKit

extension UIColor {
    
    static func borderColorAlphaTF() -> CGColor {
        return UIColor(red: 0.93, green: 0.94, blue: 0.96, alpha: 0.3).cgColor
    }
    
    static func borderColorTF() -> CGColor {
        return UIColor(red: 0.93, green: 0.94, blue: 0.96, alpha: 1.00).cgColor
    }
    
    static func backgroundTV() -> UIColor {
        return UIColor(red: 0.17, green: 0.53, blue: 0.40, alpha: 0.1)
    }
    
    static func backgroundColorAlphaBT() -> UIColor {
        return UIColor(red: 0.17, green: 0.53, blue: 0.40, alpha: 0.3)
    }
    
    static func backgroundColorBT() -> UIColor {
        return UIColor(red: 0.17, green: 0.53, blue: 0.40, alpha: 1)
    }
    
    static func tintColor() -> UIColor {
        UIColor(red: 0.83, green: 0.77, blue: 0.98, alpha: 1.00)
    }
    
    static func untintColor() -> UIColor {
        UIColor(red: 0.83, green: 0.77, blue: 0.98, alpha: 0.3)
    }
    
    static func barColor() -> UIColor {
        UIColor(red: 0.00, green: 0.42, blue: 0.46, alpha: 1)
    }
}

extension UIImage {
    static func imageCopyAlpha() -> UIImage {
        return UIImage(systemName: "doc.on.doc")!
    }
    
    static func imageCopy() -> UIImage {
        return UIImage(systemName: "doc.on.doc.fill")!
    }
}

enum SpeechTypes: String, CaseIterable {
    case SpeechToText
    case TextToSpeech
    
    var title: String {
        switch self {
        case .SpeechToText:
            return "Giọng nói thành văn bản"
        case .TextToSpeech:
            return "Văn bản thành giọng nói"
        }
    }
}

enum OCRTypes: String, CaseIterable {
    case CardID
    case RegisterCar
    case Health
    case RegistryCar
    case Expenses
    case Business
    case KVP
    case Tabular
    case Passport
    case Visa
    case Retail
    case Ielts
    case Driver
    
    var title: String {
        switch self {
        case .CardID:
            return "CMT/CCCD"
        case .RegisterCar:
            return "Đăng kí xe"
        case .Health:
            return "BHYT"
        case .RegistryCar:
            return "Đăng kiểm xe"
        case .Expenses:
            return "Uỷ nhiệm chi"
        case .Business:
            return "Đăng kí doanh nghiệp"
        case .KVP:
            return "Key Valie Pair"
        case .Tabular:
            return "Dữ liệu dạng bảng"
        case .Passport:
            return "Passport"
        case .Visa:
            return "Visa"
        case .Retail:
            return "Hoá đơn bán lẻ"
        case .Ielts:
            return "Ielts"
        case .Driver:
            return "Bằng lái xe"
        }
    }
}

enum FaceTypes: String, CaseIterable {
    case FaceRegister
    case FacePredict
    case FaceHistory
    case FaceFilter
    case FaceGetInfo
    case FaceUpdate
    case FaceFas
    case FaceCompare
    
    var title: String {
        switch self {
        case .FaceRegister:
            return "Đăng ký khuôn mặt"
        case .FacePredict:
            return "Nhận diên khuôn mặt"
        case .FaceHistory:
            return "Lịch sử checkin"
        case .FaceFilter:
            return "Lọc lịch sử check in"
        case .FaceGetInfo:
            return "Lấy thông tin người dùng"
        case .FaceUpdate:
            return "Cập nhật thông tin người dùng"
        case .FaceFas:
            return "Check giả mạo"
        case .FaceCompare:
            return "So sánh độ tương đồng 2 khuôn mặt"
        }
    }
}
