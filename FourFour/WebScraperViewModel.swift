//
//  WebScraperViewModel.swift
//  DownUrl
//
//  Created by Charles Thomas on 2024/5/8.
import SwiftUI

@MainActor
class WebScraperViewModel: ObservableObject {
    @Published var posts: [ForumPost] = []
    @Published var postDetails: [ForumPostDetail] = []
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
    
    func loadPostDetails(for postURL: String) async {
        let fullURLString = "\(ForumURLs.baseURL)\(postURL)"
        guard let url = URL(string: fullURLString) else {
            print("Invalid URL: \(fullURLString)")
            return
        }

        do {
            let html = try await networkManager.fetchPostContent(from: url)
            let postDetails = try PostHTMLParser().parseHTML(html: html)
            self.postDetails = postDetails
        } catch {
            print("Error during network or parsing operation: \(error)")
        }
    }
}
