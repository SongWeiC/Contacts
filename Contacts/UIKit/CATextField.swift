//
//  CATextField.swift
//  Contacts
//
//  Created by SongWei Chuah on 26/10/21.
//

import Foundation
import UIKit

protocol CATextFieldDelegateType: AnyObject {
    ///use this function to show some additional input tip, e.g, tips for password
    func onTextInputViewFocused(_ textInputView: CATextField)
    
    ///use this function change the input focus, e.g, focus on next input field
    func onTextInputViewReturned(_ textInputView: CATextField)
    
    ///use this function to check when textfield has done editting
    func onTextInputViewDidEndEditing(_ textInputView: CATextField)
    
    ///use this function for checking validation of the text
    func onTextInputViewTextChanged(_ textInputView: CATextField, isInputValid: Bool)
}

struct CATextFieldConfig {
    /// use this property to set initial value in the textField, e.g, email used in last login
    var initialValue: String?

    /// use this property set placeholder text in textFiedl
    var placeholderText: String?

    /// use this property to set title above textFiedl
    var titleText: String?

    static func defaultConfig() -> CATextFieldConfig {
        return CATextFieldConfig()
    }
}

class CATextField: UIView {
    enum InputType {
        case name
    }
    
    private var initialValue: String?
    private var placeholderText: String?
    private var title: String?
    private var textFieldShouldReturn: Bool = true
    
    private var isInputValid: Bool = true

    /// this property is to validate required fields, required error message should not be displayed until user starts typing
    private var inputIsDirty: Bool = false
    
    private var inputType: InputType = .name
    
    private let titleLabel = UILabel()
    private let errorLabel = UILabel()
    
    var textField: CATextFieldType
    
    var errorMessage: String?
    weak var textFieldDelegate: CATextFieldDelegateType?
    var validator: TextValidatorType?
    
    required init(type: CATextField.InputType = .name,
                  config: CATextFieldConfig = CATextFieldConfig.defaultConfig(), textValidator: TextValidatorType? = nil) {
        switch type {
        case .name:
            textField = CABaseTextField()
        }
        
        super.init(frame: .zero)

        inputType = type
        validator = textValidator

        self.setViewConfiguration(config: config)
        self.setUpViews()
    }
    
    private func setViewConfiguration(config: CATextFieldConfig) {
        initialValue = config.initialValue
        title = config.titleText
        placeholderText = config.placeholderText
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        let veritcalSpacing: CGFloat = 8
        let titleHeight = (title == nil ? 0 : titleLabel.frame.height)
        let errorHeight:CGFloat = (errorMessage == nil ? 0 : errorLabel.frame.height + veritcalSpacing)

        let height:CGFloat = titleHeight + 48 + errorHeight
        let width: CGFloat = 150
        return CGSize(width: width, height: height)
    }
    
    private func setUpViews() {
        let verticalStack = UIStackView()
        verticalStack.axis = .vertical
        verticalStack.distribution = .fill
        verticalStack.spacing = 8

        if title != nil {
            verticalStack.addArrangedSubview(titleLabel)
            titleLabel.snp.makeConstraints { make in
                make.height.equalTo(30)
            }
        }

        verticalStack.addArrangedSubview(textField)

        textField.snp.makeConstraints { make in
            make.height.equalTo(64)
        }
        addSubview(verticalStack)
        verticalStack.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }

        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textField.text = initialValue

        titleLabel.text = title
        textField.backgroundColor = .lightGray
        textField.placeholder = placeholderText

//        titleLabel.font = styleGuide.fonts.primaryButton
        titleLabel.textColor = .black

//        textField.font = styleGuide.fonts.body
//        errorLabel.font = styleGuide.fonts.body
        errorLabel.textColor = .red
        errorLabel.numberOfLines = 0
        errorLabel.lineBreakMode = .byWordWrapping
        errorLabel.isHidden = true
    }
    
    func lock() {
        textField.setState(state: .locked)
    }
    func unlock() {
        textField.setState(state: .normal)
    }
    override func becomeFirstResponder() -> Bool {
        textField.becomeFirstResponder()
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        computeValidation()
        textFieldDelegate?.onTextInputViewTextChanged(self, isInputValid: isInputValid)
//        if let textFormatter = formatter, let text = textField.text {
//            textField.text = textFormatter.format(text: text)
//        }
    }
    
    private func computeValidation() {
        if textField.text?.isEmpty == true {
            isInputValid = false
            errorMessage = ""
        } else if let text = textField.text, let validator = validator {

            let validationResult = validator.validate(text: text)
            switch validationResult {
            case .error(let errorMsg):
                isInputValid = false
                errorMessage = errorMsg

            case .successful:
                isInputValid = true
                errorMessage = nil
            }
        } else {
            isInputValid = true
            errorMessage = nil
        }
    }
    
    func updateUI() {
        guard inputIsDirty else {
            return
        }
        ///update ui and colors on input change
        if textField.isEditing {
//            textField.setState(state: .highlighted)
            errorLabel.isHidden = true
        } else {
            computeValidation()

            if let errorMsg = errorMessage {
                errorLabel.isHidden = false
                errorLabel.text = errorMsg
            }

            let textFieldState: CATextFieldState = errorLabel.isHidden ? .normal : .inValid
            textField.setState(state: textFieldState)
        }

        invalidateIntrinsicContentSize()
        layoutIfNeeded()
    }
}

extension CATextField: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        textFieldDelegate?.onTextInputViewFocused(self)
        inputIsDirty = true
        updateUI()
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        textFieldDelegate?.onTextInputViewDidEndEditing(self)
        updateUI()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textFieldDelegate?.onTextInputViewReturned(self)
        textField.resignFirstResponder()
        return true
    }

}


enum TextValidationResult {
    case successful
    case error(errorMessage: String)
}

protocol TextValidatorType {
    func validate(text: String) -> TextValidationResult
}

class DisplayNameTextValidator: TextValidatorType {

    private var errorMessage: String
    init(errorMessage: String) {
        self.errorMessage = errorMessage
    }

    func validate(text: String) -> TextValidationResult {
        let regex = "^(?![0-9]+$)[0-9A-Za-z ]{1,128}$"
        let checkRegex = NSPredicate(format: "SELF MATCHES %@", regex)
        let result = checkRegex.evaluate(with: text)
        return result ? .successful : .error(errorMessage: errorMessage)
    }
}
