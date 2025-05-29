//
//  ProductStore.swift
//  MELI_ProductSearch
//
//  Created by Julio Gabriel Tobares on 27/05/2025.
//
import Foundation
import Combine
import Observation

struct SearchResult: Identifiable {
    let id: String
    let name: String
    let description: String
    let category: String
}

enum NetworkError: Error {
    case invalidResponse
    case unauthorized // 401
    case paymentRequired // 402
    case forbidden // 403
    case notFound // 404
    case unknown(Error)
}

// MARK: - Store (Observable)
@Observable
class ProductStore {
    private let dbManager: DBManager
    private let productService: NetworkServiceProtocol
    private let userDefaults = UserDefaults.standard
    private var cancellables = Set<AnyCancellable>()
    
    var searchResults: [SearchResult] = []
    var currentProductDetails: ProductDetails?
    var searchQuery: String = ""
    var errorMessage: String = ""
    var product: APIProduct?
    
    init(dbManager: DBManager, productService: NetworkServiceProtocol) {
        self.dbManager = dbManager
        self.productService = productService
    }
    
    func performSearch(query: String) {
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            searchResults = []
            return
        }
        
        if !Constants.authToken.isEmpty {
            let stringUrl = "\(Constants.productSearchBaseUrl)/search?status=active&site_id=MLA&q=\(query)"
            guard let url = URL(string: stringUrl) else { return }
            
            productService.getWithAuth(type: SearchResponse.self, url: url)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { [weak self] completion in
                    guard let self = self else { return }
                    if case .failure(let error) = completion {
                        self.handleError(error)
                    }
                }, receiveValue: { [weak self] searchResponse in
                    guard let self = self else { return }
                    
                    do {
                        try self.dbManager.saveProducts(from: searchResponse)
                        
                        self.searchResults = searchResponse.results.map { apiProduct in
                            SearchResult(
                                id: apiProduct.id,
                                name: apiProduct.name,
                                description: apiProduct.attributes.compactMap { $0.value_name }.joined(separator: ", "),
                                category: apiProduct.domain_id
                            )
                        }

                    } catch {
                        self.handleError(error)
                    }
                })
                .store(in: &cancellables)
        } else {
            //Without token show a mocked list
            searchResults = [] //Mock a list
        }
    }
    
    func getProductDetail(productID: String) {
        if !Constants.authToken.isEmpty {
            let stringUrl = "\(Constants.productSearchBaseUrl)/\(productID)" 
            guard let url = URL(string: stringUrl) else { return }
            
            productService.getWithAuth(type: ProductDetailsResponse.self, url: url)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { [weak self] completion in
                    guard let self = self else { return }
                    if case .failure(let error) = completion {
                        self.handleError(error)
                    }
                }, receiveValue: { [weak self] productDetailsResponse in
                    guard let self = self else { return }
                    
                    do {
                        try self.dbManager.saveProductDetails(from: productDetailsResponse)
                        self.currentProductDetails = try self.dbManager.fetchProductDetails(byId: productDetailsResponse.id)
                    } catch {
                        self.handleError(error)
                    }
                })
                .store(in: &cancellables)
        } else {
            //Without token show a mocked list
            searchResults = [] //Mock a list
        }
    }
    
    func getProduct(byId productId: String) {
        _ = try? dbManager.fetchProduct(byId: productId)
    }
    
    func getProductDetails(byId productId: String) -> ProductDetails? {
        try? dbManager.fetchProductDetails(byId: productId)
    }
    
    func getProductDetailsMock() -> ProductDetails? {
        dbManager.generateMockProductDetails(productId: "MLA14719808", in: dbManager.persistentContainer.viewContext)
    }
    
    private func handleError(_ error: Error) {
        if let networkError = error as? NetworkError {
            switch networkError {
            case .unauthorized:
                errorMessage = "Not authorized. Please, loggin again."
            case .paymentRequired:
                errorMessage = "It requires payment for this resource."
            case .forbidden:
                errorMessage = "Access denied."
            case .notFound:
                errorMessage = "Not found."
            case .invalidResponse:
                errorMessage = "Invalid Response."
            case .unknown(let underlyingError):
                errorMessage = "Unknown error: \(underlyingError.localizedDescription)"
            }
        } else if error is DecodingError {
            errorMessage = "Key not found"
        } else {
            errorMessage = "Error: \(error.localizedDescription)"
        }
    }
}
