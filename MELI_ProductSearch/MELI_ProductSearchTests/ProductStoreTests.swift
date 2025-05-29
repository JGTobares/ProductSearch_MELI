//
//  ProductStoreTests.swift
//  MELI_ProductSearch
//
//  Created by Julio Gabriel Tobares on 29/05/2025.
//
import XCTest
import Combine
import CoreData
@testable import MELI_ProductSearch

class ProductStoreTests: XCTestCase {
    var store: ProductStore!
    var dbManager: DBManager!
    var mockNetworkService: MockNetworkService!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        dbManager = DBManager(inMemory: true)
        mockNetworkService = MockNetworkService()
        store = ProductStore(dbManager: dbManager, productService: mockNetworkService)
        cancellables = []
    }

    override func tearDown() {
        store = nil
        dbManager = nil
        mockNetworkService = nil
        cancellables = nil
        super.tearDown()
    }

    func test_Perform_Search_EmptyQuery() {
        // Given
        let query = "   "

        // When
        store.performSearch(query: query)

        // Then
        XCTAssertTrue(store.searchResults.isEmpty, "Search results should be empty for empty query")
    }

    func test_Perform_Search_Without_Token() {
        // Given
        let query = "iPad"

        // When
        store.performSearch(query: query)

        // Then
        XCTAssertTrue(store.searchResults.isEmpty, "Search results should be empty without token")
    }

    func test_Perform_Search_With_Token_Success() {
        // Given
        let query = "iPad"
        let mockResponse = SearchResponse(
            keywords: query,
            paging: SearchResponse.Paging(total: 1, limit: 10, offset: 0),
            results: [
                APIProduct(
                    id: "MLA123",
                    status: "active",
                    domain_id: "MLA-TABLETS",
                    settings: .init(listing_strategy: "catalog_required"),
                    name: "iPad Pro",
                    attributes: [.init(id: "BRAND", name: "Marca", value_id: "9344", value_name: "Apple")],
                    pictures: [.init(id: "IMG1", url: "https://example.com/img1.jpg")],
                    parent_id: "MLA456"
                )
            ]
        )
        mockNetworkService.searchResponse = mockResponse

        let expectation = XCTestExpectation(description: "Search completes")

        // When
        store.performSearch(query: query)

        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.store.searchResults.count, 1, "Should have one search result")
            XCTAssertEqual(self.store.searchResults.first?.name, "iPad Pro")
            XCTAssertEqual(self.store.searchResults.first?.category, "MLA-TABLETS")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func test_Perform_Search_With_Token_Error() {
        // Given
        let query = "iPad"
        mockNetworkService.searchError = NetworkError.notFound

        let expectation = XCTestExpectation(description: "Search fails")

        // When
        store.performSearch(query: query)

        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.store.errorMessage, "Not found.", "Error message should be set")
            XCTAssertTrue(self.store.searchResults.isEmpty, "Search results should be empty on error")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func test_Get_Product_Detail_Without_Token() {
        // Given
        let productId = "MLA123"

        // When
        store.getProductDetail(productID: productId)

        // Then
        XCTAssertNil(store.currentProductDetails, "Current product details should be nil without token")
    }

    func test_Get_Product_Detail_With_Token_Success() {
        // Given
        let productId = "MLA123"

        // Pre-guardar un Product para cumplir con saveProductDetails
        let context = dbManager.persistentContainer.viewContext
        let product = Product(context: context)
        product.id = productId
        product.name = "iPad Pro"
        product.status = "active"
        product.domain_id = "MLA-TABLETS"
        product.listing_strategy = "catalog_required"
        product.parent_id = "MLA456"
        product.lastUpdated = Date()
        try? context.save()

        let mockResponse = generateMockProductDetailsResponse(productId: productId)
        mockNetworkService.productDetailsResponse = mockResponse

        let expectation = XCTestExpectation(description: "Product detail fetch completes")

        // When
        store.getProductDetail(productID: productId)

        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertNotNil(self.store.currentProductDetails, "Current product details should be set")
            XCTAssertEqual(self.store.currentProductDetails?.id, productId)
            XCTAssertEqual(self.store.currentProductDetails?.name, "iPad Pro")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func test_Get_Product_Detail_With_Token_Error() {
        // Given
        let productId = "MLA123"
        mockNetworkService.productDetailsError = NetworkError.notFound

        let expectation = XCTestExpectation(description: "Product detail fetch fails")

        // When
        store.getProductDetail(productID: productId)

        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.store.errorMessage, "Not found.", "Error message should be set")
            XCTAssertNil(self.store.currentProductDetails, "Current product details should be nil on error")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func test_Get_Product() {
        // Given
        let productId = "MLA123"
        let context = dbManager.persistentContainer.viewContext
        let product = Product(context: context)
        product.id = productId
        product.name = "iPad Pro"
        try? context.save()

        // When
        store.getProduct(byId: productId)

        // Then
        let fetchedProduct = try? dbManager.fetchProduct(byId: productId)
        XCTAssertNotNil(fetchedProduct, "Product should be fetched")
        XCTAssertEqual(fetchedProduct?.id, productId)
    }

    func test_Get_Product_Details() {
        // Given
        let productId = "MLA123"
        let mockDetails = dbManager.generateMockProductDetails(productId: productId, in: dbManager.persistentContainer.viewContext)
        try? dbManager.persistentContainer.viewContext.save()

        // When
        let details = store.getProductDetails(byId: productId)

        // Then
        XCTAssertNotNil(details, "Product details should be fetched")
        XCTAssertEqual(details?.id, productId)
    }

    func test_Get_Product_Details_Mock() {
        // Given
        let productId = "MLA14719808"

        // When
        let mockDetails = store.getProductDetailsMock()

        // Then
        XCTAssertNotNil(mockDetails, "Mock product details should be generated")
        XCTAssertEqual(mockDetails?.id, productId)
        XCTAssertEqual(mockDetails?.name, "iPad Apple 6th generation 2018 A1954 9.7\" 32GB Gold")
    }

    // Helper para generar mock de ProductDetailsResponse
    private func generateMockProductDetailsResponse(productId: String) -> ProductDetailsResponse {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        let mockBuyBoxWinner = APIBuyBoxWinner(
            itemID: "MLA12345678",
            categoryID: "MLA456",
            sellerID: 789012,
            price: 599999,
            currencyID: "ARS",
            shipping: APIShippingDetails(
                mode: "me2",
                freeShipping: true,
                logisticType: "xd_drop_off",
                storePickUp: false
            ),
            warranty: "12 meses",
            condition: "new",
            saleTerms: [
                APISaleTermDetails(
                    id: "WARRANTY_TIME",
                    name: "Tiempo de garantía",
                    valueID: nil,
                    valueName: "12 meses",
                    valueStruct: APIValueStructDetails(number: 12, unit: "meses")
                )
            ],
            listingTypeID: "gold_special",
            acceptsMercadopago: true,
            sellerAddress: APISellerAddressDetails(
                city: APICityDetails(name: "Buenos Aires"),
                state: APICityDetails(name: "Capital Federal")
            ),
            internationalDeliveryMode: "none",
            seller: APISellerDetails(reputationLevelID: "5_green"),
            tier: "standard",
            inventoryID: "INV123",
            productID: "MLA123",
            siteID: "MLA"
        )
        
        return ProductDetailsResponse(
            id: productId,
            status: "active",
            domainID: "MLA-TABLETS",
            permalink: "https://example.com/product",
            name: "iPad Pro",
            familyName: "Apple iPad",
            buyBoxWinner: mockBuyBoxWinner,
            pickers: [
                .init(pickerID: "COLOR", pickerName: "Color", products: [
                    .init(productID: productId, pickerLabel: "Gold", pictureID: "IMG1", thumbnail: "https://example.com/thumb1.jpg", permalink: "https://example.com")
                ], attributes: [.init(attributeID: "COLOR", template: "")])
            ],
            pictures: [.init(id: "IMG1", url: "https://example.com/img1.jpg", maxWidth: 800, maxHeight: 600)],
            mainFeatures: [.init(text: "Pantalla Retina", type: "key_value")],
            attributes: [.init(id: "BRAND", name: "Marca", valueID: "9344", valueName: "Apple")],
            shortDescription: .init(type: "plaintext", content: "Descripción mock"),
            parentID: "MLA456",
            settings: .init(listingStrategy: "catalog_required"),
            buyBoxActivationDate: dateFormatter.date(from: "2023-01-01T12:00:00Z") ?? Date(),
            dateCreated: dateFormatter.date(from: "2022-01-01T12:00:00Z") ?? Date()
        )
    }
}

// Mock NetworkService
class MockNetworkService: NetworkServiceProtocol {
    var searchResponse: SearchResponse?
    var searchError: Error?
    var productDetailsResponse: ProductDetailsResponse?
    var productDetailsError: Error?

    func getWithAuth<T: Decodable>(type: T.Type, url: URL) -> AnyPublisher<T, any Error> where T : Decodable {
        if url.absoluteString.contains("/search") {
            if let error = searchError {
                return Fail(error: error as! NetworkError).eraseToAnyPublisher()
            }
            if let response = searchResponse as? T {
                return Just(response).setFailureType(to: Error.self).eraseToAnyPublisher()
            }
        } else {
            if let error = productDetailsError {
                return Fail(error: error as! NetworkError).eraseToAnyPublisher()
            }
            if let response = productDetailsResponse as? T {
                return Just(response).setFailureType(to: Error.self).eraseToAnyPublisher()
            }
        }
        return Fail(error: NetworkError.invalidResponse).eraseToAnyPublisher()
    }
}
