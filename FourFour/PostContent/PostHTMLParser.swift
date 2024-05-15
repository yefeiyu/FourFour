//
//  PostHTMLParser.swift
//  FourFour
//
//  Created by Charles Thomas on 2024/5/14.
//
import SwiftSoup
import Foundation

struct ForumPostDetail: Identifiable, Hashable {
    let id = UUID()
    var author: String
    var uid: String
    var postCount: Int
    var score: Int
    var postDate: String
    var postNumber: String?
    var postContent: String
    var quoteAuthor: String?
    var quoteDate: String?
    var quoteContent: String?
    var quoteLinkContent: String?
    var onlySeeAuthorLink: String?
    var reportLink: String?
    var replyLink: String?
    var quoteLink: String?
    var topLink: String?
}

class PostHTMLParser {
    func parseHTML(html: String) throws -> [ForumPostDetail] {
        let doc = try SwiftSoup.parse(html)
        let postElements = try doc.select("div[id^=post_]")

        var postDetails = [ForumPostDetail]()

        for postElement in postElements {
            let author = try postElement.select("td.postauthor .postinfo a").text()
            let uid = try postElement.select("dl.profile dt:contains(UID) + dd").text().trimmingCharacters(in: .whitespacesAndNewlines)
            let postCount = Int(try postElement.select("dl.profile dt:contains(帖子) + dd").text().trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
            let score = Int(try postElement.select("dl.profile dt:contains(积分) + dd").text().trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
            let postDate = try postElement.select("em[id^=authorposton]").text().replacingOccurrences(of: "发表于 ", with: "")
            let postNumber = try postElement.select("a[id^=postnum]").attr("id").replacingOccurrences(of: "postnum", with: "")
            let postContent = try postElement.select("td.t_msgfont").text()

            let onlySeeAuthorLink = try postElement.select("div.authorinfo a").attr("href")
            let reportLink = try postElement.select("a[href*=misc.php?action=report]").attr("href")
            let replyLink = try postElement.select("a.fastreply").attr("href")
            let quoteLink = try postElement.select("a.repquote").attr("href")
            let topLink = try postElement.select("a[href*=scrollTo]").attr("href")
            
            // Parse quote if exists
            var quoteAuthor: String? = nil
            var quoteDate: String? = nil
            var quoteContent: String? = nil
            var quoteLinkContent: String? = nil

            if let quoteElement = try postElement.select("div.quote blockquote").first() {
                quoteContent = try quoteElement.text()
                quoteAuthor = try quoteElement.select("font[color='#999999']").first()?.text().components(separatedBy: " 发表于 ").first
                quoteDate = try quoteElement.select("font[color='#999999']").first()?.text().components(separatedBy: " 发表于 ").last
                quoteLinkContent = try quoteElement.select("a").attr("href")
            }

            let postDetail = ForumPostDetail(
                author: author,
                uid: uid,
                postCount: postCount,
                score: score,
                postDate: postDate,
                postNumber: postNumber,
                postContent: postContent,
                quoteAuthor: quoteAuthor,
                quoteDate: quoteDate,
                quoteContent: quoteContent,
                quoteLinkContent: quoteLinkContent,
                onlySeeAuthorLink: onlySeeAuthorLink,
                reportLink: reportLink,
                replyLink: replyLink,
                quoteLink: quoteLink,
                topLink: topLink
            )
            
            postDetails.append(postDetail)
        }
        
        return postDetails
    }
}
