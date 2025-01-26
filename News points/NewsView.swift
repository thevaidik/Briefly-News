//
//  NewsDisplay.swift
//  News points
//
//  Created by Vaidik Dubey on 13/01/25.
//
import SwiftUI
//
//struct NewsView: View {
//    let newsItems: [NewsItem]
//    @Environment(\.dismiss) private var dismiss
//    
//    var body: some View {
//        VStack {
//            List(newsItems.prefix(10), id: \.content) { item in
//                Text("• \(item.content)")
//                    .padding(.vertical, 4)
//            }
//            
//            Button("Back") {
//                dismiss()
//            }
//            .buttonStyle(.bordered)
//            .padding()
//        }
//        .navigationBarBackButtonHidden(true)
//    }
//}

struct NewsView: View {
    @StateObject private var viewModel = NewsViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            if viewModel.newsItems.isEmpty {
                ProgressView("Loading news...")
                    .padding()
            } else {
                List(viewModel.newsItems) { item in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(item.title)
                            .font(.headline)

                        Text(item.description)
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        if let url = URL(string: item.sourceUrl) {
                            Link("Read more", destination: url)
                                .font(.footnote)
                                .foregroundColor(.blue)
                        }

                        Text("Published: \(item.datePub)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 4)
                }
            }

            Button("Back") {
                dismiss()
            }
            .buttonStyle(.bordered)
            .padding()
        }
        .navigationBarBackButtonHidden(true)
        .task {
            await viewModel.fetchNews(genre: "hollywood")
        }
    }
}
