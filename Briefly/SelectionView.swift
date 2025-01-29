//
//  ContentView.swift
//  News points
//
//  Created by Vaidik Dubey on 13/01/25.
//

import SwiftUI

struct SelectionView: View {
    let genres = ["technology", "business", "sports", "entertainment", "science", "world", "health" , "ai" , "hollywood" , "defence", "politics","automobile","space","economy"]
    @State private var selectedGenre = "bollywood"
    @StateObject private var viewModel = NewsViewModel()
    @State private var showingNews = false
    @State private var isLoading = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [Color.black, Color.gray.opacity(0.8)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    // Header
                    Text("Explore News")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(radius: 10)
                        .padding(.top, 50)
                    
                    Text("Select Genre")
                        .font(.title3)
                        .foregroundColor(.white.opacity(0.8))
                    
                    // Genre Picker
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(genres, id: \.self) { genre in
                                GenreButton(
                                    genre: genre,
                                    isSelected: selectedGenre == genre,
                                    action: { selectedGenre = genre }
                                )
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical)
                    
                    Spacer()
                    
                    // Generate Button
                    Button(action: {
                        Task {
                            isLoading = true
                            await viewModel.fetchNews(genre: selectedGenre)
                            isLoading = false
                            showingNews = true
                        }
                    }) {
                        HStack {
                            if isLoading {
                                ProgressView()
                                    .tint(.white)
                                    .padding(.trailing, 5)
                            }
                            
                            Text(isLoading ? "Generating..." : "Generate News")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
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
            .navigationDestination(isPresented: $showingNews) {
                NewsView(viewModel: viewModel, selectedGenre: selectedGenre)
            }
        }
    }
}

// Genre Button Component
struct GenreButton: View {
    let genre: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(genre)
                .font(.system(size: 16, weight: isSelected ? .bold : .medium))
                .foregroundColor(isSelected ? .white : .gray)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(isSelected ? Color.blue : Color.white.opacity(0.1))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(isSelected ? Color.blue.opacity(0.5) : Color.clear, lineWidth: 2)
                )
        }
        .shadow(radius: isSelected ? 5 : 0)
    }
}

// Preview Provider
#Preview {
    SelectionView()
}
