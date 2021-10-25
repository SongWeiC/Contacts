//
//  NetworkServiceRequest.swift
//  Contacts
//
//  Created by SongWei Chuah on 25/10/21.
//

import Foundation

typealias GetResponse = (Result<ContactListAPIModel, Error>) -> Void

protocol NetworkServiceRequestType {
    @discardableResult func getContactList(pageNum: Int, completion: @escaping GetResponse) -> URLSessionDataTask?
}


struct NetworkServiceRequest: NetworkServiceRequestType {
    @discardableResult func getContactList(pageNum: Int, completion: @escaping GetResponse) -> URLSessionDataTask? {
        var apiURLString = "https://reqres.in/api/users?page={{pageNum}}&per_page=10"
        apiURLString = apiURLString.replacingOccurrences(of: "{{pageNum}}", with: "\(pageNum)")
        let apiURL = URL(string: apiURLString)
        
        return WebServiceHelper.requestAPI(apiURL: apiURL!) { response in
            switch response {
            case .success(let apiResponse):
                JSONResponseDecoder.decodeFrom(apiResponse, returningModelType: ContactListAPIModel.self, completion: { (contactAPIModel, error) in
                    if let parseError = error {
                        completion(.failure(parseError))
                        return
                    }
                    if let result = contactAPIModel {
                        completion(.success(result))
                        return
                    }
                    
                })
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
