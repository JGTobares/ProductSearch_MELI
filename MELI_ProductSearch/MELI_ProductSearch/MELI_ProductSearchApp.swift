//
//  MELI_ProductSearchApp.swift
//  MELI_ProductSearch
//
//  Created by Julio Gabriel Tobares on 27/05/2025.
//

import SwiftUI

@main
struct MELI_ProductSearchApp: App {
    
    let dbManager: DBManager
    let productStore: ProductStore
    
    init() {
        dbManager = DBManager()
        let productService = NetworkService()//ProductService()
        productStore = ProductStore(dbManager: dbManager, productService: productService)
    }
    
    var body: some Scene {
        WindowGroup {
            SearchView()
                .environment(productStore)
        }
    }
}
