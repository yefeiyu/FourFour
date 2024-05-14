//
//  HTMLParser.swift
//  DownUrl
//
//  Created by Charles Thomas on 2024/5/8.
//
import SwiftSoup

class HTMLParser {
    func parseHTML(html: String) throws -> [ForumPost] {
        var posts = [ForumPost]()
        let doc = try SwiftSoup.parse(html)
        let elements = try doc.select("tbody[id^=normalthread]") // Select all posts

        for element in elements {
            let titleCommon = try element.select("th.subject.common").text()
            let titleNew = try element.select("th.subject.new").text()
            let images = try element.select("img.attach").array().map { try $0.attr("src") }
            let replyPages = try element.select("span.threadpages a").array().map { try Int($0.text()) ?? 1 }
            let author = try element.select("td.author cite a").text()
            let postDate = try element.select("td.author em").text()
            let counts = try element.select("td.nums").text().split(separator: "/").map(String.init)
            let replyCount = Int(counts[0]) ?? 0
            let viewCount = Int(counts[1]) ?? 0
            let lastReplyUser = try element.select("td.lastpost cite a").text()
            let lastReplyTime = try element.select("td.lastpost em a").text()

            let post = ForumPost(
                titlecommon: titleCommon.isEmpty ? nil : titleCommon,
                titlenew: titleNew.isEmpty ? nil : titleNew,
                imageAttachments: images,
                replyPages: replyPages,
                author: author,
                postDate: postDate,
                replyCount: replyCount,
                viewCount: viewCount,
                lastReplyUser: lastReplyUser,
                lastReplyTime: lastReplyTime
            )
            posts.append(post)
        }
        return posts
    }
}
