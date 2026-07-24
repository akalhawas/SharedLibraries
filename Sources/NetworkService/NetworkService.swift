//
//  NCGRNetworkService.swift
//  ModularizedByFeature
//
//  Created by ali alhawas on 23/07/2026.
//

import Foundation
import Combine

public protocol NetworkService {
    func request<T: Decodable>(_ endpoint: Endpoint) -> AnyPublisher<T, Error>
}

public final class NetworkServiceImp: NetworkService {

    private let session: URLSession
    private let decoder: JSONDecoder

    public init(session: URLSession = .shared, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }

    public func request<T: Decodable>(_ endpoint: Endpoint) -> AnyPublisher<T, Error> {
        guard let urlRequest = makeURLRequest(for: endpoint) else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }

        return session.dataTaskPublisher(for: urlRequest)
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NetworkError.invalidResponse
                }
                guard (200..<300).contains(httpResponse.statusCode) else {
                    throw NetworkError.http(statusCode: httpResponse.statusCode, data: data)
                }
                return data
            }
            .tryMap { [decoder] data in
                try Self.decode(T.self, from: data, using: decoder)
            }
            .mapError { error in
                switch error {
                case let networkError as NetworkError:
                    return networkError
                case let decodingError as DecodingError:
                    return NetworkError.decoding(decodingError)
                default:
                    return NetworkError.underlying(error)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    private static func decode<T: Decodable>(_ type: T.Type, from data: Data, using decoder: JSONDecoder) throws -> T {
        if data.isEmpty {
            guard let empty = EmptyResponse() as? T else {
                throw NetworkError.invalidResponse
            }
            return empty
        }

        if T.self == String.self {
            guard let string = String(data: data, encoding: .utf8) as? T else {
                throw NetworkError.decoding(
                    DecodingError.dataCorrupted(
                        .init(codingPath: [], debugDescription: "Unable to decode raw string response")
                    )
                )
            }
            return string
        }

        return try decoder.decode(T.self, from: data)
    }

    private func makeURLRequest(for endpoint: Endpoint) -> URLRequest? {
        var components = URLComponents(
            url: endpoint.baseURL.appendingPathComponent(endpoint.path),
            resolvingAgainstBaseURL: false
        )
        components?.queryItems = endpoint.queryItems

        guard let url = components?.url else { return nil }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.method.rawValue
        urlRequest.httpBody = endpoint.body
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        endpoint.headers?.forEach { urlRequest.setValue($1, forHTTPHeaderField: $0) }

        return urlRequest
    }
}
