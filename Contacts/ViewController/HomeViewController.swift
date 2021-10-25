//
//  HomeViewController.swift
//  Contacts
//
//  Created by SongWei Chuah on 25/10/21.
//

import Foundation
import UIKit
import SnapKit

protocol HomeViewControllerDelegateType: AnyObject {
    func showContactDetail()
}

class HomeViewController: UIViewController {
    private let dataSource: ContactDataSourceType
    private var tableView = UITableView()
    var delegate: HomeViewControllerDelegateType?
    
    required init(dataSource: ContactDataSourceType) {
        self.dataSource = dataSource
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Contact"
        view.backgroundColor = .white
        setUpRightBarItem()
        setUpTableView()
        loadUI()
    }
    
    func setUpRightBarItem() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(userDidSelectAddButton))
    }
    
    @objc func userDidSelectAddButton() {
        print("addbutton tapped")
    }
    
    func loadUI() {
        dataSource.getContactList().done { [weak self] _ in
            self?.tableView.reloadData()
        }.catch { error in
            //Error handling here
        }
    }
    
    func loadMoreContact() {
        dataSource.getMoreContactList() { startIndex, endIndex, error in
            if error != nil {return}
            guard let startIndex = startIndex, let endIndex = endIndex else {return}
            var indexPathArray = [IndexPath]()
            for i in startIndex..<endIndex {
                let path = IndexPath(item: i, section: 0)
                indexPathArray.append(path)
            }
            self.tableView.insertRows(at: indexPathArray, with: .none)
        }
    }
    
    func setUpTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.separatorStyle = .singleLine
        tableView.allowsSelection = true
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false

        tableView.backgroundView = UIView()
        tableView.backgroundView?.backgroundColor = .clear
        tableView.contentInsetAdjustmentBehavior = .never
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dataSource.setSelectedContact(index: indexPath.row)
        self.delegate?.showContactDetail()
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.contactList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HomeTableViewCell
        
        cell.backgroundColor = .clear
        let contactView = ContactViewTile(config: dataSource.contactList[indexPath.row])
        cell.childView = contactView
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == dataSource.contactList.count - 5 {
            loadMoreContact()
        }
    }
}
