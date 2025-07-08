//
//  NewsView.swift
//  News points
//
//  Created by Vaidik Dubey on 13/01/25.
//
import SwiftUI

struct GlassButton: View {
    let title: String
    let isLoading: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.15)) // Glass effect
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
                
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.0)
                } else {
                    Text(title)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.9))
                }
            }
            .frame(height: 50)
            .padding(.horizontal, 16)
        }
        .disabled(isLoading)
    }
}

struct NewsView: View {
    @StateObject var viewModel: NewsViewModel
    let selectedGenre: String
    @Environment(\.dismiss) private var dismiss
    @State private var showLoadMore = false
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.black, .gray.opacity(0.8)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Custom Navigation Bar
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .padding(.leading)
                    
                    Spacer()
                    
                    VStack(spacing: 2) {
                        Text("\(selectedGenre) News")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Text("Updated Daily")
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    
                    Spacer()
                    
                    // Empty view for balance
                    Color.clear
                        .frame(width: 24)
                        .padding(.trailing)
                }
                .frame(height: 44)
                .background(Color.black.opacity(0.01))
                
                // Content
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.news) { item in
                            NewsItemView(item: item)
                        }
                        
                        // Replace existing load more section with new button
                        if viewModel.nextCursor != nil {
                            GlassButton(
                                title: "Tap to Load More",
                                isLoading: viewModel.isLoadingMore
                            ) {
                                Task {
                                    await viewModel.fetchMoreNews(genre: selectedGenre)
                                }
                            }
                            .padding(.vertical, 16)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .preferredColorScheme(.dark)
        .navigationBarHidden(true)
        .task {
            await viewModel.fetchNews(genre: selectedGenre)
        }
    }
}

    struct NewsItemView: View {
        let item: NewsItem
        
        var body: some View {
            Link(destination: URL(string: item.points.first?.url ?? "")!) {
                VStack(alignment: .leading, spacing: 12) {
                    Text(item.title)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .lineLimit(3)
                    
                    if let firstPoint = item.points.first {
                        Text(firstPoint.description)
                            .font(.system(size: 15))
                            .foregroundColor(.gray.opacity(0.9))
                            .lineLimit(4) // Show more lines
                            .fixedSize(horizontal: false, vertical: true)

                        HStack(spacing: 12) {
                            Label {
                                Text(firstPoint.source)
                                    .font(.system(size: 13, weight: .medium))
                            } icon: {
                                Image(systemName: "globe")
                            }
                            .foregroundColor(.blue)
                            .lineLimit(1)
                            
                            Spacer()
                            
                            Label {
                                Text(formatPublishedDate(firstPoint.publishedAt))
                                    .font(.system(size: 12))
                            } icon: {
                                Image(systemName: "clock")
                            }
                            .foregroundColor(.gray)
                        }

                        Divider().background(Color.white.opacity(0.1))

                        HStack {
                            Text("Read more")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.blue)
                            Spacer()
                            Image(systemName: "arrow.right.circle.fill")
                                .foregroundColor(.blue)
                        }
                    }
                }
                .padding(18)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.black.opacity(0.4))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.white.opacity(0.06), lineWidth: 1)
                        )
                )
            }
        }
    
    private func formatPublishedDate(_ dateString: String) -> String {
        // Example: "Tue, 18 Mar 2025 16:52:09 +00"
        let components = dateString.components(separatedBy: " ")
        
        guard components.count >= 5 else {
            return dateString
        }
        
        let day = components[0].replacingOccurrences(of: ",", with: "")
        let date = components[1]
        let month = components[2]
        
        // Get just HH:MM from the time part
        let timeParts = components[4].components(separatedBy: ":")
        guard timeParts.count >= 2 else {
            return dateString
        }
        
        let hour = timeParts[0]
        let minute = timeParts[1]
        
        return "\(day), \(date) \(month) \(hour):\(minute)"
    }
}

import SwiftUI

#Preview {
    NewsView(
        viewModel: MockNewsViewModel(),
        selectedGenre: "Technology"
    )
}

final class MockNewsViewModel: NewsViewModel {
    override init() {
        super.init()
        self.news = [
            NewsItem(
                category: "Technology",
                timestamp: Int(Date().timeIntervalSince1970),
                newsId: UUID().uuidString,
                title: "OpenAI releases GPT-5 with revolutionary reasoning abilities",
                points: [
                    NewsPoint(
                        text: "GPT-5 reasoning capabilities rival human experts.",
                        description: "GPT-5 is being used in high-level research, decision-making, and even legal reasoning.",
                        url: "https://openai.com/blog/gpt-5",
                        source: "OpenAI Blog",
                        publishedAt: "Sun, 06 Jul 2025 12:00:00 +00"
                    )
                ],
                fetchedAt: Int(Date().timeIntervalSince1970),
                ttl: 86400
            ),
            NewsItem(
                category: "Technology",
                timestamp: Int(Date().timeIntervalSince1970) - 86400,
                newsId: UUID().uuidString,
                title: "Apple introduces Vision Pro 2: Lighter, Faster, Smarter",
                points: [
                    NewsPoint(
                        text: "Vision Pro 2 is setting new standards in spatial computing.",
                        description: "Apple’s latest headset brings thinner design and better battery life to the mixed reality world.",
                        url: "https://apple.com/newsroom",
                        source: "Apple Newsroom",
                        publishedAt: "Sat, 05 Jul 2025 09:30:00 +00"
                    )
                ],
                fetchedAt: Int(Date().timeIntervalSince1970) - 3600,
                ttl: 86400
            )
        ]
        self.nextCursor = "next_page_cursor"
        self.isLoadingMore = false
    }

    override func fetchNews(genre: String) async {
        try? await Task.sleep(nanoseconds: 300_000_000)
    }

    override func fetchMoreNews(genre: String) async {
        try? await Task.sleep(nanoseconds: 300_000_000)
    }
}

