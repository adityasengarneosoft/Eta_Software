//
//  PostDetails.swift
//  Scoot911_AdityaNew
//
//  Created by A1502 on 06/12/21.
//

import Foundation

// MARK: - PostDetails
struct PostDetails: Codable {
    let userID, id: Int?
    let title, body: String?

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, body
    }
}
