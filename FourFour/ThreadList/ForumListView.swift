//
//  PostListView.swift
//  FourDay
//
//  Created by Charles Thomas on 2024/5/8.
//

import SwiftUI

struct ForumListView: View {
    @StateObject var scraperViewModel = WebScraperViewModel()
    
    var body: some View {
        List(scraperViewModel.posts, id: \.self) { post in
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text(post.author)
                        .font(Font.system(size: 12))
                        .foregroundColor(.gray)
                    Text(post.postDate)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                    Spacer()
                    Text(post.lastReplyUser)
                        .font(Font.system(size: 12))
                        .foregroundColor(.gray)
                    Text(post.lastReplyTime)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                    HStack(spacing: 0) {
                        Text("\(post.replyCount)")
                            .font(.system(size: 13))
                            .foregroundColor(post.replyCount > 10 ? .orange : .gray)
                            .frame(alignment: .trailing)
                        Text("/\(post.viewCount)")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                    .lineLimit(1)
                }
                .lineLimit(1)
                if let titleNew = post.titlenew, !titleNew.isEmpty {
                    Text(titleNew + " ")
                        .font(.system(size: 20)) +
                    post.imageAttachments.reduce(Text("")) { (result, attachment) -> Text in
                        if attachment == "https://c.4d4y.com/forum/images/attachicons/common.gif" {
                            return result + Text(Image(systemName: "paperclip"))
                        } else if attachment == "https://c.4d4y.com/forum/images/attachicons/image_s.gif" {
                            return result + Text(Image(systemName: "photo"))
                        } else {
                            return result + Text(attachment)
                        }
                    }
                } else if let titleCommon = post.titlecommon, !titleCommon.isEmpty {
                    Text(titleCommon + " ")
                        .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.1)) // Common posts color
                        .font(.system(size: 20)) +
                    post.imageAttachments.reduce(Text("")) { (result, attachment) -> Text in
                        if attachment == "https://c.4d4y.com/forum/images/attachicons/common.gif" {
                            return result + Text(Image(systemName: "paperclip"))
                        } else if attachment == "https://c.4d4y.com/forum/images/attachicons/image_s.gif" {
                            return result + Text(Image(systemName: "photo"))
                        } else {
                            return result + Text(attachment)
                        }
                    }
                }

            }
        }
        .onAppear {
            Task {
                await scraperViewModel.loadPosts(for: 7)
            }
        }
    }
}

#Preview {
    ForumListView()
}
