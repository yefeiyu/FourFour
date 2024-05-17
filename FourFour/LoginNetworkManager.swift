//
//  File.swift
//  FourDay
//
//  Created by Charles Thomas on 2024/5/8.
//
import Foundation

class LoginNetworkManager {
    func login(url: URL, loginData: String) async throws -> Bool {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        guard let encodedData = loginData.data(using: .gbk) else {
            throw NSError(domain: "EncodingError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to encode login data with GBK encoding"])
        }
        request.httpBody = encodedData
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            return false
        }
        return true  // 假设返回状态码200意味着登录成功
    }
}
