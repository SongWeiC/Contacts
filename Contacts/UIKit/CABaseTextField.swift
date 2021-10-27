//
//  CABaseTextField.swift
//  Contacts
//
//  Created by SongWei Chuah on 26/10/21.
//

import Foundation
import UIKit

protocol CATextFieldType: UITextField {
    func setState(state: CATextFieldState)
}

enum CATextFieldState {
    case normal
    case inValid
    case locked
}

class CABaseTextField: UITextField, CATextFieldType {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        autocapitalizationType = .sentences
        autocorrectionType = .yes
        spellCheckingType = .yes
        keyboardType = .alphabet
        returnKeyType = .default
        textColor = .black
        tintColor = .black
        layer.cornerRadius = 8
        setState(state: .normal)
    }
    
    func setState(state: CATextFieldState) {

        switch state {
        case .normal:
            textColor = .black
            backgroundColor = .lightGray
            isEnabled = true

        case .locked:
            backgroundColor = .darkGray
            isEnabled = false
            
        case .inValid:
            isEnabled = true
        }
    }
    
    let insets: CGFloat = 12
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insets, dy: insets)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insets, dy: insets)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insets, dy: insets)
    }
}
