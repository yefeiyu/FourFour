//
//  PostAndReplyView.swift
//  FourFour
//
//  Created by Charles Thomas on 2024/5/14.
//
import SwiftUI

struct PostAndReplyView: View {
    var postURL: String
    @StateObject private var viewModel = WebScraperViewModel()
    
    var body: some View {
        VStack {
            if viewModel.postDetails.isEmpty {
                Text("Loading...")
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(viewModel.postDetails) { postDetail in
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Author: \(postDetail.author)")
                                    .font(.headline)
                                Text("UID: \(postDetail.uid)")
                                Text("Posts: \(postDetail.postCount)")
                                Text("Score: \(postDetail.score)")
                                Text("Date: \(postDetail.postDate)")
                                Text("Post Number: \(postDetail.postNumber)")
                                Text("Content:")
                                    .font(.subheadline)
                                Text(postDetail.postContent)
                                
                                if let quoteAuthor = postDetail.quoteAuthor, let quoteContent = postDetail.quoteContent {
                                    Text("Quote from \(quoteAuthor):")
                                        .font(.subheadline)
                                    Text(quoteContent)
                                }
                                
                                Divider()
                            }
                            .padding(.bottom, 10)
                        }
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            Task {
                print("Post URL: \(postURL)")
                await viewModel.loadPostDetails(for: postURL)
            }
        }
        .navigationTitle("Post Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
}
