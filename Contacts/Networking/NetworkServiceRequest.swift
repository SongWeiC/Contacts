//
//  NetworkServiceRequest.swift
//  Contacts
//
//  Created by SongWei Chuah on 25/10/21.
//

import Foundation

typealias GetResponse = (Result<[ContactViewModel], Error>) -> Void

protocol NetworkServiceRequestType {
    @discardableResult func getContactList(completion: @escaping GetResponse) -> URLSessionDataTask?
}


struct NetworkServiceRequest: NetworkServiceRequestType {
    @discardableResult func getContactList(completion: @escaping GetResponse) -> URLSessionDataTask? {
        let apiURLString = "https://reqres.in/api/users?page=1&per_page=10"
        
        let apiURL = URL(string: apiURLString)
        
        return WebServiceHelper.requestAPI(apiURL: apiURL!) { response in
            switch response {
            case .success(let apiResponse):
                JSONResponseDecoder.decodeFrom(apiResponse, returningModelType: ContactListAPIModel.self, completion: { (contactAPIModel, error) in
                    if let parseError = error {
                        completion(.failure(parseError))
                        return
                    }
                    
                    if let contacts = contactAPIModel {
                        var contactList = [ContactViewModel]()
                        contactList = contacts.data.map { contact in
                            ContactViewModel(id: contact.id, email: contact.email, firstName: contact.first_name, lastName: contact.last_name, avatarUrlString: contact.avatar)
                        }
                        completion(.success(contactList))
                        return
                    }
                })
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
