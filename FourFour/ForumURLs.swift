//
//  ForumURLs.swift
//  FourDay
//
//  Created by Charles Thomas on 2024/5/8.
//
import Foundation

struct ForumURLs {
    static let baseURL = "https://www.4d4y.com/forum/"
    
    static func loginPage() -> URL? {
        return URL(string: "\(baseURL)logging.php?action=login&sid=2eddoC")
    }
    static func forumDisplay(fid: Int) -> URL? {
        return URL(string: "\(baseURL)forumdisplay.php?fid=\(fid)")
    }
    static func viewThread(tid: Int, page: Int = 1) -> URL? {
        return URL(string: "\(baseURL)viewthread.php?tid=\(tid)&extra=page%3D\(page)")
    }
}
