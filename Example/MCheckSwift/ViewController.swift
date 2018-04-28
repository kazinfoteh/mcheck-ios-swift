//
//  ViewController.swift
//  MCheckSwift
//
//  Created by Yelnar Shopanov on 04/28/2018.
//  Copyright (c) 2018 KazInfoTeh. All rights reserved.
//

import UIKit
import MCheckSwift
import SVProgressHUD

class ViewController: UIViewController {
    var mCheck: MCheck!;
    
    @IBOutlet weak var phoneNumberInput: UITextField!
    @IBOutlet weak var requestIdLabel: UILabel!
    @IBOutlet weak var pinCodeInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let token = "YOUR_TOKEN"; //automatically generated token from https://isms.center
        
        self.mCheck = MCheck(aToken: token);
    }
    
    @IBAction func requestValidationAction(_ sender: UIButton) {
        if ((self.phoneNumberInput.text?.count)! == 0) {
            self .showMessage(message: "Enter phone number")
            return;
        }
        
        // [:phone] phone number
        // [:pin] validation code
        
        let smsBody = "Your validation code: [:pin]"; // smsBody is optional param, and maybe is null
        weak var weakSelf = self
        
        SVProgressHUD.show() //show loading view
        
        self.mCheck.requestValidation(phone: self.phoneNumberInput.text!, type: .SMS, message: smsBody, callback: {result, error -> Void in
            SVProgressHUD.dismiss()  //hide loading view
            
            if (error != nil) {
                self.showMessage(message: "code: " + String((error! as NSError).code) + "\nmessage: " + error!.localizedDescription)
                return
            }
            
            weakSelf!.requestIdLabel.text = result!.id
            weakSelf!.showMessage(message: "Success, request ID: " + (result?.id)!)
        })
    }
    
    @IBAction func checkValidationStatusAction(_ sender: UIButton) {
        if ((self.requestIdLabel.text?.count)! == 0) {
            self.showMessage(message: "Execute first request validation")
            return
        }
        
        SVProgressHUD.show() //show loading view
        
        let requestID = self.requestIdLabel.text!; // it's coming from request validation
        
        self.mCheck.checkValidationStatus(requestId: requestID, callback: {result, error -> Void in
            SVProgressHUD.dismiss()  //hide loading view
            
            if (error != nil) {
                self.showMessage(message: "code: " + String((error! as NSError).code) + "\nmessage: " + error!.localizedDescription)
                return
            }
            
            self.showMessage(message: "Validation status: \(String(describing: result!.validated))")
        })
    }
    
    @IBAction func verifyValidationAction(_ sender: UIButton) {
        if ((self.requestIdLabel.text?.count)! == 0) {
            self.showMessage(message: "Execute first request validation")
            return
        }
        
        if ((self.pinCodeInput.text?.count)! == 0) {
            self.showMessage(message: "Enter pin code")
            return
        }
        
        SVProgressHUD.show() //show loading view
        
        let requestID = self.requestIdLabel.text!; // it's coming from request validation
        let pinCode = self.pinCodeInput.text!;
        
        self.mCheck.verifyValidation(requestId: requestID, pin: pinCode, callback: {result, error -> Void in
            SVProgressHUD.dismiss()  //hide loading view
            
            if (error != nil) {
                self.showMessage(message: "code: " + String((error! as NSError).code) + "\nmessage: " + error!.localizedDescription)
                return
            }
            
            self.showMessage(message: "Validated: \(String(describing: result!.validated))")
        })
    }
    
    func showMessage(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
}

