//
//  UserList.swift
//  Scoot911_Aditya
//
//  Created by A1502 on 03/12/21.
//

import Foundation

// MARK: - UserList
import Foundation
struct UserList : Codable {
    let id : Int?
    let name : String?
    let username : String?
    let email : String?
    let address : Address?
    let phone : String?
    let website : String?
    let company : Company?
    let geo : Geo?

   
    
}
struct Address : Codable {
    let street : String?
    let suite : String?
    let city : String?
    let zipcode : String?
    let geo : Geo?
    
   
}
struct Company : Codable {
    let name : String?
    let catchPhrase : String?
    let bs : String?
    

    
}
struct Geo : Codable {
    let lat : String?
    let lng : String?
    
    
    
}
