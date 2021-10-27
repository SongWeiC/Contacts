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
        setUpDetailView()
    }
    
    func setUpDetailView() {
        let detailView = EditContactDetailView(config: dataSource.getSelectedContact(), dataSource: dataSource)
        detailView.delegate = self
        self.view.addSubview(detailView)
        detailView.snp.makeConstraints{ make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    deinit {
        print("EditContactVC - deinit")
    }

}

extension EditContactDetailViewController: EditContactDetailViewDelegateType {
    func userDidPressedCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func userDidPressedDone() {
        self.dismiss(animated: true, completion: nil)
    }
}

