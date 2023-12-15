//
//  ValueHanderString.swift
//  AdmicroAI_Demo
//
//  Created by Nguyễn Đình Việt on 19/11/2023.
//

import AdmicroAI

class ValueHanderString {
    func stringValue(from value: Any?) -> String {
        guard let value = value else { return "" }
        
        if let idCardValue = value as? IDCardValue {
            return idCardStringValue(from: idCardValue)
        } else if let carValue = value as? RegisterCarValue {
            return registerCarStringValue(from: carValue)
        } else if let carValue = value as? RegistryCarValue {
            return registryCarStringValue(from: carValue)
        } else if let expenses = value as? ExpensesValue {
            return expensesStringValue(from: expenses)
        } else if let business = value as? BusinessRegisterValue {
            return businessStringValue(from: business)
        } else if let kvp = value as? KeyValuePairValue {
            return keyValuePairStringValue(from: kvp)
        }else if let ielts = value as? IeltsValue {
            return ieltsStringValue(from: ielts)
        } else if let health = value as? HealthValue {
            return healthStringValue(from: health)
        }else if let speech = value as? SpeechToTextResult {
            return speechToTextString(from: speech)
        }else if let history = value as? [FaceCheckinHistoryData] {
            return faceHistory(from: history)
        }else if let info = value as? FaceInfoData {
            return faceInfo(from: info)
        }else if let filter = value as? [FaceFilterCheckinData] {
            return faceFilter(from: filter)
        }
        
        return ""
    }
    
    private func speechToTextString(from value: SpeechToTextResult) -> String {
        var stringValue = ""
        var stringText = ""
        var start = ""
        var stop = ""
        var text = ""
        
        for item in value.text {
            start = item.start
            stop = item.stop
            text = item.text
            
            stringText += """
            Bắt đầu: \(start)
            Kết thúc: \(stop)
            Văn bản: \(text)
        
        """
        }
        
        stringValue = """
            Độ dài: \(value.duration)
            Thời gian: \(value.inferTime)
            Danh sách text theo thời gian
        \(stringText)
        """
                
        return stringValue
    }
    
    func textToSpeechString(from value: TextToSpeechData) -> String {
        var stringValue = ""
        
        stringValue = """
            FilePath: \(value.filePath ?? "Đã trả ra audio")
            Audio: \(value.audio ?? "Đã trả ra filepath")
            Thông tin đầu vào:
            Text: \(value.info.text)
            ID: \(value.info.id)
            Sample Rate: \(value.info.sampleRate)
            Format: \(value.info.format)
        """
        
        return stringValue
    }
    
    func faceHistory(from value: [FaceCheckinHistoryData]) -> String {
        var stringValue = ""
        for item in value {
            stringValue += """
            
            Checkin Time: \(item.checkinTimeFormatter())
            Email: \(item.email)
            Employee Code: \(item.employeeCode)
            Link: \(item.link)
            Name: \(item.name)
            Probability: \(item.probability)
            ImageID: \(item.imageId)
            
            """
        }
        return stringValue
    }
    
    func faceFilter(from value: [FaceFilterCheckinData]) -> String {
        var stringValue = ""
        for item in value {
            stringValue += """
            
            Checkin Time: \(item.checkinTimeFormatter())
            Email: \(item.email)
            Employee Code: \(item.employeeCode)
            Link: \(item.link)
            Name: \(item.name)
            Probability: \(item.probability)
            ImageID: \(item.imageId)
            
            """
        }
        return stringValue
    }
    
    func faceInfo(from value: FaceInfoData) -> String {
        return """
            Employee Code: \(value.employeeCode)
            Name: \(value.name)
            Email: \(value.email)
            Face Mask: \(value.faceMask)
            
            """
    }
    
    func tabularStringValue(from tabularValue: [TabularDataResult]) -> String {
        var stringValue = ""
        var boxes = ""
        var key = ""
        var value = ""
        for item in tabularValue {
            var number = ""
            for box in item.boxes {
                number += "\(box), "
            }
            boxes = number
            key = item.key
            value = item.value
            
            stringValue += """
            Boxes \(boxes)
            Table: \(key)
            Dữ liệu: \(value)
        
        """
        }
        return stringValue
    }
    
