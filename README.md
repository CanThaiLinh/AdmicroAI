# AdmicroAI
# Mô tả

## Version

- **Number:** 1.0.0
- **Type:** Developing

## Demo

- **GitHub:**

## Changelog

| ID | Version | Status | Summary |
| --- | --- | --- | --- |
| 1 | 0.1.1 | Developing | Speech, Ocr |
| 2 | 1.0.0 | Developing | Speech, Ocr |
| 3 | 1.0.1 | Developing | Face        |

## Yêu cầu

- Tối thiểu Xcode 13 trở lên
- Language Version: Swift 5

### Quyền truy cập

- **NSAllowsArbitraryLoads = YES**: để disable App Transport Security
- **NSLocationAlwaysandWhenInUseUsageDescription**: Để cấp quyền vị trí khi sử dụng Face( Nhận diện khuôn mặt)

**Chú ý:** Bạn phải chủ động xin cấp quyền từ người dùng, SDK không tự cấp quyền từ người dùng

# Hướng dẫn tích hợp

## Import SDK vào trong dự án

**AdmicroAI** đang khả dụng trên [CocoaPods](https://cocoapods.org) và [Carthage](https://github.com/Carthage/Carthage)

 Để cài đặt hãy thêm thông tin sau vào Podfile:

```swift
pod 'AdmicroAI'

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
        end
    end
end
```

Hoặc thêm vào Cartfile

```swift

```

## Khởi động SDK

Tiến hành kích hoạt SDK, việc này nên được thực hiện tại **didFinishLaunchingWithOptions** của **AppDegate**

```swift
import AdmicroAI

AdmAI_Manager.shared.register(email: "", password: "")
AdmAI_Manager.shared.enableDebugLog()
AdmAI_Manager.shared.delegate = self
AdmAI_Manager.shared.start()

```

Để có thể sử dụng các tính năng của **OCR**, **Speech** thì cần đăng kí username, password trước( nếu mà không cần sử dụng đến thì không cần đăng kí)

Username và password được cấp từ bên hỗ trợ

# Speech

## Speech To Text (Link Online)

Để sử dụng speechToText thì bạn cần truyền vào url của file **audio (.wav).** 

```swift
AdmAI_Manager.shared.speechToText(linkOnline: "url to file audio") { data, result, error in
    if let data = data, let value = value {
        do {
	    let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
		if let jsonString = String(data: jsonData, encoding: .utf8){
		    print(jsonString)
		}
	}catch {
            print("error")
        }
    }else {
	print("error")
    }
}
```

- **data:** Trở ra cục json
- **value:** Trả ra trong **results** là **SpeechToTextResult** chứa độ dài của audio, chưa các text theo từng khoảng thời gian

## Speech To Text ( File Local )

Để sử dụng speechToText thì bạn cần truyền vào path của file **audio (.wav, .mp3)** trong storage

```swift
AdmAI_Manager.shared.speechToText(fileLocal: "file path") { data, result, error in
    if let data = data, let value = value {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                if let jsonString = String(data: jsonData, encoding: .utf8){
                    print(jsonString)
		}
	}catch {
	    print("error")
	}
    }else {
        print("error")
    }
}
```

- **data:** Trở ra cục json
- **value:** Trả ra trong **results** là **SpeechToTextResult** chứa độ dài của audio, chưa các text theo từng khoảng thời gian

## Text To Speech

Để sử dụng textToSpeech thì bạn cần truyền vào nội dung cần chuyển sang audio.

```swift
AdmAI_Manager.shared.textToSpeech(text: "Nội dụng cần chuyển sang audio") { data, value, error in
  if let data = data, let value = value {
    do {
      let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
      if let jsonString = String(data: jsonData, encoding: .utf8) {
        print(jsonString)
      }
    }catch {
        print("Error")
    }
  }else {
    print("error")
  }
}

```

Nếu bạn muốn truyền vào mã giọng đọc(speakerID), tần số audio(sampleRate), định dạng audio(outputFormat)

```swift
AdmAI_Manager.shared.textToSpeech(text: "Nội dụng cần chuyển sang audio", speakerID: SpeechSpeakerID("Mã ID người đọc"), sampleRate: SpeechSampleRate("Tần số Audio"), outputFormat: SpeechFormat("Định dạng Audio")) { data, value, error in
  if let data = data, let value = value {
    do {
      let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
      if let jsonString = String(data: jsonData, encoding: .utf8) {
        print(jsonString)
      }
    }catch {
        print("Error")
    }
  }else {
    print("error")
  }
}
```

speakerID, sampleRate, outputFormat đều đã được định dạng có sẵn các trường tương ứng với các model

- **speakerID:** SpeechSpeakerID
- **sampleRate:** SpeechSampleRate
- **outputFormat:** SpeechFormat

# Ocr

Tất cả func ocr đều hỗ trợ link online, file trong storage, image trong photo
[Tên hàm][Suffix]

- **linkOnline:** url file online
- **fileLocal:** path file trong storage
- **imageData:** Image Picker-image

```swift
guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
    return
}
```

Kết quả trả về khi success dều là data OCR, bên trong chưa thông tin tương ứng từng loại

```swift
func handleDataResponse(data: Dictionary<String, Any>?, value: Any?, error: APIError?) {
    if let data = data, let value = value {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            if let jsonString = String(data: jsonData, encoding: .utf8){
                print("jsonString")
		print("Model: \(Value)")
            }
        } catch {
            print("Error")
        }
    }else {
        print("Error")
    }
}

```

- **data:** Trả ra cục json tương ứng từng loại
- **value:** Trả ra Model chứa thông tin chi tiết tương ứng từng loại

## Căn cước công dân

- getIDCard[Suffix]
- Example

```swift
AdmAI_Manager.shared.getIDCard(linkOnline: "url file online")
AdmAI_Manager.shared.getIDCard(fileLocal: "path file storage")
AdmAI_Manager.shared.getIDCard(image: "image to Photo")
```

## Đăng kí xe

- getRegisterCar[Suffix]
- Example

```swift
AdmAI_Manager.shared.getRegisterCar(linkOnline: "url file online")
AdmAI_Manager.shared.getRegisterCar(fileLocal: "path file storage")
AdmAI_Manager.shared.getRegisterCar(image: "image to Photo")

```

## Bảo hiểm ý tế

- getHealth[Suffix]
- Example

```swift
AdmAI_Manager.shared.getHealth(linkOnline: "url file online")
AdmAI_Manager.shared.getHealth(fileLocal: "path file storage)
AdmAI_Manager.shared.getHealth(image: "image to Photo")
```

## Đăng kiểm xe

- getRegistryCar[Suffix]
- Example

```swift
AdmAI_Manager.shared.getRegistryCar(linkOnline: "url file online")
AdmAI_Manager.shared.getRegistryCar(fileLocal: "path file storage)
AdmAI_Manager.shared.getRegistryCar(image: "image to Photo")
```

## Uỷ nhiệm chi

- getExpenses[Suffix]
- Example

```swift
AdmAI_Manager.shared.getExpenses(linkOnline: "url file online")
AdmAI_Manager.shared.getExpenses(fileLocal: "path file storage")
AdmAI_Manager.shared.getExpenses(image: "image to Photo")
```

## Đăng kí doanh nghiệp

- getBusinessRegister[Suffix]
- Example

```swift
AdmAI_Manager.shared.getBusinessRegister(linkOnline: "url file online")
AdmAI_Manager.shared.getBusinessRegister(fileLocal: "path file storage")
AdmAI_Manager.shared.getBusinessRegister(image: "image to Photo")

```

## Key Value Pair

- getKeyValuePair[Suffix]
- Example

```swift
AdmAI_Manager.shared.getKeyValuePair(linkOnline: "url file online")
AdmAI_Manager.shared.getKeyValuePair(fileLocal: "path file storage")
AdmAI_Manager.shared.getKeyValuePair(image: "image to Photo")
```

## Dữ liệu dạng bảng

- getTabular[Suffix]
- Example

```swift
func handleDataResponse(data: Dictionary<String, Any>?, value: Any?, error: APIError?) {
    if let data = data, let value = value {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            if let jsonString = String(data: jsonData, encoding: .utf8){
                print("jsonString")
		print("Model: \(Value)")
            }
        } catch {
            print("Error")
        }
    }else {
        print("Error")
    }
}
```

- **data:** Trả ra cục json
- **value:** Trả ra model dạng mảng

```swift
AdmAI_Manager.shared.getTabular(linkOnline: "url file online")
AdmAI_Manager.shared.getTabular(fileLocal: "path file storage")
AdmAI_Manager.shared.getTabular(image: "image to Photo")
```

## Passport

- getPassport[Suffix]
- Example

```swift
func handleDataResponse(data: Dictionary<String, Any>?, error: APIError?) {
    if let data = data {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            if let jsonString = String(data: jsonData, encoding: .utf8){
                print("jsonString")
            }
        } catch {
            print("Error")
        }
    }else {
        print("Error")
    }
}
```

- **data:** Trả ra cục json

```swift
AdmAI_Manager.shared.getPassport(linkOnline: "url file online")
AdmAI_Manager.shared.getPassport(fileLocal: "path file storage")
AdmAI_Manager.shared.getPassport(image: "image to Photo")
```

## Visa

- getVisa[Suffix]
- Example

```swift
AdmAI_Manager.shared.getVisa(linkOnline: "url file online")
AdmAI_Manager.shared.getVisa(fileLocal: "path file storage")
AdmAI_Manager.shared.getVisa(image: "image to Photo")
```

## Hoá đơn bán lẻ

- getRetail[Suffix]
- Example

```swift
AdmAI_Manager.shared.getRetail(linkOnline: "url file online")
AdmAI_Manager.shared.getRetail(fileLocal: "path file storage")
AdmAI_Manager.shared.getRetail(image: "image to Photo")

```

## Chứng chỉ IELTs

- getIeltsCertificate[Suffix]
- Example

```swift
AdmAI_Manager.shared.getIeltsCertificate(linkOnline: "url file online")
AdmAI_Manager.shared.getIeltsCertificate(fileLocal: "path file storage")
AdmAI_Manager.shared.getIeltsCertificate(image: "image to Photo")
```

## Bằng lái xe

- getDriver[Suffix]
- Example

```swift
AdmAI_Manager.shared.getDriver(linkOnline: "url file online")
AdmAI_Manager.shared.getDriver(fileLocal: "path file storage")
AdmAI_Manager.shared.getDriver(image: "image to Photo")
```

# Face

## Face Register( Đăng kí khuôn mặt)
Để sử dụng FaceRegister thì bạn cần truyền vào:
+ name: Tên người đăng kí
+ email: Email người đăng kí
+ Employee Code: Mã nhân sự người đăng kí
+ Face Mask: Khuôn mặt có khẩu trang hay không
```swift
AdmAI_Manager.shared.faceRegister(image: image, name: name, email: email, employeeCode: Int(code) ?? 0, faceMask: (Int(mask) ?? 0)) { data, error in
    if let data = data {
	print(data)
    }else {
	print("error")
    }
}
```
+ image: Khuôn mặt người đăng kí( image to photo)

```swift
AdmAI_Manager.shared.faceRegister(fileLocal: imageURL, name: name, email: email, employeeCode: Int(code) ?? 0, faceMask: Int(mask) ?? 1) { data, error in
    if let data = data {
	print(data)
    }else {
	print("error")
    }
}
```
+ fileLocal: Khuôn mặt người đăng kí( path file storage)

## Face Predict( Nhận diện khuôn mặt)
Để sử dụng FacePredict bạn cần cung cấp quyền truy cập vị trí
```swift
AdmAI_Manager.shared.facePredict(image: image) { [weak self] data, error in
    if let data = data {
        print(data)
    }else {
        print("error")
    }
}
```
+ image: Khuôn mặt cần nhận diện( image to photo)
```swift
AdmAI_Manager.shared.facePredict(fileLocal: imageURL) { data, error in
    if let data = data {
        print(data)
    }else {
        print("error")
    }
}
```
+ fileLocal: Khuôn mặt cần nhận diện( path file storage)

## Face Checkin History( Lịch sử Checkin)
```swift
AdmAI_Manager.shared.faceCheckinHistory(numberRecord: "Số bản ghi lịch sử muốn lấy ra") { data, error in
    if let data = data {
        print(data)
    }else {
	print("error")
    }
}
```

## Face Filter( Lọc lịch sử check in)
```swift
AdmAI_Manager.shared.faceCheckinFilter(employeeCode: employeeCode, fromDate: fromDate, toDate: toDate, listEmail: [email], check: check, page: page, limit: limit) { data, error in
    if let data = data {
	print(data)
    }else {
	print("error")
    }
}
```
+ employeeCode: Mã nhân sự
+ fromDate: Ngày bắt đầu lọc( convert từ date sang timeIntervalSince1970)
+ toDate: Ngày kết thúc lọc( convert từ date sang timeIntervalSince1970)
+ listEmail: Danh sách email cần muốn lọc
+ check: Giá trị thể hiện người không nhận diện được( mặc định là 1, có hoặc không cần truyền)
+ page: Số thứ tự của page( mặc định là 0, có hoặc không cần truyền)
+ limit: Số bản ghi tối đa trong 1 page( mặc định là 100, có hoặc không cần truyền)

## Face Get Info( Lấy thông tin người dùng)
 ```swift
AdmAI_Manager.shared.faceGetInfo(email: "Email cần lấy thông tin") { data, error in
    if let data = data {
	print(data)
    }else {
	print("error")
    }
}
```

## Face Update Info( Cập nhật thông tin)
```swift
AdmAI_Manager.shared.faceUpdateInfo(employeeCode: "Mã nhân sự", email: "Email", name: "Tên cần cập nhật", telegramID: "ID Telegram") { data, error in
    if let data = data {
	print(data)
    }else {
	print("error")
    }
}
```

## Face Fas Predict( Check giả mạo)
```swift
AdmAI_Manager.shared.faceFasPredict(image: "image to Photo") { data, error in
    if let data = data {
	print(data)
    }else {
	print("error")
    }
}
```

```swift
AdmAI_Manager.shared.faceFasPredict(fileLocal: "path file storage") { data, error in
    if let data = data {
	print(data)
    }else {
	print("error")
    }
}
```

## Face Compare( So sánh độ tương đồng 2 khuôn mặt)
```swift
AdmAI_Manager.shared.faceCompare(image1: "image to Photo", image2: "image to Photo") { data, error in
    if let data = data {
	print(data)
    }else {
	print("error")
    }
}
```

```swift
AdmAI_Manager.shared.faceCompare(fileLocal1: "path file storage", fileLocal2: "path file storage") { data, error in
    if let data = data {
	print(data)
    }else {
	print("error")
    }
}
```
