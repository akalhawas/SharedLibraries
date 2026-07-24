//
//  NetworkError.swift
//  ModularizedByFeature
//
//  Created by ali alhawas on 23/07/2026.
//

import Foundation

public enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case http(statusCode: Int, data: Data?)
    case decoding(Error)
    case underlying(Error)
}