    private func idCardStringValue(from idCardValue: IDCardValue) -> String {
        return """
            NumberID: \(idCardValue.numberID)
            Họ tên: \(idCardValue.fullName)
            Ngày sinh: \(idCardValue.birthDay)
            Giới tính: \(idCardValue.sex)
            Quốc tịch: \(idCardValue.nationality)
            Địa chỉ: \(idCardValue.domicireAddress)
            Địa chỉ thường trú: \(idCardValue.permanentAddress)
            Hạn sử dụng: \(idCardValue.dueDate)
        """
    }
    
    private func registerCarStringValue(from carValue: RegisterCarValue) -> String {
        return """
            Tên chủ xe: \(carValue.fullName)
            Số máy: \(carValue.engineN)
            Địa chỉ: \(carValue.address)
            Số CCCD/ Hộ chiếu: \(carValue.passport)
            Số khung: \(carValue.chassisN)
            Nhãn hiệu: \(carValue.brand)
            Loại xe: \(carValue.type)
            Số loại: \(carValue.modelCode)
            Màu sơn: \(carValue.color)
            Số người được phép trở: \(carValue.seatCapacity)
            Dung tích xi lanh: \(carValue.capacity)
            Công suất: \(carValue.powerHorse)
            Năm sản xuất: \(carValue.yearManufacture)
            Tự trọng: \(carValue.emptyWeight)
            Dài: \(carValue.length)
            Rộng: \(carValue.width)
            Cao: \(carValue.height)
            Số chỗ ngồi: \(carValue.sit)
            Đứng: \(carValue.stand)
            Nằm: \(carValue.lie)
            Hàng hoá: \(carValue.goods)
            Nguồn gốc: \(carValue.origin)
            Biển số đăng kí: \(carValue.plateN)
            Đăng kí lần đầu ngày: \(carValue.firstRegister)
            Đăng kí có giá trị đến: \(carValue.dateOfExpiry)
            Số: \(carValue.number)
        """
    }
    
    private func registryCarStringValue(from value: RegistryCarValue) -> String {
        return """
            Biển đăng kí: \(value.registryNumber)
            Số quản lý: \(value.vehicleNo)
            Loại phương tiện: \(value.type)
            Nhãn hiệu: \(value.mark)
            Số loại: \(value.modelCode)
            Số máy: \(value.engineNumber)
            Số khung: \(value.chassisNumber)
            Năm/ nước sản xuất: \(value.manufacturedYear)
            Niên hạn SD: \(value.lifeTime)
            Kinh doanh vận tải: \(value.commercialUse)
            Cải tạo: \(value.modification)
            Công thức bánh xe: \(value.wheelFormula)
            Vết bánh xe: \(value.wheelTread)
            Kích thước bao: \(value.overallDimension)
            Kích thước lòng thùng xe: \(value.insideCargo)
            Chiều dài cơ sở: \(value.wheelBase)
            Khối lượng bản thân: \(value.kerbMass)
            Khối lượng hàng CC theo TK/CP TGGT: \(value.designPay)
            Khối lượng toàn bộ theo TK/CP TGGT: \(value.designTotal)
            Khối lượng kéo theo TK/CP TGGT: \(value.designTowed)
            Số người cho phép trở: \(value.permissibleNo)
            Loại nhiên liệu: \(value.typeFuelUse)
            Thể tích động cơ: \(value.engineDis)
            Công suất lớn nhất: \(value.outputRpm)
            Số sêri: \(value.seriNo)
            Số lượng lốp, cỡ lốp, trục: \(value.tireNumber)
            Số phiếu kiểm định: \(value.inspectionReport)
            Có hiệu lực đến hết ngày: \(value.validUntil)
            Ngày đăng kí( TP/ Ngày): \(value.issuedOnDay)
            Lắp thiết bị giám sát hành trình: \(value.equippedTachograp)
            Lắp Camera: \(value.equippedCamera)
            Không cấp team kiểm định: \(value.inspectionStamp)
            Ghi chú: \(value.note)
        """
    }
    
    private func expensesStringValue(from expenses: ExpensesValue) -> String {
        return """
            Tên giấy tờ: \(expenses.nameDocument)
            Liên 1 Ngân hàng dữ: \(expenses.forInternate)
            Ngày: \(expenses.date)
            Tại ngân hàng: \(expenses.bankName)
            Phí trong: \(expenses.includingFee)
            Số tiền bằng số: \(expenses.amountFigures)
            Số tiền bằng chứ: \(expenses.amountWords)
            Nội dung: \(expenses.details)
        """
    }
    
