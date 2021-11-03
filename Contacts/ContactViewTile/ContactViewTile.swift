//
//  ContactViewTile.swift
//  Contacts
//
//  Created by SongWei Chuah on 25/10/21.
//

import Foundation
import Kingfisher
import SnapKit

class ContactViewTile: UIView {
    
    private struct Constants {
        private init() {}
        static let tileHeight = 50
    }
    
    private var config: ContactViewModel
    private var backgroundView = UIView()
    private var avatarImage: UIImageView!
    private var nameLabel: UILabel!
    
    init(config: ContactViewModel) {
        self.config = config
        super.init(frame: .zero)
        customInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func customInit() {
        setBackground()
        setUpDetailsUI()
    }
    
    private func setUpDetailsUI() {
        avatarImage = UIImageView()
        avatarImage.contentMode = .scaleAspectFit
        backgroundView.addSubview(avatarImage)
        avatarImage.snp.makeConstraints { make in
            make.width.height.equalTo(Constants.tileHeight)
            make.left.equalToSuperview().offset(24)
            make.centerY.equalToSuperview()
        }
        avatarImage.layer.cornerRadius = CGFloat(Constants.tileHeight/2)
        avatarImage.clipsToBounds = true
   
        if let url = URL(string: config.avatarUrlString) {
            avatarImage.kf.setImage(with: url)
        } else {
            avatarImage.image = UIImage(named: "defaultAvatar")
        }
        
        nameLabel = UILabel()
        backgroundView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(avatarImage.snp.right).offset(24)
        }
        nameLabel.text = config.firstName + " " + config.lastName
    }
    
    private func setBackground() {
        addSubview(backgroundView)
        backgroundView.snp.makeConstraints{ make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.bottom.equalToSuperview().priority(.low)
            make.right.equalToSuperview()
            make.height.equalTo(80)
        }
    }
}
