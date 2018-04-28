//
//  ServerHelper.swift
//  mcheck_sdk
//
//  Created by Yelnar Shopanov on 26.04.2018.
//

import Foundation

class ServerHelper {
    private static let URL_HOST = "http://isms.center"
    private static let URL_V1 = URL_HOST + "/v1"
    private static let URL_VALIDATION = URL_V1 + "/validation"
    private static let URL_VALIDATION_REQUEST = URL_VALIDATION + "/request"
    private static let URL_VALIDATION_VERIFY = URL_VALIDATION + "/verify"
    private static let URL_VALIDATION_STATUS = URL_VALIDATION + "/status"
    
    private static let TOKEN = "token"
    private static let ERROR_CODE = "error_code"
    private static let ERROR_MESSAGE = "error_message"
    private static let ID = "id"
    private static let PHONE = "phone"
    private static let TYPE = "type"
    private static let VALIDATION_DATE = "validation_date"
    private static let VALIDATED = "validated"
    
    static func requestValidation(token: String, phone: String, type: ValidationType, msg: String, callback:@escaping ((RequestValidationResult?, Error?) -> Void)) {
        let body = ["phone": phone, "type": type.rawValue, "msg": msg] as Dictionary<String, Any>
        
        var request = URLRequest(url: URL(string: URL_VALIDATION_REQUEST)!)
        request.httpMethod = "POST"
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(token, forHTTPHeaderField: TOKEN)
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {data, response, error -> Void in
            do {
                try checkResponse(data: data, response: response, error: error)
                
                if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject] {
                    let result = RequestValidationResult()
                    result.id = json[ID] as? String
                    result.phone = json[PHONE] as? String
                    result.type = json[TYPE] as? Bool
                    
                    callback(result, nil)
                }
            } catch let e {
                callback(nil, e)
            }
        })
        task.resume()
    }
    
    static func verifyValidation(token: String, id: String, pin: String, callback:@escaping ((VerifyValidationResult?, Error?) -> Void)) {
        let body = ["id": id, "pin": pin] as Dictionary<String, String>
        
        var request = URLRequest(url: URL(string: URL_VALIDATION_VERIFY)!)
        request.httpMethod = "POST"
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(token, forHTTPHeaderField: TOKEN)
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {data, response, error -> Void in
            do {
                try checkResponse(data: data, response: response, error: error)
                
                if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject] {
                    let result = VerifyValidationResult()
                    result.phone = json[PHONE] as? String
                    result.validated = json[VALIDATED] as? Bool
                    result.validationDate = json[VALIDATION_DATE] as? CLong
                    
                    callback(result, nil)
                }
            } catch let e {
                callback(nil, e)
            }
        })
        task.resume()
    }
    
    static func statusValidation(token: String, id: String, callback:@escaping ((ValidationStatusResult?, Error?) -> Void)) {
        let body = ["id": id] as Dictionary<String, String>
        
        var request = URLRequest(url: URL(string: URL_VALIDATION_STATUS)!)
        request.httpMethod = "POST"
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(token, forHTTPHeaderField: TOKEN)
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {data, response, error -> Void in
            do {
                try checkResponse(data: data, response: response, error: error)
                
                if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject] {
                    let result = ValidationStatusResult()
                    result.phone = json[PHONE] as? String
                    result.validated = json[VALIDATED] as? Bool
                    result.validationDate = json[VALIDATION_DATE] as? CLong
                    
                    callback(result, nil)
                }
            } catch let e {
                callback(nil, e)
            }
        })
        task.resume()
    }
    
    static func checkResponse(data: Data?, response: URLResponse?, error: Error?) throws {
        if (error != nil) {
            throw error!
        }
        
        if (response == nil) {
            throw NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: "Server error, empty response"])
        }
        
        let httpResponse = response as! HTTPURLResponse;
        
        if (httpResponse.statusCode != 200) {
            try checkBase(data: data)
            throw NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Server error"])
        } else {
            try checkBase(data: data)
        }
    }
    
    static func checkBase(data: Data?) throws {
        if (data == nil) {
            throw NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: "Server error, empty response"])
        }
        
        if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject] {
            if let errorCode = json[ERROR_CODE] {
                if (errorCode.integerValue != 0) {
                    if let errorMessage = json[ERROR_MESSAGE] {
                        throw NSError(domain: "", code: errorCode.integerValue, userInfo: [NSLocalizedDescriptionKey: errorMessage as! String])
                    }
                    
                    throw NSError(domain: "", code: errorCode.integerValue, userInfo: nil)
                }
            }
        }
    }
}
