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
            let postNumber = try postElement.select("strong a[id^=postnum] em").text()

            let onlySeeAuthorLink = try postElement.select("div.authorinfo a").attr("href")
            let reportLink = try postElement.select("div.postactions a[href*=misc.php?action=report]").attr("href")
            let replyLink = try postElement.select("div.postactions a.fastreply").attr("href")
            let quoteLink = try postElement.select("div.postactions a.repquote").attr("href")
            let topLink = try postElement.select("div.postactions a[href*=scrollTo]").attr("href")
            
            var postContent = ""
            var quoteAuthor: String? = nil
            var quoteDate: String? = nil
            var quoteContent: String? = nil
            var quoteLinkContent: String? = nil
            
            if let postContentElement = try postElement.select("td.t_msgfont").first() {
                // Parse quote if exists
                if let quoteElement = try postContentElement.select("div.quote blockquote").first() {
                    quoteContent = try quoteElement.text()
                    quoteAuthor = try quoteElement.select("font[color='#999999']").first()?.text().components(separatedBy: " 发表于 ").first
                    quoteDate = try quoteElement.select("font[color='#999999']").first()?.text().components(separatedBy: " 发表于 ").last
                    quoteLinkContent = try quoteElement.select("a").attr("href")
                    
                    // Remove quote element after parsing
                    try postContentElement.select("div.quote").remove()
                }
                
                // Extract post content without quote
                postContent = try postContentElement.text()
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
