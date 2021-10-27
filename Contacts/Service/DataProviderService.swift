//
//  DataProviderService.swift
//  Contacts
//
//  Created by SongWei Chuah on 25/10/21.
//

import Foundation
import PromiseKit

protocol DataProviderServiceType {
    func getInitialContactList() -> Promise<ContactListViewModel>
    func getSubsequentContactList(pageNum: Int) -> Promise<ContactListViewModel>
    func updateContact(contact: ContactViewModel) -> Promise<Bool>
    func clearLocalContactList()
}

///DataProviderService class is an adapter class that link to network layer AND core data layer class
///This class's responsibility is managing retrieving data from local or from API as well as updating
class DataProviderService: DataProviderServiceType {
    var coreDataService: CoreDataServiceType!
    
    init(coreDataService: CoreDataServiceType) {
        self.coreDataService = coreDataService
    }
    
    func clearLocalContactList() {
        coreDataService.deleteContactIfNeeded()
    }
    
    ///NOTE: here we set if first launch the app, contact list is pull from API and copy into local
    ///on subsequent pulling getContactList, data should be from local
    func getInitialContactList() -> Promise<ContactListViewModel> {
        return Promise { seal in
            let localContact = coreDataService.getContactList()
            if localContact.count > 0 {
                let contactVM = localContact.map {
                    ContactViewModel(id: Int($0.id!)!, email: $0.email!, firstName: $0.firstName!, lastName: $0.lastName!, avatarUrlString: $0.avatarUrlString!)
                }
                seal.fulfill(ContactListViewModel(totalItem: localContact.count, list: contactVM))
            } else {
                getContactListFromAPI(pageNum: 1).done { contactList in
                    seal.fulfill(contactList)
                } .catch { error in
                    seal.reject(error)
                }
            }
        }
    }
    
    func getSubsequentContactList(pageNum: Int) -> Promise<ContactListViewModel> {
        return Promise { seal in
            getContactListFromAPI(pageNum: pageNum).done { contactList in
                seal.fulfill(contactList)
            } .catch { error in
                seal.reject(error)
            }
        }
    }
    
    private func getContactListFromAPI(pageNum: Int) -> Promise<ContactListViewModel> {
        return Promise { seal in
            NetworkServiceRequest().getContactList(pageNum: pageNum) {[weak self] apiResult in
                switch apiResult {
                case .success(let contactAPIModel):
                    
                    var contactList = [ContactViewModel]()
                    contactList = contactAPIModel.data.map { contact in
                        ContactViewModel(id: contact.id, email: contact.email, firstName: contact.first_name, lastName: contact.last_name, avatarUrlString: contact.avatar)
                    }
                    self?.coreDataService.addContactList(list: contactList)
                    seal.fulfill(ContactListViewModel(totalItem: contactAPIModel.total, list: contactList))
                    
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }
    }
    
    func updateContact(contact: ContactViewModel) -> Promise<Bool> {
        return Promise { seal in
            let _contact = ContactAPIModel(id: contact.id, email: contact.email, first_name: contact.firstName, last_name: contact.lastName, avatar: contact.avatarUrlString)
            NetworkServiceRequest().updateContact(contact: _contact) { apiResult in
                switch apiResult {
                case .success( _):
                    seal.fulfill(true)
                    
                case .failure( _):
                    seal.fulfill(false)
                }
            }
            coreDataService.updateContact(_contact: contact)
        }
    }
}


