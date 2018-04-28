//
//  RequestValidationResult.swift
//  mcheck_sdk
//
//  Created by Yelnar Shopanov on 26.04.2018.
//

import Foundation

public class RequestValidationResult {
    /**
     * unique identifier of the validation request
     */
    public var id: String?;
    /**
     * validation type as requested
     */
    public var type: Bool?;
    /**
     * the number that needs to be validated
     */
    public var phone: String?;
}
