//
//  DetailsActionView.swift
//  Contacts
//
//  Created by SongWei Chuah on 25/10/21.
//

import Foundation
import UIKit

enum DetailType {
    case message
    case call
    case email
    case favourite
    
    var title: String {
        switch self {
        case .message:
            return "message"
            
        case .call:
            return "call"
            
        case .email:
            return "email"
            
        case .favourite:
            return "favourite"
        }
    }
}

class DetailsActionView: UIView {
    private let type: DetailType
    
    private var iconImage: UIImageView!
    private var titleLabel: UILabel!
    
    init(type: DetailType) {
        self.type = type
        super.init(frame: .zero)
        customInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func customInit() {
        iconImage = UIImageView()
        iconImage.contentMode = .scaleAspectFit
        self.addSubview(iconImage)
        iconImage.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(16)
            make.centerX.equalToSuperview()
        }
        iconImage.layer.cornerRadius = CGFloat(40/2)
        iconImage.clipsToBounds = true
        iconImage.image = UIImage(named: self.type.title)
        
        titleLabel = UILabel()
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(iconImage.snp.bottom).offset(5)
        }
        titleLabel.text = self.type.title
    }
}
