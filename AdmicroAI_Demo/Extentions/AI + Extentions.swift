//
//  AI + Extentions.swift
//  AdmicroAI_Demo
//
//  Created by Admin on 07/12/2023.
//

import Foundation
import AdmicroAI
import UIKit

extension SpeechSpeakerID {
        public var title: String {
            switch self {
            case .MinhPhuong:
                return "Hà Nội - Minh Phương"
            case .QuocKhanh:
                return "Hà Nội - Quốc Khánh"
            case .HoangAnhQuan:
                return "Hà Nội - Hoàng Anh Quân"
            case .VanHoang:
                return "Hà Nội - Văn Hoàng"
            case .ThanhThao:
                return "Hồ Chí Minh - Thanh Thảo"
            case .MinhHoa:
                return "Hồ Chí Minh - Minh Hoà"
            @unknown default:
                return ""
            }
        }
    
        public var speakerID: String {
            switch self {
            case .MinhPhuong:
                return "hn_minhphuong"
            case .QuocKhanh:
                return "hn_quockhanh"
            case .HoangAnhQuan:
                return "hn_hoanganhquan"
            case .VanHoang:
                return "hn_vanhoang"
            case .ThanhThao:
                return "hcm_thanhthao"
            case .MinhHoa:
                return "hcm_minhhoa"
            @unknown default:
               return ""
            }
        }
    
        static func caseAtIndex(index: Int) -> SpeechSpeakerID {
            switch index {
            case 0: return .MinhPhuong
            case 1: return .QuocKhanh
            case 2: return .HoangAnhQuan
            case 3: return .VanHoang
            case 4: return .ThanhThao
            case 5: return .MinhHoa
            default: return .MinhPhuong
            }
        }
}

extension SpeechSampleRate {
        public var title: String {
            switch self {
            case .Rate8000:
                return "8000"
            case .Rate16000:
                return "16000"
            case .Rate22050:
                return "22050"
            case .Rate44100:
                return "44100"
            case .Rate48000:
                return "48000"
            default:
                return ""
            }
        }
    
        public var rate: Int {
            switch self {
            case .Rate8000:
                return 8000
            case .Rate16000:
                return 16000
            case .Rate22050:
                return 22050
            case .Rate44100:
                return 44100
            case .Rate48000:
                return 48000
            default:
                return 0
            }
        }
    
        static func caseAtIndex(index: Int) -> SpeechSampleRate {
            switch index {
            case 0: return .Rate8000
            case 1: return .Rate16000
            case 2: return .Rate22050
            case 3: return .Rate44100
            case 4: return .Rate48000
            default: return .Rate16000
            }
        }
}

extension SpeechFormat {
    public var title: String {
        switch self {
        case .wav:
            return "Wav"
        case .mp3:
            return "Mp3"
        case .mp4:
            return "Mp4"
        case .m4a:
            return "M4a"
        default:
            return ""
        }
    }
    
    public var format: String {
        switch self {
        case .wav:
            return "wav"
        case .mp3:
            return "mp3"
        case .mp4:
            return "mp4"
        case .m4a:
            return "m4a"
        default:
            return ""
        }
    }
    
    static func caseAtIndex(index: Int) -> SpeechFormat {
        switch index {
        case 0: return .wav
        case 1: return .mp3
        case 2: return .mp4
        case 3: return .m4a
        default: return .wav
        }
    }
}
