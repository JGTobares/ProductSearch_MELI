//
//  APIProductDetail.swift
//  MELI_ProductSearch
//
//  Created by Julio Gabriel Tobares on 28/05/2025.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct ProductDetailsResponse: Codable {
    let id, status, domainID: String
    let permalink: String
    let name, familyName: String
    let buyBoxWinner: APIBuyBoxWinner
    let pickers: [APIPickerDetails]
    let pictures: [APIPictureDetails]
    let mainFeatures: [APIMainFeatureDetails]
    let attributes: [APIAttributeDetails]
    let shortDescription: APIShortDescriptionDetails
    let parentID: String
    let settings: APISettingsDetails
    let buyBoxActivationDate, dateCreated: Date

    enum CodingKeys: String, CodingKey {
        case id, status
        case domainID = "domain_id"
        case permalink, name
        case familyName = "family_name"
        case buyBoxWinner = "buy_box_winner"
        case pickers, pictures
        case mainFeatures = "main_features"
        case attributes
        case shortDescription = "short_description"
        case parentID = "parent_id"
        case settings
        case buyBoxActivationDate = "buy_box_activation_date"
        case dateCreated = "date_created"
    }
}

// MARK: - WelcomeAttribute
struct APIAttributeDetails: Codable {
    let id, name: String
    let valueID: String?
    let valueName: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case valueID = "value_id"
        case valueName = "value_name"
    }
}

// MARK: - MainFeature
struct APIMainFeatureDetails: Codable {
    let text, type: String
}

// MARK: - Picker
struct APIPickerDetails: Codable {
    let pickerID, pickerName: String
    let products: [APIPickerProductDetails]
    let attributes: [APIPickerAttributeDetails]

    enum CodingKeys: String, CodingKey {
        case pickerID = "picker_id"
        case pickerName = "picker_name"
        case products, attributes
    }
}

// MARK: - PickerAttribute
struct APIPickerAttributeDetails: Codable {
    let attributeID, template: String

    enum CodingKeys: String, CodingKey {
        case attributeID = "attribute_id"
        case template
    }
}

// MARK: - Product
struct APIPickerProductDetails: Codable {
    let productID, pickerLabel, pictureID: String
    let thumbnail: String
    //let tags: [String]
    let permalink: String
    
    enum CodingKeys: String, CodingKey {
        case productID = "product_id"
        case pickerLabel = "picker_label"
        case pictureID = "picture_id"
        case thumbnail, permalink //, tags
    }
}

// MARK: - Picture
struct APIPictureDetails: Codable {
    let id: String
    let url: String
    //let suggestedForPicker: [String]
    let maxWidth, maxHeight: Int

    enum CodingKeys: String, CodingKey {
        case id, url
        //case suggestedForPicker = "suggested_for_picker"
        case maxWidth = "max_width"
        case maxHeight = "max_height"
    }
}

// MARK: - Settings
struct APISettingsDetails: Codable {
    let listingStrategy: String

    enum CodingKeys: String, CodingKey {
        case listingStrategy = "listing_strategy"
    }
}

// MARK: - ShortDescription
struct APIShortDescriptionDetails: Codable {
    let type, content: String
}

// MARK: - BuyBoxWinner
struct APIBuyBoxWinner: Codable {
    let itemID, categoryID: String
    let sellerID, price: Int
    let currencyID: String
    let shipping: APIShippingDetails
    let warranty, condition: String
    let saleTerms: [APISaleTermDetails]
    let listingTypeID: String
    let acceptsMercadopago: Bool
    let sellerAddress: APISellerAddressDetails
    let internationalDeliveryMode: String
    //let tags: [String]
    let seller: APISellerDetails
    //let dealIDS: [String]
    let tier, inventoryID, productID, siteID: String

    enum CodingKeys: String, CodingKey {
        case itemID = "item_id"
        case categoryID = "category_id"
        case sellerID = "seller_id"
        case price
        case currencyID = "currency_id"
        case shipping, warranty, condition
        case saleTerms = "sale_terms"
        case listingTypeID = "listing_type_id"
        case acceptsMercadopago = "accepts_mercadopago"
        case sellerAddress = "seller_address"
        case internationalDeliveryMode = "international_delivery_mode"
        //case tags
        case seller
        //case dealIDS = "deal_ids"
        case tier
        case inventoryID = "inventory_id"
        case productID = "product_id"
        case siteID = "site_id"
    }
}

// MARK: - SaleTerm
struct APISaleTermDetails: Codable {
    let id, name: String
    let valueID: String?
    let valueName: String
    let valueStruct: APIValueStructDetails?

    enum CodingKeys: String, CodingKey {
        case id, name
        case valueID = "value_id"
        case valueName = "value_name"
        case valueStruct = "value_struct"
    }
}

// MARK: - ValueStruct
struct APIValueStructDetails: Codable {
    let number: Int
    let unit: String
}

// MARK: - Seller
struct APISellerDetails: Codable {
    let reputationLevelID: String

    enum CodingKeys: String, CodingKey {
        case reputationLevelID = "reputation_level_id"
    }
}

// MARK: - SellerAddress
struct APISellerAddressDetails: Codable {
    let city, state: APICityDetails
}

// MARK: - City
struct APICityDetails: Codable {
    let name: String
}

// MARK: - Shipping
struct APIShippingDetails: Codable {
    let mode: String
    //let tags: [String]
    let freeShipping: Bool
    let logisticType: String
    let storePickUp: Bool

    enum CodingKeys: String, CodingKey {
        case mode//, tags
        case freeShipping = "free_shipping"
        case logisticType = "logistic_type"
        case storePickUp = "store_pick_up"
    }
}
