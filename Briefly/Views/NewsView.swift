//
//  NewsView.swift
//  News points
//
//  Created by Vaidik Dubey on 13/01/25.
//
import SwiftUI

struct ModernLoadMoreButton: View {
    let title: String
    let isLoading: Bool
    let isDarkMode: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                        .scaleEffect(0.8)
                } else {
                    Image(systemName: "arrow.down.circle.fill")
                        .font(.system(size: 16, weight: .black))
                        .foregroundColor(.blue)
                }
                
                Text(title)
                    .font(.system(size: 14, weight: .black))
                    .foregroundColor(.blue)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .background(isDarkMode ? Color(red: 0.2, green: 0.2, blue: 0.25) : .white)
            .cornerRadius(22)
            .overlay(
                RoundedRectangle(cornerRadius: 22)
                    .stroke(isDarkMode ? .gray : .black, lineWidth: 1.5)
            )
            .shadow(color: .black.opacity(0.1), radius: 2, x: 2, y: 2)
        }
        .disabled(isLoading)
    }
}

struct NewsView: View {
    @StateObject var viewModel: NewsViewModel
    let selectedGenre: String
    let isDarkMode: Bool
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTab = "Today"
    
    var body: some View {
        ZStack {
            // Manual theme controlled background
            LinearGradient(
                colors: [
                    isDarkMode ? Color(red: 0.1, green: 0.1, blue: 0.15) : Color(red: 0.75, green: 0.85, blue: 0.92),
                    isDarkMode ? Color(red: 0.15, green: 0.15, blue: 0.2) : Color(red: 0.92, green: 0.95, blue: 0.98)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Custom Navigation Bar
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(isDarkMode ? .white : .black)
                            .frame(width: 32, height: 32)
                            .background(isDarkMode ? Color(red: 0.2, green: 0.2, blue: 0.25) : .white)
                            .cornerRadius(16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(isDarkMode ? .gray : .black, lineWidth: 1)
                            )
                            .shadow(color: .black.opacity(0.1), radius: 2, x: 1, y: 1)
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 2) {
                        Text("\(selectedGenre.capitalized)")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(isDarkMode ? .white : .black)
                        
                        Text("Latest Updates")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    // Bookmark button
                    Button(action: {}) {
                        Image(systemName: "bookmark")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(isDarkMode ? .white : .black)
                            .frame(width: 32, height: 32)
                            .background(isDarkMode ? Color(red: 0.2, green: 0.2, blue: 0.25) : .white)
                            .cornerRadius(16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(isDarkMode ? .gray : .black, lineWidth: 1)
                            )
                            .shadow(color: .black.opacity(0.1), radius: 2, x: 1, y: 1)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                

                
                // Content
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.news) { item in
                            ModernNewsItemView(item: item, isDarkMode: isDarkMode)
                        }
                        
                        // Load more button
                        if viewModel.nextCursor != nil {
                            ModernLoadMoreButton(
                                title: "Load More Stories",
                                isLoading: viewModel.isLoadingMore,
                                isDarkMode: isDarkMode
                            ) {
                                Task {
                                    await viewModel.fetchMoreNews(genre: selectedGenre)
                                }
                            }
                            .padding(.vertical, 16)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
        }
        .navigationBarHidden(true)
        .task {
            await viewModel.fetchNews(genre: selectedGenre)
        }
    }
}



struct ModernNewsItemView: View {
    let item: NewsItem
    let isDarkMode: Bool
    
    var body: some View {
        Link(destination: URL(string: item.points.first?.url ?? "")!) {
            VStack(alignment: .leading, spacing: 12) {
                // Header with category badge
                HStack {
                    Text(item.category.capitalized)
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.blue)
                        .cornerRadius(6)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.black, lineWidth: 1)
                        )
                    
                    Spacer()
                    
                    if let firstPoint = item.points.first {
                        Text(formatPublishedDate(firstPoint.publishedAt))
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.gray)
                    }
                }
                
                Text(item.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(isDarkMode ? .white : .black)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
                
                if let firstPoint = item.points.first {
                    Text(firstPoint.description)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(isDarkMode ? .white.opacity(0.7) : .black.opacity(0.7))
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)
                    
                    // Source and action
                    HStack {
                        HStack(spacing: 4) {
                            Image(systemName: "globe")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(isDarkMode ? .white : .black)
                            
                            Text(firstPoint.source)
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(isDarkMode ? .white : .black)
                                .lineLimit(1)
                        }
                        
                        Spacer()
                        
                        HStack(spacing: 4) {
                            Text("Read")
                                .font(.system(size: 12, weight: .black))
                                .foregroundColor(.blue)
                            
                            Image(systemName: "arrow.up.right")
                                .font(.system(size: 10, weight: .black))
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            .padding(16)
            .background(isDarkMode ? Color(red: 0.2, green: 0.2, blue: 0.25) : .white)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isDarkMode ? .gray : .black, lineWidth: 1.5)
            )
            .shadow(color: .black.opacity(0.1), radius: 2, x: 2, y: 2)
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
        selectedGenre: "Technology",
        isDarkMode: false
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

