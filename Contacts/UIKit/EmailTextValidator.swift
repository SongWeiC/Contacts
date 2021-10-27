//
//  EmailTextValidator.swift
//  Contacts
//
//  Created by SongWei Chuah on 27/10/21.
//

import Foundation

class EmailTextValidator: TextValidatorType {

    private var errorMessage: String
    init(errorMessage: String) {
        self.errorMessage = errorMessage
    }

    func validate(text: String) -> TextValidationResult {
        let result = NSPredicate(
            format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}").evaluate(with: text)
        return result ? .successful : .error(errorMessage: errorMessage)
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
