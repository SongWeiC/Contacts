//
//  DataProviderService.swift
//  Contacts
//
//  Created by SongWei Chuah on 25/10/21.
//

import Foundation
import PromiseKit

protocol DataProviderServiceType {
    func getContactList(pageNum: Int) -> Promise<ContactListViewModel>
}

class DataProviderService: DataProviderServiceType {
    init() {
        
    }
    
    func getContactList(pageNum: Int) -> Promise<ContactListViewModel> {
        return Promise { seal in
            NetworkServiceRequest().getContactList(pageNum: pageNum) { apiResult in
                switch apiResult {
                case .success(let contactAPIModel):
                    
                    var contactList = [ContactViewModel]()
                    contactList = contactAPIModel.data.map { contact in
                        ContactViewModel(id: contact.id, email: contact.email, firstName: contact.first_name, lastName: contact.last_name, avatarUrlString: contact.avatar)
                    }
                    seal.fulfill(ContactListViewModel(totalItem: contactAPIModel.total, list: contactList))
                    
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }
    }
}


