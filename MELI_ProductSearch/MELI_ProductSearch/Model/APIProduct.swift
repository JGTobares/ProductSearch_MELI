//
//  APIProduct.swift
//  MELI_ProductSearch
//
//  Created by Julio Gabriel Tobares on 27/05/2025.
//
import Foundation

struct APIProduct: Codable {
    let id: String
    let status: String
    let domain_id: String
    let settings: Settings
    let name: String
    let attributes: [APIAttribute]
    let pictures: [APIPicture]
    let parent_id: String
    
    struct Settings: Codable {
        let listing_strategy: String
    }
}

struct APIAttribute: Codable {
    let id: String
    let name: String
    let value_id: String?
    let value_name: String?
}

struct APIPicture: Codable {
    let id: String
    let url: String
}

struct SearchResponse: Codable {
    let keywords: String
    let paging: Paging
    let results: [APIProduct]
    
    struct Paging: Codable {
        let total: Int
        let limit: Int
        let offset: Int
    }
}
