//
//  AccessToken.swift
//  MELI_ProductSearch
//
//  Created by Julio Gabriel Tobares on 28/05/2025.
//

import Foundation

struct AccessToken: Decodable {
    let accessToken: String
    let tokenType: String
    let expiresIn: Int
    let scope: String
    let userId: Int

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case scope
        case userId = "user_id"
    }
    
}
