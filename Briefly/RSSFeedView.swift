//
//  RSSFeedView.swift
//  Briefly
//
//  Created by Vaidik Dubey
//

import SwiftUI

struct RSSFeedView: View {
    let feed: RSSFeed
    let isDarkMode: Bool
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            // Background
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
                // Header
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
                        Text(feed.title)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(isDarkMode ? .white : .black)
                            .lineLimit(1)
                        
                        Text("RSS Feed")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    // RSS icon
                    Image(systemName: "dot.radiowaves.left.and.right")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.orange)
                        .frame(width: 32, height: 32)
                        .background(isDarkMode ? Color(red: 0.2, green: 0.2, blue: 0.25) : .white)
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(isDarkMode ? .gray : .black, lineWidth: 1)
                        )
                        .shadow(color: .black.opacity(0.1), radius: 2, x: 1, y: 1)
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                // Content
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(feed.items) { item in
                            RSSItemView(item: item, isDarkMode: isDarkMode)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct RSSItemView: View {
    let item: RSSItem
    let isDarkMode: Bool
    
    var body: some View {
        Link(destination: URL(string: item.link) ?? URL(string: "https://example.com")!) {
            VStack(alignment: .leading, spacing: 12) {
                // Header with RSS badge
                HStack {
                    Text("RSS")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.orange)
                        .cornerRadius(6)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.black, lineWidth: 1)
                        )
                    
                    Spacer()
                    
                    Text(formatDate(item.pubDate))
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.gray)
                }
                
                // Title
                Text(item.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(isDarkMode ? .white : .black)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
                
                // Description
                if !item.description.isEmpty {
                    Text(cleanDescription(item.description))
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(isDarkMode ? .white.opacity(0.7) : .black.opacity(0.7))
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)
                }
                
                // Source and action
                HStack {
                    HStack(spacing: 4) {
                        Image(systemName: "dot.radiowaves.left.and.right")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.orange)
                        
                        Text(item.source)
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(isDarkMode ? .white : .black)
                            .lineLimit(1)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Text("Read")
                            .font(.system(size: 12, weight: .black))
                            .foregroundColor(.orange)
                        
                        Image(systemName: "arrow.up.right")
                            .font(.system(size: 10, weight: .black))
                            .foregroundColor(.orange)
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
    
    private func formatDate(_ dateString: String) -> String {
        // Handle various RSS date formats
        let formatter = DateFormatter()
        
        // Try common RSS date formats
        let formats = [
            "EEE, dd MMM yyyy HH:mm:ss Z",
            "yyyy-MM-dd'T'HH:mm:ssZ",
            "yyyy-MM-dd HH:mm:ss",
            "EEE, dd MMM yyyy HH:mm:ss"
        ]
        
        for format in formats {
            formatter.dateFormat = format
            if let date = formatter.date(from: dateString) {
                formatter.dateFormat = "MMM dd, HH:mm"
                return formatter.string(from: date)
            }
        }
        
        return dateString
    }
    
    private func cleanDescription(_ description: String) -> String {
        // Remove HTML tags and clean up description
        let cleanedDescription = description
            .replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
            .replacingOccurrences(of: "&nbsp;", with: " ")
            .replacingOccurrences(of: "&amp;", with: "&")
            .replacingOccurrences(of: "&lt;", with: "<")
            .replacingOccurrences(of: "&gt;", with: ">")
            .replacingOccurrences(of: "&quot;", with: "\"")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        return cleanedDescription
    }
}

#Preview {
    RSSFeedView(
        feed: RSSFeed(
            title: "Sample RSS Feed",
            description: "A sample RSS feed for preview",
            link: "https://example.com",
            items: [
                RSSItem(
                    title: "Sample RSS Article",
                    description: "This is a sample RSS article description that shows how the feed will look.",
                    link: "https://example.com/article1",
                    pubDate: "Mon, 06 Jan 2025 12:00:00 +0000",
                    source: "Sample RSS Feed"
                ),
                RSSItem(
                    title: "Another RSS Article",
                    description: "Another sample article to demonstrate the RSS feed layout and functionality.",
                    link: "https://example.com/article2",
                    pubDate: "Sun, 05 Jan 2025 10:30:00 +0000",
                    source: "Sample RSS Feed"
                )
            ]
        ),
        isDarkMode: false
    )
}