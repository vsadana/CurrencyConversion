//
//  ProtocolFiles.swift
//  CurrencyConversion
//
//  Created by Vaibhav Sadana on 01/05/23.
//

import Foundation
import UIKit

//MARK: Protocol
protocol TextFieldProtocol {
    func didAmountChangeInTf(text:String)
}

class BaseClassVC : UIViewController {
    //variables
    var delegate : TextFieldProtocol?
    
    func toolBar() -> UIToolbar{
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.barTintColor = .lightGray
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let buttonTitle = "Done"
        let doneButton = UIBarButtonItem(title: buttonTitle, style: .done, target: self, action: #selector(didTapView))
        doneButton.tintColor = .black
        toolBar.setItems([space, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        return toolBar
    }
    
    @objc func didTapView(){
        self.view.endEditing(true)
    }
    
    func dismissKeyBoard(){
        let tapgesture = UITapGestureRecognizer()
        tapgesture.addTarget(self, action: #selector(didTapView))
        self.view.addGestureRecognizer(tapgesture)
    }
}
 
extension BaseClassVC : UITextFieldDelegate {
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text {
            delegate?.didAmountChangeInTf(text: text)
        }
    }
}
