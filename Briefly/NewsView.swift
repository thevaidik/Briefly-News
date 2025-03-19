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
            VStack(alignment: .leading, spacing: 6) {
                Text(item.title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                    .lineLimit(2)
                
                if let firstPoint = item.points.first {
                    Text(firstPoint.description)
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                        .lineLimit(2)
                    
                    HStack {
                        Text(firstPoint.source)
                            .font(.system(size: 12))
                            .foregroundColor(Color(red: 10/255, green: 132/255, blue: 1))
                            .lineLimit(1)
                        
                        Spacer()
                        
                        Text(formatPublishedDate(firstPoint.publishedAt))
                            .font(.system(size: 11))
                            .foregroundColor(.gray)
                    }
                    
                    HStack {
                        Text("Read more")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Color(red: 10/255, green: 132/255, blue: 1))
                        Spacer()
                    }
                }
            }
            .padding(12)
            .background(Color(red: 28/255, green: 28/255, blue: 30/255))
            .cornerRadius(8)
            .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
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
