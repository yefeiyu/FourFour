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
                                HStack(spacing: 2) {
                                    Text("\(postDetail.author)")
                                    .font(.system(size: 12))
//                                    .font(.headline)
//                                Text("UID:\(postDetail.uid)")
                                
                                    Text("\(postDetail.postDate)")
                                        .font(.system(size: 12))
                                    //                                Text("\(postDetail.postNumber)")
                                    if let onlySeeAuthorLink = postDetail.onlySeeAuthorLink, let url = URL(string: onlySeeAuthorLink) {
                                        Link("只看该作者", destination: url)
                                            .font(.system(size: 12))
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                        Text("\(postDetail.score)")
                                            .font(.system(size: 13))
                                            .foregroundColor(postDetail.postCount > 10 ? .black : .gray)
                                            .frame(alignment: .trailing)
                                        Text("/\(postDetail.postCount)")
                                            .font(.system(size: 12))
                                            .foregroundColor(.gray)
                                    if let postNumber = postDetail.postNumber {
                                                                            Text("\(postNumber)")
                                                                                .font(.system(size: 12))
                                                                        }
                                    Text(" #")
                                        .font(.system(size: 12))
                                }
                                if let quoteAuthor = postDetail.quoteAuthor, let quoteContent = postDetail.quoteContent {
                                    Text("引用自 \(quoteAuthor):")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    Text(quoteContent)
                                        .foregroundColor(.gray)
                                }
                                Text(postDetail.postContent)
                                    .font(.system(size: 20))
                                HStack(spacing: 10) {
                                    if let reportLink = postDetail.reportLink, let url = URL(string: reportLink) {
                                        Link("报告", destination: url)
                                            .font(.system(size: 12))
                                    }
                                    
                                    if let replyLink = postDetail.replyLink, let url = URL(string: replyLink) {
                                        Link("回复", destination: url)
                                            .font(.system(size: 12))
                                    }
                                    
                                    if let quoteLink = postDetail.quoteLink, let url = URL(string: quoteLink) {
                                        Link("引用", destination: url)
                                            .font(.system(size: 12))
                                    }
                                    
                                    if let topLink = postDetail.topLink, let url = URL(string: topLink) {
                                        Link("TOP", destination: url)
                                            .font(.system(size: 12))
                                    }
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
#Preview {
    PostAndReplyView(postURL: "viewthread.php?tid=3044209&extra=page%3D1")
}
