//
//  ContactViewModel.swift
//  Contacts
//
//  Created by SongWei Chuah on 25/10/21.
//

import Foundation

struct ContactViewModel: Decodable {
    let id: Int
    let email: String
    let firstName: String
    let lastName: String
    let avatarUrlString: String
}
