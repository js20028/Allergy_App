//
//  CustomTextField.swift
//  AllergyApp
//
//  Created by 김정태 on 2023/02/22.
//

import Foundation
import UIKit

class CustomTextField: UITextField {
    
    var textFieldPlaceholder: String = ""

    convenience init(textFieldPlaceholder: String) {
        self.init()
        self.textFieldPlaceholder = textFieldPlaceholder
        self.initializeTextField(textFieldPlaceholder: textFieldPlaceholder)
    }

    override func draw(_ rect: CGRect) {
        // Drawing code
        self.initializeTextField(textFieldPlaceholder: textFieldPlaceholder)
    }

    private func initializeTextField(textFieldPlaceholder: String) {
        
        self.delegate = self
        
        self.translatesAutoresizingMaskIntoConstraints = false

        // textfield border style
        self.borderStyle = .none
        self.layer.cornerRadius = 8.0
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1).cgColor // border color
        
        // text color
        self.textColor = UIColor.gray
        self.font = UIFont(name: "NanumSquareR", size: 14)
        self.textColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1) // text color
        
        // placeholder font, color
        self.attributedPlaceholder = NSAttributedString(string: textFieldPlaceholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)]) // placeholder color

        // textfield leftview
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.frame.height))
        self.leftViewMode = .always
        self.autocorrectionType = .no
    }

}

// MARK: - textfield click delegate
extension CustomTextField: UITextFieldDelegate {
    
    // textfield click
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("textfield 선택")
        textField.becomeFirstResponder()
        textField.layer.borderColor = UIColor.primaryCGColor
        textField.tintColor = UIColor.primaryColor
    }
    
    // textfield
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1).cgColor
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        
        // 최대 글자수 이상을 입력한 이후에는 중간에 다른 글자를 추가할 수 없게끔 작동
        if text.count >= 100 {
            return false
        }
        return true
    }
    
    
}

