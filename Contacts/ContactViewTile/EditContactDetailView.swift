//
//  EditContactDetailView.swift
//  Contacts
//
//  Created by SongWei Chuah on 26/10/21.
//

import Foundation
import UIKit

class EditContactDetailView: UIView {
    private let config: ContactViewModel
    private var avatarImage: UIImageView!
    private let firstNameTextField: CATextField
    private let lastNameTextField: CATextField
    private let contactIDTextField: CATextField
    private let rightbutton = UIButton()
    
    init(config: ContactViewModel) {
        self.config = config
        
        
        firstNameTextField = CATextField(type: .name, config: CATextFieldConfig(initialValue: config.firstName, placeholderText: nil, titleText: "First Name"), textValidator: DisplayNameTextValidator(errorMessage: "Please enter valid name"))
        lastNameTextField = CATextField(type: .name, config: CATextFieldConfig(initialValue: config.lastName, placeholderText: nil, titleText: "Last Name"), textValidator: DisplayNameTextValidator(errorMessage: "Please enter valid name"))
        contactIDTextField = CATextField(type: .name, config: CATextFieldConfig(initialValue: "\(config.id)", placeholderText: nil, titleText: "Contact ID"), textValidator: nil)
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
//        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func userDidSelectDoneButton() {
        print("tap")
//        self.dismiss(animated: true, completion: nil)
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
        
        self.addSubview(contactIDTextField)
        contactIDTextField.snp.makeConstraints{ make in
            make.top.equalTo(lastNameTextField.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
        }
        contactIDTextField.textField.setState(state: .locked)

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
   
        if let url = URL(string: config.avatarUrlString) {
            avatarImage.kf.setImage(with: url)
        }
    }
    var firstName = ""
    var lastName = ""
}

extension EditContactDetailView: CATextFieldDelegateType {
    func onTextInputViewTextChanged(_ textInputView: CATextField, isInputValid: Bool) {
        if textInputView === firstNameTextField {
            firstName = firstNameTextField.textField.text ?? ""
        } else if textInputView === lastNameTextField {
            lastName = lastNameTextField.textField.text ?? ""
        }
        if firstName != "" && lastName != "" {
            rightbutton.isEnabled = true
        }
    }

    func onTextInputViewFocused(_ textInputView: CATextField) {
        
    }
    
    func onTextInputViewReturned(_ textInputView: CATextField) {
        
    }
    
    func onTextInputViewDidEndEditing(_ textInputView: CATextField) {
        
    }
}
