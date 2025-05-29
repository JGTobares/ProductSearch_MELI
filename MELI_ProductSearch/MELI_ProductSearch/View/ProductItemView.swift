//
//  ProductItemView.swift
//  MELI_ProductSearch
//
//  Created by Julio Gabriel Tobares on 28/05/2025.
//
import SwiftUI

struct ProductItemView: View {
    
    let product: SearchResult
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 16) {
                Text(product.name).font(.headline)
                Text(product.category).font(.subheadline)

                Text(product.description).fontWeight(.semibold).font(.footnote).lineLimit(4)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 15)
    }
}
