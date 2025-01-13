//
//  ContentView.swift
//  News points
//
//  Created by Vaidik Dubey on 13/01/25.
//

import SwiftUI

struct SelectionView: View {
    let genres = ["Bollywood", "AI News", "Defense"]
    @State private var selectedGenre = "Bollywood"
    @StateObject private var viewModel = NewsViewModel()
    @State private var showingNews = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Picker("Select Genre", selection: $selectedGenre) {
                    ForEach(genres, id: \.self) { genre in
                        Text(genre).tag(genre)
                    }
                }
                .pickerStyle(.wheel)
                
                Button("Generate Now") {
                    Task {
                        await viewModel.fetchNews(genre: selectedGenre)
                        showingNews = true
                    }
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .navigationDestination(isPresented: $showingNews) {
                NewsView(newsItems: viewModel.newsItems)
            }
        }
    }
}
#Preview {
    SelectionView()
}
