//
//  EditContactDetailViewController.swift
//  Contacts
//
//  Created by SongWei Chuah on 26/10/21.
//

import Foundation
import UIKit


class EditContactDetailViewController: UIViewController {
    private let dataSource: ContactDataSourceType
    
    required init(dataSource: ContactDataSourceType) {
        self.dataSource = dataSource
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .white
//        setUpNavBar()
        setUpDetailView()
    }
    
    func setUpDetailView() {
        let detailView = EditContactDetailView(config: dataSource.getSelectedContact())
        self.view.addSubview(detailView)
        detailView.snp.makeConstraints{ make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
}

