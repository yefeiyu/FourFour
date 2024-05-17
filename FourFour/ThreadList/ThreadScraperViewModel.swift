//
//  ThreadScraperViewModel.swift
//  FourFour
//
//  Created by Charles Thomas on 2024/5/18.
//
import SwiftUI

@MainActor
class ThreadScraperViewModel: ObservableObject {
    @Published var posts: [ForumPost] = []
    private let networkManager = DataNetworkManager()
    
    func loadPosts(for forumID: Int) async {
        guard let url = ForumURLs.forumDisplay(fid: forumID) else { return }
        
        do {
            let html = try await networkManager.fetchData(from: url)
            let newPosts = try HTMLParser().parseHTML(html: html)
            updatePosts(with: newPosts)
        } catch {
            print("Error during network or parsing operation: \(error)")
        }
    }
    
    private func updatePosts(with newPosts: [ForumPost]) {
        var updatedPosts = posts
        for newPost in newPosts {
            if let index = posts.firstIndex(where: { $0.url == newPost.url }) {
                updatedPosts[index] = newPost
            } else {
                updatedPosts.append(newPost)
            }
        }
        posts = updatedPosts
    }
}
