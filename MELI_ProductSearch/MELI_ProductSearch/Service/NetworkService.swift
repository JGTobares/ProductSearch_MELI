//
//  NetworkService.swift
//  MELI_ProductSearch
//
//  Created by Julio Gabriel Tobares on 28/05/2025.
//

import Combine
import Foundation

protocol NetworkServiceProtocol: AnyObject {
    typealias Headers = [String: Any]
    
    func getWithAuth<T>(type: T.Type, url: URL) -> AnyPublisher<T, Error> where T: Decodable
}

final class NetworkService: NSObject, NetworkServiceProtocol {
    
    private var session: URLSession {
        return URLSession.shared
    }
    
    private func configureDefaultHeaders(_ urlRequest: inout URLRequest, withAuth: Bool = true) {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        urlRequest.setValue("Bearer \(Constants.authToken)", forHTTPHeaderField:"Authorization")
    }
    
    private func mapHTTPStatusCode(_ statusCode: Int) -> NetworkError? {
        switch statusCode {
        case 200..<300:
            return nil
        case 401:
            return .unauthorized
        case 402:
            return .paymentRequired
        case 403:
            return .forbidden
        case 404:
            return .notFound
        default:
            return .unknown(URLError(.unknown))
        }
    }
    
    func getWithAuth<T>(type: T.Type, url: URL) -> AnyPublisher<T, Error> where T : Decodable {
        var urlRequest = URLRequest(url: url)
        
        configureDefaultHeaders(&urlRequest)
        
        return session.dataTaskPublisher(for: urlRequest)
            .tryMap { (data, response) -> (data: Data, response: URLResponse) in
                guard let urlResponse = response as? HTTPURLResponse  else {
                    throw NetworkError.invalidResponse
                }
                if let error = self.mapHTTPStatusCode(urlResponse.statusCode) {
                    throw error
                }
                if (200..<300) ~= urlResponse.statusCode {
                    print("RECEIVED!")
                }
                return (data, response)
            }
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
