//
//  File.swift
//  FourDay
//
//  Created by Charles Thomas on 2024/5/8.
//
//import Foundation
//
//class NetworkManager {
//    func fetchData(from url: URL) async throws -> String {
//        let (data, _) = try await URLSession.shared.data(from: url)
//        let gbkEncoding = CFStringEncodings.GB_18030_2000.rawValue
//        let cfEncoding = CFStringEncoding(gbkEncoding)
//        let encoding = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(cfEncoding))
//        
//        guard let htmlString = String(data: data, encoding: encoding) else {
//            throw NSError(domain: "EncodingError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to decode data with GBK encoding"])
//        }
//        
//        return htmlString
//    }
////}
///下面是错误不能登录。
import Foundation

class NetworkManager {
    func fetchData(from url: URL) async throws -> String {
        let (data, _) = try await URLSession.shared.data(from: url)
        
        // 指定GBK编码
        let gbkEncoding = CFStringEncodings.GB_18030_2000.rawValue
        let cfEncoding = CFStringEncoding(gbkEncoding)
        let encoding = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(cfEncoding))
        
        // 尝试使用GBK编码解码数据
        guard let htmlString = String(data: data, encoding: encoding) else {
            throw NSError(domain: "EncodingError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to decode data with GBK encoding"])
        }
        
        return htmlString
    }
    
    func login(url: URL, loginData: String) async throws -> Bool {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        // 使用GBK编码对登录数据进行编码
        let gbkEncoding = CFStringEncodings.GB_18030_2000.rawValue
        let cfEncoding = CFStringEncoding(gbkEncoding)
        let encoding = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(cfEncoding))
        guard let encodedData = loginData.data(using: encoding) else {
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
