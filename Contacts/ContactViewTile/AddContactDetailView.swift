//
//  AddContactDetailView.swift
//  Contacts
//
//  Created by SongWei Chuah on 27/10/21.
//

import Foundation
import UIKit

protocol AddContactDetailViewDelegateType: AnyObject {
    func userDidPressedCancel()
    func userDidPressedDone()
}

class AddContactDetailView: UIView {
    private var avatarImage: UIImageView!
    private let firstNameTextField: CATextField
    private let lastNameTextField: CATextField
    private let emailTextField: CATextField
    private let rightbutton = UIButton()
    private let dataSource: ContactDataSourceType
    weak var delegate: AddContactDetailViewDelegateType?
    private var isFirstNameValid = false
    private var isLastNameValid = false
    
    init(dataSource: ContactDataSourceType) {
        self.dataSource = dataSource
        firstNameTextField = CATextField(type: .name, config: CATextFieldConfig(placeholderText: "Please enter first name", titleText: "First Name", emptyValueErrorMessage: "Please enter first name"), textValidator: DisplayNameTextValidator(errorMessage: "Please enter valid name"))
        lastNameTextField = CATextField(type: .name, config: CATextFieldConfig(placeholderText: "Please enter last name", titleText: "Last Name", emptyValueErrorMessage: "Please enter last name"), textValidator: DisplayNameTextValidator(errorMessage: "Please enter valid name"))
        emailTextField = CATextField(type: .name, config: CATextFieldConfig(placeholderText: "Please enter email", titleText: "Email"), textValidator: EmailTextValidator(errorMessage: "Please fill in a valid email address"))
        super.init(frame: .zero)
        customInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func customInit() {
        setUpNavBar()
        setUpAvatarImage()
        setUpContactID()
    }
    
    func setUpNavBar() {
        let navigationBar = getCustomNavBar(title: "")

        self.addSubview(navigationBar)
        navigationBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            
            if #available(iOS 11.0, *) {
                make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
                make.height.equalTo(44)
            } else {
                make.top.equalToSuperview()
                make.height.equalTo(44)
            }
        }

        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(userDidSelectCancelButton), for: .touchUpInside)
        let leftButton = UIBarButtonItem(customView: button)
        navigationBar.items?.first?.leftBarButtonItem = leftButton
        
        rightbutton.setTitle("Done", for: .normal)
        rightbutton.setTitleColor(.black, for: .normal)
        rightbutton.setTitleColor(.lightGray, for: .disabled)
        rightbutton.addTarget(self, action: #selector(userDidSelectDoneButton), for: .touchUpInside)
        let rightButton = UIBarButtonItem(customView: rightbutton)
        navigationBar.items?.first?.rightBarButtonItem = rightButton
        rightbutton.isEnabled = false
    }
    
    func getCustomNavBar(title: String?) -> UINavigationBar {
        let navBar = UINavigationBar()
        navBar.barTintColor = .black
        navBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navBar.shadowImage = UIImage()
        if let title = title {
            let navItem = UINavigationItem(title: title)
            let titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.textColor = .black
            navItem.titleView = titleLabel
            navBar.setItems([navItem], animated: false)
        }
        return navBar
    }
    
    @objc func userDidSelectCancelButton() {
        delegate?.userDidPressedCancel()
        print("cancel")
    }
    
    @objc func userDidSelectDoneButton() {
        if isFirstNameValid && isLastNameValid {
            dataSource.addNewContact(firstName: firstNameTextField.textField.text!, lastName: lastNameTextField.textField.text!, email: firstNameTextField.textField.text ?? "")
            self.delegate?.userDidPressedDone()
        } else {
            //Prompt Error message
        }
    }
    
    func setUpContactID() {
        self.addSubview(firstNameTextField)
        firstNameTextField.snp.makeConstraints{ make in
            make.top.equalTo(avatarImage.snp.bottom).offset(24)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
        }
        firstNameTextField.textFieldDelegate = self
        
        self.addSubview(lastNameTextField)
        lastNameTextField.snp.makeConstraints{ make in
            make.top.equalTo(firstNameTextField.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
        }
        lastNameTextField.textFieldDelegate = self
        
        self.addSubview(emailTextField)
        emailTextField.snp.makeConstraints{ make in
            make.top.equalTo(lastNameTextField.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
        }

    }
    
    func setUpAvatarImage() {
        avatarImage = UIImageView()
        avatarImage.contentMode = .scaleAspectFit
        self.addSubview(avatarImage)
        avatarImage.snp.makeConstraints { make in
            make.width.height.equalTo(100)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(50)
            make.centerX.equalToSuperview()
        }
        avatarImage.layer.cornerRadius = CGFloat(100/2)
        avatarImage.clipsToBounds = true
   
        avatarImage.image = UIImage(named: "defaultAvatar")
    }
    
}

extension AddContactDetailView: CATextFieldDelegateType {
    func onTextInputViewTextChanged(_ textInputView: CATextField, isInputValid: Bool) {
        if textInputView === firstNameTextField {
            isFirstNameValid = isInputValid
        } else if textInputView === lastNameTextField {
            isLastNameValid = isInputValid
        }
        if isFirstNameValid  && isLastNameValid {
            rightbutton.isEnabled = true
        } else {
            rightbutton.isEnabled = false
        }
    }
}
