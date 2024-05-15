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
                            if !postDetail.uid.isEmpty {
                                VStack(alignment: .leading, spacing: 5) {
                                    HStack(spacing: 2) {
                                        Text("\(postDetail.author)")
                                            .font(.system(size: 12))
                                            .foregroundColor(.gray)
                                        //                                    .font(.headline)
                                        //                                Text("UID:\(postDetail.uid)")
                                        
                                        Text("\(postDetail.postDate)")
                                            .font(.system(size: 12))
                                            .foregroundColor(.gray)
                                        //                                Text("\(postDetail.postNumber)")
                                        if let onlySeeAuthorLink = postDetail.onlySeeAuthorLink, let url = URL(string: onlySeeAuthorLink) {
                                            Link("只看该作者", destination: url)
                                                .font(.system(size: 12))
                                                .foregroundColor(.gray)
                                        }
                                        Spacer()
                                        Text("\(postDetail.score)")
                                            .font(.system(size: 12))
                                            .foregroundColor(postDetail.postCount > 10 ? .black : .gray)
                                            .frame(alignment: .trailing)
                                            .foregroundColor(.gray)
                                        Text("/\(postDetail.postCount)")
                                            .font(.system(size: 12))
                                            .foregroundColor(.gray)
                                        if let postNumber = postDetail.postNumber {
                                            Text(" \(postNumber)")
                                                .font(.system(size: 12))
                                                .foregroundColor(.gray)
                                        }
                                        Text("#")
                                            .font(.system(size: 13))
                                            .foregroundColor(.gray)
                                    }
                                    if let quoteContent = postDetail.quoteContent {
                                                    HStack(alignment: .top) {
                                                        Image(systemName: "quote.opening")
                                                            .resizable()
                                                            .aspectRatio(contentMode: .fit)
                                                            .frame(width: 20, height: 20) // 放大一倍（假设默认大小为15）
                                                            .foregroundColor(.gray)
                                                        Text(quoteContent)
                                                            .foregroundColor(.gray)
                                                            .padding(.leading, 10) // 根据需要调整间距
                                                    }
                                                }
                                    Text(postDetail.postContent)
                                        .font(.system(size: 20))
                                    
                                    HStack(spacing: 10) {
                                        Spacer()
                                        Text("报告")
                                                .font(.system(size: 12))
                                                .foregroundColor(.gray)
                                        Text("回复")
                                                .font(.system(size: 12))
                                                .foregroundColor(.gray)
                                        Text("引用")
                                                .font(.system(size: 12))
                                                .foregroundColor(.gray)
                                        Text("TOP")
                                                .font(.system(size: 12))
                                                .foregroundColor(.gray)
                                        
                                    }
                                    Divider()
                                }
                                .padding(.bottom, 0)
                            }
                        }
                        .padding(.horizontal, 15)
                    }
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
    PostAndReplyView(postURL: "viewthread.php?tid=3222174&extra=page%3D1")
}
