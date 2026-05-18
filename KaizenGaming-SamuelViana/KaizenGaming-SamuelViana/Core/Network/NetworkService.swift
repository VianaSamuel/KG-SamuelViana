//
//  NetworkService.swift
//  KaizenGaming-SamuelViana
//
//  Created by Samuel Viana on 17/05/26.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case decodingFailed(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL."
        case .requestFailed(let e): return "Request failed: \(e.localizedDescription)"
        case .invalidResponse: return "Invalid server response."
        case .decodingFailed(let e): return "Failed to parse response: \(e.localizedDescription)"
        }
    }
}

protocol NetworkServiceProtocol {
    func fetchSports() async throws -> [Sport]
}

final class NetworkService: NetworkServiceProtocol {

    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchSports() async throws -> [Sport] {
        guard let url = URL(string: Constants.API.sportsURL) else {
            throw NetworkError.invalidURL
        }

        let (data, response) = try await session.data(from: url)

        guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
            throw NetworkError.invalidResponse
        }

        return try JSONDecoder().decode([Sport].self, from: data)
    }
}
