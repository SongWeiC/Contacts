//
//  ContactDetailViewController.swift
//  Contacts
//
//  Created by SongWei Chuah on 25/10/21.
//

import Foundation
import UIKit

protocol ContactDetailVCDelegateType: AnyObject {
    func userDidTapEdit()
}

class ContactDetailViewController: UIViewController {
    private let dataSource: ContactDataSourceType
    weak var delegate: ContactDetailVCDelegateType?
    required init(dataSource: ContactDataSourceType) {
        self.dataSource = dataSource
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        setUpRightBarItem()
        setUpDetailView()
    }
    
    func setUpRightBarItem() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(userDidSelectEditButton))
    }
    
    @objc func userDidSelectEditButton() {
        self.delegate?.userDidTapEdit()
    }
    
    func setUpDetailView() {
        let detailView = ContactDetailView(config: dataSource.getSelectedContact())
        self.view.addSubview(detailView)
        detailView.snp.makeConstraints{ make in
            make.edges.equalToSuperview()
        }
    }
}

