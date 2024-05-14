//
//  ForumPage7.swift
//  FourDay
//
//  Created by Charles Thomas on 2024/5/8.
//
import SwiftUI

struct ForumPage2: View {
    @StateObject private var scraperViewModel = WebScraperViewModel()

    var body: some View {
        GenericPostListView(scraperViewModel: scraperViewModel)
            .onAppear {
                Task {
                    await scraperViewModel.loadPosts(for: 2)
                }
            }
    }
}
#Preview {
    ForumPage2()
}
