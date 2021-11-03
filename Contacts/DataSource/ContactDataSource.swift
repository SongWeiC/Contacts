//
//  ContactDataSource.swift
//  Contacts
//
//  Created by SongWei Chuah on 25/10/21.
//

import Foundation
import PromiseKit

///NOTE: This class is the viewModel that prepare view data
///1. Hold actual data
///2. Polish data for UI friendly
///3. Adapter class to data provider class
protocol ContactDataSourceType {
    var contactList: [ContactViewModel] {get set}
    var viewModelToViewBinding: (() -> ())? { get set }
    func getContactList() -> Promise<[ContactViewModel]>
    func getMoreContactList(completion: @escaping (Int?, Int?, Error?) -> ())
    func setSelectedContact(index: Int)
    func getSelectedContact() -> ContactViewModel
    func updateSelectedContact(firstName: String, lastName: String) -> Promise<Bool>
    func addNewContact(firstName: String, lastName: String, email: String)
}

class ContactDataSource: ContactDataSourceType {
    var viewModelToViewBinding: (() -> ())?
    
    var contactList = [ContactViewModel]() {
        didSet {
            self.viewModelToViewBinding?()
        }
    }
    var dataProviderService: DataProviderServiceType!
    var pageNumber = 1
    private var totalContactCount = 0 {
        didSet {
            if totalContactCount >= contactList.count {
                shouldRetrieveFromBackend = false
            }
        }
    }
    var selectedContact: ContactViewModel!
    private var shouldRetrieveFromBackend = true
    
    init(dataProviderService: DataProviderServiceType) {
        self.dataProviderService = dataProviderService
    }
    
    ///When we retrieve contact list for new session
    func getContactList() -> Promise<[ContactViewModel]> {
        return Promise { seal in
            dataProviderService.getInitialContactList().done { contactList in
                self.totalContactCount = contactList.totalItem
                self.contactList = contactList.list
                self.contactList.sort { $0.id < $1.id }
                seal.fulfill(self.contactList)
            } .catch { error in
                seal.reject(error)
            }
        }
    }
    
    func getMoreContactList(completion: @escaping (Int?, Int?, Error?) -> ()) {
        if contactList.count >= totalContactCount {return}
        pageNumber += 1
        dataProviderService.getSubsequentContactList(pageNum: pageNumber).done { contactList in
            let startIndex = self.contactList.count
            self.contactList.append(contentsOf: contactList.list)
            let endIndex = self.contactList.count
            completion(startIndex, endIndex, nil)
        } .catch { error in
            completion(nil, nil, error)
        }
    }
    
    func setSelectedContact(index: Int) {
        self.selectedContact = contactList[index]
    }
    
    func getSelectedContact() -> ContactViewModel {
        return self.selectedContact
    }
    
    func updateSelectedContact(firstName: String, lastName: String) -> Promise<Bool> {
        return Promise { seal in
            let updatedContact = ContactViewModel(id: selectedContact.id, email: selectedContact.email, firstName: firstName, lastName: lastName, avatarUrlString: selectedContact.avatarUrlString)
            selectedContact = updatedContact
            for i in 0..<contactList.count {
                if contactList[i].id == updatedContact.id {
                    contactList[i] = updatedContact
                }
            }
            
            //Update backend, API call
            dataProviderService.updateContact(contact: selectedContact).done { didUpdateContact in
                seal.fulfill(didUpdateContact)
            }
        }
    }
    
    func addNewContact(firstName: String, lastName: String, email: String) {
        let newContact = newContactStub(firstName: firstName, lastName: lastName,email: email)
        dataProviderService.addNewContact(contact: newContact)
        contactList.append(newContact)
    }
    
    func newContactStub(firstName: String, lastName: String,email: String) -> ContactViewModel {
        return ContactViewModel(id: contactList.count+1, email: email, firstName: firstName, lastName: lastName, avatarUrlString: "")
    }
}
