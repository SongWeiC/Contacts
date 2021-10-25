//
//  ContactListAPIModel.swift
//  Contacts
//
//  Created by SongWei Chuah on 25/10/21.
//

import Foundation

struct ContactListAPIModel: Decodable {
    let page: Int
    let per_page: Int
    let total: Int
    let total_pages: Int
    let data: [ContactAPIModel]
}

struct ContactAPIModel: Decodable {
    let id: Int
    let email: String
    let first_name: String
    let last_name: String
    let avatar: String
}
