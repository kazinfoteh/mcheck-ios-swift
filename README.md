# mCheck SDK 

mCheck SDK for ios let you integrate the mobile phone number validation API in mobile devices.

In order to test the sample you need to change the secret key.

[![CI Status](https://img.shields.io/travis/Kurdakrx/MCheckSwift.svg?style=flat)](https://travis-ci.org/Kurdakrx/MCheckSwift)
[![Version](https://img.shields.io/cocoapods/v/MCheckSwift.svg?style=flat)](https://cocoapods.org/pods/MCheckSwift)
[![License](https://img.shields.io/cocoapods/l/MCheckSwift.svg?style=flat)](https://cocoapods.org/pods/MCheckSwift)
[![Platform](https://img.shields.io/cocoapods/p/MCheckSwift.svg?style=flat)](https://cocoapods.org/pods/MCheckSwift)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

MCheckSwift is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'MCheckSwift'
```

## Sample Usage

**Init SDK**
```swift
//automatically generated token from https://isms.center
let token = "YOUR_TOKEN";
self.mCheck = MCheck(aToken: token);
```
**Request validation**
```swift
// [:phone] phone number
// [:pin] validation code

let phone = "+77770000000"
let smsBody = "Your validation code: [:pin]"; // smsBody is optional param, and maybe is null
weak var weakSelf = self

self.mCheck.requestValidation(phone: phone, type: .SMS, message: smsBody, callback: {result, error -> Void in
if (error != nil) {
return
}

print(message: "Success, request ID: " + (result?.id)!)
})

## License

MCheckSwift is available under the MIT license. See the LICENSE file for more info.
