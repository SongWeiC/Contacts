//
//  ContactViewModel.swift
//  Contacts
//
//  Created by SongWei Chuah on 25/10/21.
//

import Foundation

struct ContactListViewModel: Decodable {
    let totalItem: Int
    let list: [ContactViewModel]
}

struct ContactViewModel: Decodable {
    let id: Int
    let email: String
    let firstName: String
    let lastName: String
    let avatarUrlString: String
}
