//
//  SearchView.swift
//  MELI_ProductSearch
//
//  Created by Julio Gabriel Tobares on 27/05/2025.
//

import SwiftUI

struct SearchView: View {
    @Environment(ProductStore.self) var store
    @State private var localSearchQuery: String = ""
    
    var shouldShowError: Bool {
        !store.errorMessage.isEmpty
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                CustomTextFieldRepresentable(
                    text: $localSearchQuery,
                    onDone: {
                        store.searchQuery = localSearchQuery
                        store.performSearch(query: localSearchQuery)
                    }
                )
                .frame(width: 350, height: 30)
                .padding([.leading, .trailing], 10)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 2)
                )
                
                List {
                    ForEach(store.searchResults, id: \.id) { item in
                        NavigationLink(destination: ProductDetailView(productId: item.id)) {
                            VStack(alignment: .leading) {
                                ProductItemView(product: item)
                            }
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Search Products")
            .alert("Error", isPresented: .constant(shouldShowError)) {
                Button("OK") {
                    store.errorMessage = ""
                }
            } message: {
                Text(store.errorMessage)
            }
        }
    }
}
