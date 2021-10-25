//
//  ContactDataSource.swift
//  Contacts
//
//  Created by SongWei Chuah on 25/10/21.
//

import Foundation
import PromiseKit

protocol ContactDataSourceType {
    var contactList: [ContactViewModel] {get set}
    func getContactList() -> Promise<[ContactViewModel]>
    func getMoreContactList(completion: @escaping (Int?, Int?, Error?) -> ())
}

class ContactDataSource: ContactDataSourceType {
    var contactList = [ContactViewModel]()
    
    var dataProviderService: DataProviderServiceType!
    var pageNumber = 1
    private var totalContactCount = 0
    
    init() {
        self.dataProviderService = DataProviderService()
    }
    
    func getContactList() -> Promise<[ContactViewModel]> {
        return Promise { seal in
            dataProviderService.getContactList(pageNum: 1).done { contactList in
                self.totalContactCount = contactList.totalItem
                self.contactList = contactList.list
                seal.fulfill(self.contactList)
            } .catch { error in
                seal.reject(error)
            }
        }
    }
    
    func getMoreContactList(completion: @escaping (Int?, Int?, Error?) -> ()) {
        if !(totalContactCount >= contactList.count) {return}
        pageNumber += 1
        dataProviderService.getContactList(pageNum: pageNumber).done { contactList in
            let startIndex = self.contactList.count
            self.contactList.append(contentsOf: contactList.list)
            let endIndex = self.contactList.count
            completion(startIndex, endIndex, nil)
        } .catch { error in
            completion(nil, nil, error)
        }
        
    }
    
}
