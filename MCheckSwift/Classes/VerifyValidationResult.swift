//
//  VerifyValidationResult.swift
//  mcheck_sdk
//
//  Created by Yelnar Shopanov on 26.04.2018.
//

import Foundation

public class VerifyValidationResult {
    /**
     * the number that needs to be validated
     */
    public var phone: String?
    /**
     * true if the pin was correct. false Otherwise.
     */
    public var validated: Bool?
    /**
     * the date time as UNIX timestamp when the validation was completed (the pin was matched first time).
     * In case the number is not validated the value is null
     */
    public var validationDate: CLong?
}
