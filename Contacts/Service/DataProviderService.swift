//
//  DataProviderService.swift
//  Contacts
//
//  Created by SongWei Chuah on 25/10/21.
//

import Foundation
import PromiseKit

protocol DataProviderServiceType {
    func getContactList() -> Promise<[ContactViewModel]>
}

class DataProviderService: DataProviderServiceType {
    init() {
        
    }
    
    func getContactList() -> Promise<[ContactViewModel]> {
        return Promise { seal in
            NetworkServiceRequest().getContactList() { apiResult in
                switch apiResult {
                case .success(let contactList):
                    seal.fulfill(contactList)
                    
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }
    }
}
