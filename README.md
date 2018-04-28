# mCheck SDK 

mCheck SDK for ios let you integrate the mobile phone number validation API in mobile devices.

In order to test the sample you need to change the secret key.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

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

self.mCheck.requestValidation(phone: phone, type: .SMS, message: smsBody, callback: {result, error -> Void in
    if (error != nil) {
        return
    }

    print(message: "Success, request ID: " + (result?.id)!)
})
```
**Verify Pin**
```swift
let requestID = "" //request id received from mcheck.requestValidation - response.id
let pinCode = "" //pin code to check

self.mCheck.verifyValidation(requestId: requestID, pin: pinCode, callback: {result, error -> Void in
    if (error != nil) {
        return
    }

    print(message: "Validated: \(String(describing: result!.validated))")
})
```
**Validation Status**
```swift
let requestID = "" //request id received from mcheck.requestValidation - response.id

self.mCheck.checkValidationStatus(requestId: requestID, callback: {result, error -> Void in
    if (error != nil) {
        return
    }

    print(message: "Validation status: \(String(describing: result!.validated))")
})
```

## License

MCheckSwift is available under the MIT license. See the LICENSE file for more info.
