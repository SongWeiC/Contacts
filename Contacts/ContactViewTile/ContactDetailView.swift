//
//  ContactDetailView.swift
//  Contacts
//
//  Created by SongWei Chuah on 25/10/21.
//

import Foundation
import UIKit

class ContactDetailView: UIView {
    private let config: ContactViewModel
    private var avatarImage: UIImageView!
    private var nameLabel: UILabel!
    
    fileprivate let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 0
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.backgroundColor = .white
        return stackView
    }()
    
    init(config: ContactViewModel) {
        self.config = config
        super.init(frame: .zero)
        customInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func customInit() {
        setUpContactDetail()
        setUpHorizontalStackView()
        setUpContactID()
    }
    
    func setUpContactID() {
        let containerView = UIView()
        let title = UILabel()
        let value = UILabel()
        
        containerView.addSubview(title)
        title.snp.makeConstraints{ make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        title.text = "Contact ID"
        
        containerView.addSubview(value)
        value.snp.makeConstraints{ make in
            make.left.equalTo(title.snp.right).offset(16)
            make.centerY.equalToSuperview()
        }
        value.text = String(config.id)
        
        self.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(stackView.snp.bottom).offset(120)
        }
        
    }
    
    func setUpHorizontalStackView() {
        self.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
            make.top.equalTo(nameLabel.snp.bottom).offset(16)
        }
        stackView.addArrangedSubview(DetailsActionView(type: .message))
        stackView.addArrangedSubview(DetailsActionView(type: .call))
        stackView.addArrangedSubview(DetailsActionView(type: .email))
        stackView.addArrangedSubview(DetailsActionView(type: .favourite))
    }
    
    func setUpContactDetail() {
        avatarImage = UIImageView()
        avatarImage.contentMode = .scaleAspectFit
        self.addSubview(avatarImage)
        avatarImage.snp.makeConstraints { make in
            make.width.height.equalTo(100)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(16)
            make.centerX.equalToSuperview()
        }
        avatarImage.layer.cornerRadius = CGFloat(100/2)
        avatarImage.clipsToBounds = true
   
        if let url = URL(string: config.avatarUrlString) {
            avatarImage.kf.setImage(with: url)
        }
        
        nameLabel = UILabel()
        self.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(avatarImage.snp.bottom).offset(16)
        }
        nameLabel.text = config.firstName + config.lastName
    }
    
}
