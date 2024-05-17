
import SwiftUI

struct ForumListView: View {
    @StateObject var scraperViewModel = ThreadScraperViewModel()
    @State private var scrollPosition: UUID? // 用于存储滚动位置
    
    var body: some View {
        NavigationView {
            ScrollViewReader { proxy in
                ScrollView { // 使用ScrollView替换List
                    VStack {
                        ForEach(scraperViewModel.posts, id: \.id) { post in
                            ZStack {
                                NavigationLink(
                                    destination: PostAndReplyView(postURL: post.url)
                                        .onAppear {
                                            // 在阅读页面出现时，保存当前滚动位置
                                            scrollPosition = post.id
                                        }
                                ) {
                                    VStack(alignment: .leading, spacing: 2) {
                                        HStack {
                                            Text(post.author)
                                                .font(Font.system(size: 14))
                                                .foregroundColor(.gray)
                                                .underline(false, color: .clear) // 去掉下划线
                                            Text(post.postDate)
                                                .font(.system(size: 14))
                                                .foregroundColor(.gray)
                                                .underline(false, color: .clear) // 去掉下划线
                                            Spacer()
                                            Text(post.lastReplyUser)
                                                .font(Font.system(size: 14))
                                                .foregroundColor(.gray)
                                                .underline(false, color: .clear) // 去掉下划线
                                            Text(post.lastReplyTime)
                                                .font(.system(size: 14))
                                                .foregroundColor(.gray)
                                                .underline(false, color: .clear)
                                            HStack(spacing: 0) {
                                                Text("\(post.replyCount)")
                                                    .font(.system(size: 13))
                                                    .foregroundColor(post.replyCount > 10 ? .orange : .gray)
                                                    .frame(alignment: .trailing)
                                                //                                                    .underline(false, color: .clear)
                                                    .overlay(
                                                        post.replyCount > 10 ?
                                                        Text("")
                                                            .underline(false, color: .clear) :
                                                            nil
                                                    )
                                                
                                                Text("/\(post.viewCount)")
                                                    .font(.system(size: 14))
                                                    .foregroundColor(.gray)
                                                    .underline(false, color: .clear) // 去掉下划线
                                            }
                                            .lineLimit(1)
                                        }
                                        .lineLimit(1)
                                        if let titleNew = post.titlenew, !titleNew.isEmpty {
                                            Text(titleNew + " ")
                                                .font(.system(size: 21))
                                                .underline(false, color: .clear) // 去掉下划线
                                            + post.imageAttachments.reduce(Text("")) { (result, attachment) -> Text in
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
                                                .font(.system(size: 21))
                                                .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.1))
                                                .underline(false, color: .clear) // 去掉下划线
                                            + post.imageAttachments.reduce(Text("")) { (result, attachment) -> Text in
                                                if attachment == "https://c.4d4y.com/forum/images/attachicons/common.gif" {
                                                    return result + Text(Image(systemName: "paperclip"))
                                                } else if attachment == "https://c.4d4y.com/forum/images/attachicons/image_s.gif" {
                                                    return result + Text(Image(systemName: "photo"))
                                                } else {
                                                    return result + Text(attachment)
                                                }
                                            }
                                        }
                                        Divider()
                                    }
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            .padding([.leading, .trailing]) // 适当调整内边距
                            .id(post.id) // 设置每个帖子的 ID
                        }
                    }
                }
                .onAppear {
                    Task {
                        await scraperViewModel.loadPosts(for: 2)
                        // 加载完成后，滚动到之前保存的位置
                        if let scrollPosition = scrollPosition {
                            DispatchQueue.main.async {
                                proxy.scrollTo(scrollPosition)
                            }
                        }
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
#Preview {
    ForumListView()
}
