# AdmicroAI
# Mô tả

## Version

- **Number:** 0.1.1
- **Type:** Developing

## Demo

- **GitHub:**

## Changelog

| ID | Version | Status | Summary |
| --- | --- | --- | --- |
| 1 | 0.1.1 | Developing | Speech, Ocr |
| 2 | 0.1.2 | Pending |  |

## Yêu cầu

- Tối thiểu Xcode 13 trở lên
- Language Version: Swift 5

### Quyền truy cập

- **NSAllowsArbitraryLoads = YES**: để disable App Transport Security

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

Để có thể sử dụng các tính năng, thì cần đăng kí username, password trước.

Username và password được cấp từ bên hỗ trợ

Register cần request lên server để lấy thông tin

```swift
import AdmicroAI

AdmAI_Manager.shared.register(email: "guest1@gmail.com", password: "abcd1234", expire: 5)
AdmAI_Manager.shared.enableDebugLog()
AdmAI_Manager.shared.configSession(session: URLSession(configuration: .default), requestTimeout: 20)
```

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

```
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

```
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

```
AdmAI_Manager.shared.textToSpeech(text: "Nội dụng cần chuyển sang audio", speakerID: "Mã ID người đọc", sampleRate: "Tần số Audio", outputFormat: "Định dạng Audio") { data, value, error in
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

speakerID, sampleRate, outputFormat đều đã được định dạng có sẵn các trường tương ứng với

- **speakerID:** SpeechSpeakerID
- **sampleRate:** SpeechSampleRate
- **outputFormat:** SpeechFormat
#Ocr
Tất cả func ocr đều hỗ trợ link online, file trong storage, image trong photo
[Tên hàm][Suffix]
**linkOnline:** url file online
**fileLocal:** path file trong storage
**imageData:** Image Picker convert từ image sang data

```
guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
    return
}

guard let imageData = image.jpegData(compressionQuality: 1.0) else {
    return
}
```

Kết quả trả về khi success dều là data OCR, bên trong chưa thông tin tương ứng từng loại

```
func handleDataResponse(data: Dictionary<String, Any>?, value: Any?, error: APIError?) {
    if let data = data, let value = value {
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

**data:** Trả ra cục json tương ứng từng loại
**value:**: Trả ra Model chứa thông tin chi tiết tương ứng từng loại

## Căn cước công dân

- getIDCard[Suffix]
- Example

```
AdmAI_Manager.shared.getIDCard(linkOnline: "url file online")
AdmAI_Manager.shared.getIDCard(fileLocal: "path file storage)
AdmAI_Manager.shared.getIDCard(imageData: "image to Photo")
```

## Đăng kí xe

- getRegisterCar[Suffix]
- Example

```
AdmAI_Manager.shared.getRegisterCar(linkOnline: "url file online")
AdmAI_Manager.shared.getRegisterCar(fileLocal: "path file storage)
AdmAI_Manager.shared.getRegisterCar(imageData: "image to Photo")

```

## Bảo hiểm ý tế

- getHealth[Suffix]
- Example

```
AdmAI_Manager.shared.getHealth(linkOnline: "url file online")
AdmAI_Manager.shared.getHealth(fileLocal: "path file storage)
AdmAI_Manager.shared.getHealth(imageData: "image to Photo")
```

## Đăng kiểm xe

- getRegistryCar[Suffix]
- Example

```
AdmAI_Manager.shared.getRegistryCar(linkOnline: "url file online")
AdmAI_Manager.shared.getRegistryCar(fileLocal: "path file storage)
AdmAI_Manager.shared.getRegistryCar(imageData: "image to Photo")
```

## Uỷ nhiệm chi

- getExpenses[Suffix]
- Example

```
AdmAI_Manager.shared.getExpenses(linkOnline: "url file online")
AdmAI_Manager.shared.getExpenses(fileLocal: "path file storage)
AdmAI_Manager.shared.getExpenses(imageData: "image to Photo")
```

## Đăng kí doanh nghiệp

- getBusinessRegister[Suffix]
- Example

```
AdmAI_Manager.shared.getBusinessRegister(linkOnline: "url file online")
AdmAI_Manager.shared.getBusinessRegister(fileLocal: "path file storage)
AdmAI_Manager.shared.getBusinessRegister(imageData: "image to Photo")

```

## Key Value Pair

- getKeyValuePair[Suffix]
- Example

```
AdmAI_Manager.shared.getKeyValuePair(linkOnline: "url file online")
AdmAI_Manager.shared.getKeyValuePair(fileLocal: "path file storage)
AdmAI_Manager.shared.getKeyValuePair(imageData: "image to Photo")
```

## Dữ liệu dạng bảng

- getTabular[Suffix]
- Example

```
AdmAI_Manager.shared.getTabular(linkOnline: "url file online")
AdmAI_Manager.shared.getTabular(fileLocal: "path file storage)
AdmAI_Manager.shared.getTabular(imageData: "image to Photo")
```

## Passport

- getPassport[Suffix]
- Example

```
AdmAI_Manager.shared.getPassport(linkOnline: "url file online")
AdmAI_Manager.shared.getPassport(fileLocal: "path file storage)
AdmAI_Manager.shared.getPassport(imageData: "image to Photo")
```

## Visa

- getVisa[Suffix]
- Example

```
AdmAI_Manager.shared.getVisa(linkOnline: "url file online")
AdmAI_Manager.shared.getVisa(fileLocal: "path file storage)
AdmAI_Manager.shared.getVisa(imageData: "image to Photo")
```

## Hoá đơn bán lẻ

- getRetail[Suffix]
- Example

```
AdmAI_Manager.shared.getRetail(linkOnline: "url file online")
AdmAI_Manager.shared.getRetail(fileLocal: "path file storage)
AdmAI_Manager.shared.getRetail(imageData: "image to Photo")

```

## Chứng chỉ IELTs

- getIeltsCertificate[Suffix]
- Example

```
AdmAI_Manager.shared.getIeltsCertificate(linkOnline: "url file online")
AdmAI_Manager.shared.getIeltsCertificate(fileLocal: "path file storage)
AdmAI_Manager.shared.getIeltsCertificate(imageData: "image to Photo")
```

## Bằng lái xe

- getDriver[Suffix]
- Example

```
AdmAI_Manager.shared.getDriver(linkOnline: "url file online")
AdmAI_Manager.shared.getDriver(fileLocal: "path file storage)
AdmAI_Manager.shared.getDriver(imageData: "image to Photo")
```

# Face
Update
