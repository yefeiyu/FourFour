//
//  GenericPostListView.swift
//  DownUrl
//
//  Created by Charles Thomas on 2024/5/8.
//
import SwiftUI

struct GenericPostListView: View {
    @ObservedObject var scraperViewModel: ThreadScraperViewModel

    var body: some View {
        List(scraperViewModel.posts, id: \.self) { post in
            VStack(alignment: .leading, spacing: 2) {
                //Text(post.title)
                HStack {
                    Text(post.author)
                        .font(Font.system(size: 12))
                        .foregroundColor(.gray)
                        .frame(width: 40, height: 20)
                    Text(post.postDate)
                        .font(.system(size: 9))
                        .foregroundColor(.gray)
                    Spacer()
                    Text(post.lastReplyUser)
                        .font(Font.system(size: 12))
                        .foregroundColor(.gray)
                        .frame(width: 40, height: 20)
                    Text(post.lastReplyTime)
                        .font(.system(size: 9))
                        .foregroundColor(.gray)
                    HStack(spacing: 0) {
                        Text("\(post.replyCount)")
                            .font(.system(size: 12))
                            .foregroundColor(post.replyCount > 9 ? .orange : .gray)
                            .frame(alignment: .trailing)
                        Text("/\(post.viewCount)")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                }
                //Text(post.title)
            }
        }
    }
}

