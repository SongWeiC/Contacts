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
}

class ContactDataSource: ContactDataSourceType {
    var contactList = [ContactViewModel]()
    
    var dataProviderService: DataProviderServiceType!
    
    init() {
        self.dataProviderService = DataProviderService()
    }
    
    func getContactList() -> Promise<[ContactViewModel]> {
        return Promise { seal in
            dataProviderService.getContactList().done { contactList in
                self.contactList = contactList
                seal.fulfill(contactList)
            } .catch { error in
                seal.reject(error)
            }
        }
    }
    
    
}
