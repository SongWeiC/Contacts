//
//  WebServiceHelper.swift
//  Contacts
//
//  Created by SongWei Chuah on 25/10/21.
//

import Foundation

enum NetworkError: Error {
    case invalidResponse
    case unknown
}

typealias WebServiceCompletionBlock = (Result<Data, Error>) -> Void

struct WebServiceHelper {
    @discardableResult public static func requestAPI(apiURL: URL, completion: @escaping WebServiceCompletionBlock) -> URLSessionDataTask? {
        var request = URLRequest(url: apiURL)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? NetworkError.unknown))
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, ![200, 201].contains(httpStatus.statusCode) {
                completion(.failure(NetworkError.invalidResponse))
            }
            completion(.success(data))
        }
        task.resume()
        return task
    }
}
