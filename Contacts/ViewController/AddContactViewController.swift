//
//  AddContactViewController.swift
//  Contacts
//
//  Created by SongWei Chuah on 27/10/21.
//

import Foundation
import UIKit


class AddContactViewController: UIViewController {
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
        setUpDetailView()
    }
    
    func setUpDetailView() {
        let detailView = AddContactDetailView(dataSource: dataSource)
        detailView.delegate = self
        self.view.addSubview(detailView)
        detailView.snp.makeConstraints{ make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    deinit {
        print("AddContactVC - deinit")
    }

}

extension AddContactViewController: AddContactDetailViewDelegateType {
    func userDidPressedCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func userDidPressedDone() {
        self.dismiss(animated: true, completion: nil)
    }
}
