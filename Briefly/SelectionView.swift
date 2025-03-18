//
//  ContentView.swift
//  News points
//
//  Created by Vaidik Dubey on 13/01/25.
//

import SwiftUI

struct SelectionView: View {
    private let genres = ["technology", "business", "sports", "entertainment", "science", "world", "health", "ai", "hollywood", "defence", "politics", "automobile", "space", "economy"]
    private let columns = [GridItem(.adaptive(minimum: 120), spacing: 8)]
    
    @State private var selectedGenre = "bollywood"
    @State private var showingNews = false
    @State private var isLoading = false
    @StateObject private var viewModel = NewsViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [.black, .gray.opacity(0.8)], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Text("Explore News")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(radius: 10)
                        .padding(.top, 50)
                    
                    Text("Select Genre")
                        .font(.title3)
                        .foregroundColor(.white.opacity(0.8))
                    
                    LazyVGrid(columns: columns, spacing: 8) {
                        ForEach(genres, id: \.self) { genre in
                            GenreButton(
                                genre: genre,
                                isSelected: selectedGenre == genre,
                                action: { selectedGenre = genre }
                            )
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    generateButton
                }
            }
            .navigationDestination(isPresented: $showingNews) {
                NewsView(viewModel: viewModel, selectedGenre: selectedGenre)
            }
        }
    }
    
    private var generateButton: some View {
        Button {
            Task {
                isLoading = true
                await viewModel.fetchNews(genre: selectedGenre)
                isLoading = false
                showingNews = true
            }
        } label: {
            HStack {
                if isLoading {
                    ProgressView().tint(.white).padding(.trailing, 5)
                }
                Text(isLoading ? "Generating..." : "Generate News")
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 55)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.blue)
                    .shadow(radius: 10)
            )
        }
        .disabled(isLoading)
        .padding(.horizontal, 30)
        .padding(.bottom, 50)
    }
}

struct GenreButton: View {
    let genre: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(genre)
                .font(.system(size: 14, weight: isSelected ? .bold : .medium))
                .foregroundColor(isSelected ? .white : .gray)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .frame(minWidth: 80)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(isSelected ? Color.blue : Color.white.opacity(0.1))
                        .stroke(isSelected ? Color.blue.opacity(0.5) : Color.clear, lineWidth: 2)
                )
        }
        .frame(height: 36)
        .shadow(radius: isSelected ? 5 : 0)
    }
}

#Preview { SelectionView() }
