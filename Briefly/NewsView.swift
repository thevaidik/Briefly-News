//
//  NewsView.swift
//  News points
//
//  Created by Vaidik Dubey on 13/01/25.
//
import SwiftUI

struct NewsView: View {
    @ObservedObject var viewModel: NewsViewModel
    let selectedGenre: String
    @Environment(\.dismiss) private var dismiss
    
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
                    
                    Text("\(selectedGenre) News")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    // Empty view for balance
                    Color.clear
                        .frame(width: 24)
                        .padding(.trailing)
                }
                .frame(height: 44)
                .background(Color.black.opacity(0.01))
                
                // Content
                Group {
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(1.2)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if let error = viewModel.errorMessage {
                        VStack(spacing: 16) {
                            Text(error)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                            
                            Button("Retry") {
                                Task {
                                    await viewModel.fetchNews(genre: selectedGenre)
                                }
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(Color.blue)
                            .cornerRadius(8)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(viewModel.newsItems) { item in
                                    NewsItemCard(newsItem: item)
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                        }
                    }
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

struct NewsItemCard: View {
    let newsItem: NewsItem
    
    var body: some View {
        Link(destination: URL(string: newsItem.link)!) {
            VStack(alignment: .leading, spacing: 6) {
                Text(newsItem.title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                    .lineLimit(2)
                
                Text(newsItem.description)
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
                    .lineLimit(2)
                
                HStack {
                    Text(newsItem.source)
                        .font(.system(size: 12))
                        .foregroundColor(Color(red: 10/255, green: 132/255, blue: 1))
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Text(newsItem.pubDate)
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
            .padding(12)
            .background(Color(red: 28/255, green: 28/255, blue: 30/255))
            .cornerRadius(8)
            .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
        }
    }
}
