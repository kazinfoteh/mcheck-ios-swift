//
//  MCheck.swift
//  mcheck_sdk
//
//  Created by Yelnar Shopanov on 26.04.2018.
//

import Foundation

public class MCheck {
    var token: String;
 
    /**
     * Init constructor.
     *
     * @param token automatically generated token from https://isms.center
     */
    public init(aToken: String) {
        self.token = aToken;
    }
    
    /**
     * The Request Validation API lets you requesting a validation using one of the available methods:
     * SMS - Send a message to the user with a validation code that he has to enter to validate his mobile number.
     *
     * @param phone    the number that has to be validated
     * @param type     one of the following value: sms
     * @param message  sms message body
     * @param callback result
     */
    public func requestValidation(phone: String, type: ValidationType, message: String, callback:@escaping ((RequestValidationResult?, Error?) -> Void)) {
        ServerHelper.requestValidation(token: self.token, phone: phone, type: type, msg: message, callback: {result, error -> Void in
            OperationQueue.main.addOperation {
                callback(result, error);
            }
        })
    }
    
    /**
     * The Verify Pin API lets you to match a validation request with a validation pin inserted by a user.
     * SMS validation process.
     *
     * @param requestId validation request id
     * @param pin       the pin number inserted by user
     * @param callback  result
     */
    public func verifyValidation(requestId: String, pin: String, callback:@escaping ((VerifyValidationResult?, Error?) -> Void)) {
        ServerHelper.verifyValidation(token: self.token, id: requestId, pin: pin, callback: {result, error -> Void in
            OperationQueue.main.addOperation {
                callback(result, error);
            }
        })
    }
    
    /**
     * The Validation status API let you to check the validation status of a request.
     *
     * @param requestId validation request id
     * @param callback  result
     */
    public func checkValidationStatus(requestId: String, callback:@escaping ((ValidationStatusResult?, Error?) -> Void)) {
        ServerHelper.statusValidation(token: self.token, id: requestId, callback: {result, error -> Void in
            OperationQueue.main.addOperation {
                callback(result, error);
            }
        })
    }
}
