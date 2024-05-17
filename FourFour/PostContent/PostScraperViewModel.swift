//
//  PostScraperViewModel.swift
//  FourFour
//
//  Created by Charles Thomas on 2024/5/18.
//
import SwiftUI

@MainActor
class PostScraperViewModel: ObservableObject {
    @Published var postDetails: [ForumPostDetail] = []
    private let networkManager = DataNetworkManager()

    
    func loadPostDetails(for postURL: String) async {
        let fullURLString = "\(ForumURLs.baseURL)\(postURL)"
        guard let url = URL(string: fullURLString) else {
            print("Invalid URL: \(fullURLString)")
            return
        }

        do {
            let html = try await networkManager.fetchData(from: url)
            let postDetails = try PostHTMLParser().parseHTML(html: html)
            self.postDetails = postDetails
        } catch {
            print("Error during network or parsing operation: \(error)")
        }
    }
}
