//
//  PostAndReplyView.swift
//  FourFour
//
//  Created by Charles Thomas on 2024/5/14.
//
import SwiftUI

struct PostAndReplyView: View {
    var postURL: String
    @StateObject private var viewModel = PostScraperViewModel()
    
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
                                            .font(.system(size: 14))
                                            .foregroundColor(.gray)
                                        //                                    .font(.headline)
                                        //                                Text("UID:\(postDetail.uid)")
                                        
                                        Text("\(postDetail.postDate)")
                                            .font(.system(size: 14))
                                            .foregroundColor(.gray)
                                        //                                Text("\(postDetail.postNumber)")
                                        if let onlySeeAuthorLink = postDetail.onlySeeAuthorLink, let url = URL(string: onlySeeAuthorLink) {
                                            Link("只看该作者", destination: url)
                                                .font(.system(size: 14))
                                                .foregroundColor(.gray)
                                        }
                                        Spacer()
                                        Text("\(postDetail.score)")
                                            .font(.system(size: 14))
                                            .foregroundColor(postDetail.score > 10 ? Color(red: 0.2, green: 0.5, blue: 0.3).opacity(1) : Color.gray)
                                            .frame(alignment: .trailing)
                                        
                                        Text("/\(postDetail.postCount)")
                                            .font(.system(size: 14))
                                            .foregroundColor(.gray)
                                        if let postNumber = postDetail.postNumber {
                                            Text(" \(postNumber)")
                                                .font(.system(size: 14))
                                                .foregroundColor(.gray)
                                        }
                                        Text("#")
                                            .font(.system(size: 14))
                                            .foregroundColor(.gray)
                                    }
                                    
                                    if let quoteAuthor = postDetail.quoteAuthor, let quoteContent = postDetail.quoteContent, let quoteDate = postDetail.quoteDate, let quoteLinkContent = postDetail.quoteLinkContent, let quoteURL = URL(string: quoteLinkContent) {
                                        VStack(alignment: .leading, spacing: 5) {
                                            HStack{
                                                Image(systemName: "quote.bubble.rtl")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 60, height: 60) // 放大一倍（假设默认大小为15）
                                                    .foregroundColor(.gray)
                                                    .clipShape(CustomClipShape())  // 根据需要调整裁剪区域
                                                    .padding(.top, -10)  .padding(.leading, -15) // Left padding
                                                    .padding(.trailing, -10) // Right padding
                                                    .padding(.bottom, -20) // Bottom padding
                                                
                                                Text(quoteContent)
                                                    .foregroundColor(.gray)
                                                    .font(.system(size: 19))
                                                    .padding(.trailing, 25)
                                            }
                                            HStack {
                                                Spacer()
                                                Text("\(quoteAuthor)  \(quoteDate)")
                                                    .font(.caption)
                                                    .foregroundColor(.gray)
                                                    .font(.system(size: 13))
                                                
                                                Link(destination: quoteURL) {
                                                    Image(systemName: "arrowshape.turn.up.right")
                                                        .foregroundColor(.blue)
                                                }
                                            }
                                        }
                                        .padding(.leading, 10)
                                        //                                        .background(Color(UIColor.systemGray6))
                                        .cornerRadius(5)
                                    }
                                    Text(postDetail.postContent)
                                        .font(.system(size: 21))
                                    
                                    HStack(spacing: 10) {
                                        Spacer()
//                                        Image(systemName: "envelope")
//                                            .foregroundColor(.gray)
//                                            .font(.system(size: 14))
                                        Text("回复")
                                            .font(.system(size: 14))
                                            .foregroundColor(.gray)
                                        Text("引用")
                                            .font(.system(size: 14))
                                            .foregroundColor(.gray)
                                        Text("TOM")
                                            .font(.system(size: 14))
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
    PostAndReplyView(postURL: "viewthread.php?tid=3044209&extra=page%3D1")
}

