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

        for element in postElements {
            let author = try element.select("td.postauthor .postinfo a").text()
            let uid = try element.select("dl.profile dt:contains(UID) + dd").text().trimmingCharacters(in: .whitespacesAndNewlines)
            let postCount = Int(try element.select("dl.profile dt:contains(帖子) + dd").text().trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
            let score = Int(try element.select("dl.profile dt:contains(积分) + dd").text().trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
            let postDate = try element.select("em[id^=authorposton]").text().replacingOccurrences(of: "发表于 ", with: "")
            let postNumber = try element.select("strong a[id^=postnum] em").text()

            let onlySeeAuthorLink = try element.select("div.authorinfo a").attr("href")
            let reportLink = try element.select("div.postactions a[href*=misc.php?action=report]").attr("href")
            let replyLink = try element.select("div.postactions a.fastreply").attr("href")
            let quoteLink = try element.select("div.postactions a.repquote").attr("href")
            let topLink = try element.select("div.postactions a[href*=scrollTo]").attr("href")
            
            var postContent = ""
            var quoteAuthor: String? = nil
            var quoteDate: String? = nil
            var quoteContent: String? = nil
            var quoteLinkContent: String? = nil

            if let postContentElement = try element.select("td.t_msgfont").first() {
                // Parse quote if exists
                if let quoteElement = try postContentElement.select("blockquote").first() {
                    quoteContent = try quoteElement.ownText()
                    quoteAuthor = try quoteElement.select("font[color='#999999']").first()?.text().components(separatedBy: " 发表于 ").first
                    quoteDate = try quoteElement.select("font[color='#999999']").first()?.text().components(separatedBy: " 发表于 ").last
                    quoteLinkContent = try quoteElement.select("a").attr("href")
                    
                    // Remove quote element after parsing
                    try quoteElement.remove()
                }
                
                // Extract post content without quote and keep <br> tags
                postContent = try postContentElement.html()
                postContent = postContent.replacingOccurrences(of: "<br>", with: "\n")
                
                // Replace &nbsp; with space
                postContent = postContent.replacingOccurrences(of: "&nbsp;", with: " ")
                
                // Remove other HTML tags but keep the newlines
                postContent = try SwiftSoup.clean(postContent, Whitelist.none().addTags("br"))!
                postContent = postContent.replacingOccurrences(of: "<br>", with: "\n")
                
                // Remove remaining HTML tags
                postContent = postContent.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
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
