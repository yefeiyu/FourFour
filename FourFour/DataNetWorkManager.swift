//
//  DataNetWorkManager.swift
//  FourFour
//
//  Created by Charles Thomas on 2024/5/18.
//
import Foundation
class DataNetworkManager {
    func fetchData(from url: URL) async throws -> String {
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let htmlString = String(data: data, encoding: .gbk) else {
            throw NSError(domain: "EncodingError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to decode data with GBK encoding"])
        }
        return htmlString
    }
}