    private func businessStringValue(from business: BusinessRegisterValue) -> String {
        return """
            Tên doanh nghiệp: \(business.nameBusiness)
            Tên nước ngoài: \(business.nameForeign)
            Tên viết tắt: \(business.nameAbbrevi)
            Mã số doanh nghiệp: \(business.numberBusiness)
            Ngày đăng ký: \(business.dateRegister)
            Ngày thay đổi: \(business.dateChange)
            Địa chỉ: \(business.address)
            Điện thoại: \(business.phone)
            Fax: \(business.fax)
            Email: \(business.email)
            Website: \(business.website)
            Vốn điều lệ: \(business.authorizedCapital)
            Mệnh giá cổ phần: \(business.parValue)
            Tổng số cổ phần: \(business.totalParValue)
            Họ tên người đại diện: \(business.nameRepresentative)
            Chức danh người đại diện: \(business.titleRepresentative)
            Giới tính: \(business.sex)
            Ngày sinh: \(business.birthDay)
            Dân tộc: \(business.nation)
            Quốc tịch: \(business.nationality)
            Loại giấy tờ: \(business.typeDocument)
            Số giấy tờ: \(business.numberDocument)
            Ngày cấp: \(business.date)
            Nơi cấp: \(business.issuedBy)
            Địa chỉ hộ khẩu: \(business.addressHouse)
            Nơi ở hiện tại: \(business.addressCurrent)
        """
    }
    
    private func keyValuePairStringValue(from kvp: KeyValuePairValue) -> String {
        return """
            Họ tên: \(kvp.fullName)
            Phái Nam tuổi: \(kvp.ageSex)
            Địa chỉ: \(kvp.address)
            Chẩn đoán: \(kvp.diagnostic)
        """
    }
    
    private func ieltsStringValue(from ielts: IeltsValue) -> String {
        return """
            Loại: \(ielts.type)
            Số trung tâm: \(ielts.numberCentre)
            Mã số thí sinh: \(ielts.numberCandidate)
            Ngày đăng ký: \(ielts.dateRegister)
            Tên thí sinh: \(ielts.nameFamily)
            Họ tên: \(ielts.nameFirst)
            ID học viên: \(ielts.candidateID)
            Ngày sinh: \(ielts.birthDay)
            Giới tính: \(ielts.sex)
            Mã chương trình: \(ielts.schemeCode)
            Quốc tịch: \(ielts.countryNati)
            Ngôn ngữ đầu tiên: \(ielts.firstLang)
            Điểm tổng thể: \(ielts.overallBand)
            Cấp bậc CEFR: \(ielts.cefrLevel)
            Điểm viết: \(ielts.writing)
            Điểm nghe: \(ielts.listening)
            Điểm đọc: \(ielts.reading)
            Điểm nói: \(ielts.speaking)
            Số báo cáo thực nghiệm: \(ielts.numberTest)
            Ngày thực nghiệm: \(ielts.dateTest)
        """
    }
    
    private func healthStringValue(from health: HealthValue) -> String {
        return """
            Số BHYT: \(health.number)
            Họ tên: \(health.name)
            Ngày sinh: \(health.birthDay)
            Giới tính: \(health.sex)
            Địa chỉ: \(health.address)
            Nơi đăng kí khám chữa bệnh: \(health.addressKCB)
            Mã đăng kí: \(health.numberCode)
            Hạn sử dụng: \(health.date)
            Ngày phát hành: \(health.dateRegister)
        """
    }
    
    private func retailStringValue(from value: RetailValue) -> String {
        return """
            ID: \(value.id)
            Name: \(value.name)
            Ngày sinh: \(value.dateBirth)
            Quốc tịch: \(value.nationality)
            Địa chỉ: \(value.address)
            Tỉnh: \(value.place)
            Ngày bắt đầu: \(value.dateIssue)
            Hạn sử dụng: \(value.expiryDate)
            Lớp: \(value.classs)
        """
    }
    
    private func visaStringValue(from value: VisaValue) -> String {
        return """
            Số: \(value.numberID)
            Ký hiệu: \(value.sign)
            Có giá trị từ ngày: \(value.dateValid)
            Đến ngày: \(value.dateTo)
            Sử dụng nhiều lần / một lần: \(value.useCard)
            Cấp cho người mang hộ chiếu số: \(value.passportNo)
            Cấp tại: \(value.productAt)
            Ngày cấp: \(value.dateRange)
        """
    }
}


