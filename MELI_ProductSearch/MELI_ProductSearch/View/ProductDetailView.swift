//
//  ProductDetailView.swift
//  MELI_ProductSearch
//
//  Created by Julio Gabriel Tobares on 27/05/2025.
//

import SwiftUI

struct ProductDetailView: View {
    @Environment(ProductStore.self) private var store
    let productId: String
    @State private var selectedPickerOptions: [String: String] = [:]
    /*
    var body: some View {
        ScrollView {
           VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(store.currentProductDetails?.name ?? "")
                            .font(.title)
                            .fontWeight(.bold)
                        if let familyName = store.currentProductDetails?.family_name {
                            Text(familyName)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        Link("Ver en MercadoLibre", destination: URL(string: store.currentProductDetails?.permalink ?? "")!)
                            .font(.subheadline)
                            .foregroundStyle(.blue)
                    }
                    
                    Section {
                        Text(store.currentProductDetails?.shortdescription?.content ?? "")
                            .font(.body)
                            .foregroundStyle(.secondary)
                    } header: {
                        Text("Descripción")
                            .font(.headline)
                    }
                    
                    Section {
                        ForEach(store.currentProductDetails?.attributes, id: \.id) { attribute in
                            HStack {
                                Text(attribute.name + ":")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                Text(attribute.value_name ?? "N/A")
                                    .font(.subheadline)
                            }
                        }
                    } header: {
                        Text("Atributos")
                            .font(.headline)
                    }
                    
                    Section {
                        DisclosureGroup {
                            Text("ID: \(store.currentProductDetails?.id)")
                            Text("Estado: \(store.currentProductDetails?.status)")
                            Text("Dominio: \(store.currentProductDetails?.domain_id)")
                            Text("Creado: \(store.currentProductDetails?.dateCreated, format: .dateTime.day().month().year())")
                            if let parentId = store.currentProductDetails?.parent_id {
                                Text("Parent ID: \(parentId)")
                            }
                            if let activationDate = store.currentProductDetails?.buyBoxActivationDate {
                                Text("Activación Buy Box: \(activationDate, format: .dateTime.day().month().year())")
                            }
                            if let settingsData = store.currentProductDetails?.settings,
                               let settings = try? JSONDecoder().decode(APISettingsDetails.self, from: settingsData) {
                                Text("Estrategia: \(settings.listingStrategy)")
                            }
                        } label: {
                            Text("Metadatos")
                                .font(.headline)
                        }
                    }
            }
            .padding()
        }
        .navigationTitle("Detalles")
        .onAppear {
            //REAL DATA
            //store.getProductDetail(productID: productId)
            
            //MOCK DATA
            store.getProductDetailsMock()
        }
    }
     */
    
    var body: some View {
        Text("Hello, World!")
    }
}
