//
//  ForumPost.swift
//  FourDay
//
//  Created by Charles Thomas on 2024/5/8.
//
import Foundation

struct ForumPost: Identifiable, Hashable {
    let id = UUID()  // Provides a unique identifier for each post
    var titlecommon: String?
    var titlenew: String?
    var imageAttachments: [String]
    var replyPages: [Int]
    var author: String
    var postDate: String
    var replyCount: Int
    var viewCount: Int
    var lastReplyUser: String
    var lastReplyTime: String
}
