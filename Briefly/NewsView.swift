//
//  NewsDisplay.swift
//  News points
//
//  Created by Vaidik Dubey on 13/01/25.
//
import SwiftUI

struct NewsView: View {
    @ObservedObject var viewModel: NewsViewModel
    let selectedGenre: String
    
    var body: some View {
        Group {
            if let error = viewModel.errorMessage {
                VStack {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                    Button("Retry") {
                        Task {
                            await viewModel.fetchNews(genre: selectedGenre)
                        }
                    }
                }
            } else if viewModel.newsItems.isEmpty {
                ProgressView()
            } else {
                List(viewModel.newsItems) { item in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(item.title)
                            .font(.headline)
                            .lineLimit(2)
                        
                        Text(item.description)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineLimit(3)
                        
                        HStack {
                            Text(item.source)
                                .font(.caption)
                                .foregroundColor(.blue)
                            
                            Spacer()
                            
                            Text(item.pubDate)
                                .font(.caption2)
                                .foregroundColor(.gray)
                        }
                        
                        Link("Read more", destination: URL(string: item.link) ?? URL(string: "https://www.example.com")!)
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .navigationTitle("\(selectedGenre) News")
        .task {
            await viewModel.fetchNews(genre: selectedGenre)
        }
        .refreshable {
            await viewModel.fetchNews(genre: selectedGenre)
        }
    }
}
