//
//  WebScraperViewModel.swift
//  DownUrl
//
//  Created by Charles Thomas on 2024/5/8.
//import Foundation
//import SwiftSoup
//
//@MainActor
//class WebScraperViewModel: ObservableObject {
//    @Published var posts: [ForumPost] = []
//    private let networkManager = NetworkManager()
//    
//    func loadPosts(for forumID: Int) async {
//        guard let url = ForumURLs.forumDisplay(fid: forumID) else { return }
//
//        do {
//            let html = try await networkManager.fetchData(from: url)
//            self.posts = try parsePosts(from: html)
//        } catch {
//            print("Error during network or parsing operation: \(error)")
//        }
//    }
//    
//    private func parsePosts(from html: String) throws -> [ForumPost] {
//        var posts: [ForumPost] = []
//        let doc = try SwiftSoup.parse(html)
//        let elements = try doc.select("desired-element-selector")  // 根据具体情况选择器可能需要改变
//
//        for element in elements {
//            // 解析HTML元素获取数据
//            let title = try element.select("title-selector").text()  // 举例
//            let post = ForumPost(id: "" , title: title, imageAttachments: [], replyPages: [], author: "", postDate: "", replyCount: 0, viewCount: 0, lastReplyUser: "", lastReplyTime: "")
//            posts.append(post)
//        }
//        return posts
//    }
//}
import SwiftUI

@MainActor
class WebScraperViewModel: ObservableObject {
    @Published var posts: [ForumPost] = []
    private let networkManager = NetworkManager()
    
    func loadPosts(for forumID: Int) async {
        guard let url = ForumURLs.forumDisplay(fid: forumID) else { return }

        do {
            let html = try await networkManager.fetchData(from: url)
            let posts = try HTMLParser().parseHTML(html: html)
            self.posts = posts
        } catch {
            print("Error during network or parsing operation: \(error)")
        }
    }
}

