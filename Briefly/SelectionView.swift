//
//  ContentView.swift
//  News points
//
//  Created by Vaidik Dubey on 13/01/25.
//

import SwiftUI

struct SelectionView: View {
  private let genres = [
    "technology", "business", "sports", "entertainment", "science", "world", "health", "ai",
    "hollywood", "defence", "politics", "automobile", "space", "economy",
  ]
  private let columns = [GridItem(.adaptive(minimum: 100), spacing: 12)]

  @State private var selectedGenre = "technology"
  @State private var showingNews = false
  @State private var showingContact = false
  @State private var showingRSS = false
  @State private var isLoading = false
  @State private var isDarkMode = false
  @StateObject private var viewModel = NewsViewModel()

  var body: some View {
    NavigationStack {
      ZStack {
        // Manual theme controlled background
        LinearGradient(
          colors: [
            isDarkMode
              ? Color(red: 0.1, green: 0.1, blue: 0.15) : Color(red: 0.75, green: 0.85, blue: 0.92),
            isDarkMode
              ? Color(red: 0.15, green: 0.15, blue: 0.2)
              : Color(red: 0.92, green: 0.95, blue: 0.98),
          ],
          startPoint: .top,
          endPoint: .bottom
        )
        .ignoresSafeArea()

        VStack(spacing: 10) {
          // Header with theme toggle
          HStack {
            Text("News Feeds")
              .font(.system(size: 24, weight: .bold))
              .foregroundColor(isDarkMode ? .white : .black)

            Spacer()

            // Theme toggle button
            Button(action: {
              isDarkMode.toggle()
            }) {
              Image(systemName: isDarkMode ? "moon.fill" : "sun.max.fill")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(isDarkMode ? .blue : .orange)
                .frame(width: 40, height: 40)
                .background(isDarkMode ? Color(red: 0.2, green: 0.2, blue: 0.25) : .white)
                .cornerRadius(20)
                .overlay(
                  RoundedRectangle(cornerRadius: 20)
                    .stroke(isDarkMode ? .gray : .black, lineWidth: 1.5)
                )
                .shadow(color: .black.opacity(0.1), radius: 2, x: 2, y: 2)
            }
          }
          .padding(.horizontal, 20)
          .padding(.top, 20)

          // Main content
          VStack(spacing: 24) {

            // Genre grid
            ScrollView {
              LazyVGrid(columns: columns, spacing: 12) {
                ForEach(genres, id: \.self) { genre in
                  ModernGenreButton(
                    genre: genre,
                    isSelected: selectedGenre == genre,
                    isDarkMode: isDarkMode,
                    action: { selectedGenre = genre }
                  )
                }
              }
              .padding(.horizontal, 20)
            }

            Spacer()
          }

          // Bottom section with floating action button
          VStack(spacing: 16) {
            // Generate button (comic book style)
            Button {
              Task {
                isLoading = true
                await viewModel.fetchNews(genre: selectedGenre)
                isLoading = false
                showingNews = true
              }
            } label: {
              HStack(spacing: 8) {
                if isLoading {
                  ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(0.8)
                } else {
                  Image(systemName: "plus")
                    .font(.system(size: 18, weight: .black))
                }

                if !isLoading {
                  Text("Read \(selectedGenre.capitalized)")
                    .font(.system(size: 16, weight: .black))
                }
              }
              .foregroundColor(.white)
              .frame(height: 56)
              .frame(maxWidth: isLoading ? 56 : .infinity)
              .background(Color.blue)
              .cornerRadius(28)
              .overlay(
                RoundedRectangle(cornerRadius: 28)
                  .stroke(Color.black, lineWidth: 2)
              )
              .shadow(color: .black.opacity(0.2), radius: 2, x: 3, y: 3)
            }
            .disabled(isLoading)
            .padding(.horizontal, 20)
            .animation(.easeInOut(duration: 0.3), value: isLoading)

            // Bottom tab bar
            BottomTabBar(
              showingContact: $showingContact, showingRSS: $showingRSS, isDarkMode: isDarkMode)
          }
          .padding(.bottom, 10)
        }
      }
      .navigationDestination(isPresented: $showingNews) {
        NewsView(viewModel: viewModel, selectedGenre: selectedGenre, isDarkMode: isDarkMode)
      }
      .navigationDestination(isPresented: $showingContact) {
        ContactView(isDarkMode: isDarkMode)
      }
      .navigationDestination(isPresented: $showingRSS) {
        RSSInputView(isDarkMode: isDarkMode)
      }
    }
  }
}

// Modern components with reduced comic book effect

struct ModernGenreButton: View {
  let genre: String
  let isSelected: Bool
  let isDarkMode: Bool
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      VStack(spacing: 8) {
        // Icon for each genre
        Image(systemName: genreIcon(for: genre))
          .font(.system(size: 24, weight: .bold))
          .foregroundColor(isSelected ? .white : (isDarkMode ? .white : .black))

        Text(genre.capitalized)
          .font(.system(size: 12, weight: .black))
          .foregroundColor(isSelected ? .white : (isDarkMode ? .white : .black))
          .lineLimit(1)
          .minimumScaleFactor(0.8)
      }
      .frame(height: 80)
      .frame(maxWidth: .infinity)
      .background(
        RoundedRectangle(cornerRadius: 16)
          .fill(
            isSelected
              ? Color.blue : (isDarkMode ? Color(red: 0.2, green: 0.2, blue: 0.25) : .white)
          )
          .overlay(
            RoundedRectangle(cornerRadius: 16)
              .stroke(isDarkMode ? .gray : .black, lineWidth: 1.5)
          )
      )
    }
    .shadow(color: .black.opacity(0.1), radius: 2, x: 2, y: 2)
  }

  private func genreIcon(for genre: String) -> String {
    switch genre.lowercased() {
    case "technology": return "laptopcomputer"
    case "business": return "briefcase.fill"
    case "sports": return "sportscourt.fill"
    case "entertainment": return "tv.fill"
    case "science": return "flask.fill"
    case "world": return "globe"
    case "health": return "heart.fill"
    case "ai": return "brain.head.profile"
    case "hollywood": return "camera.fill"
    case "defence": return "shield.fill"
    case "politics": return "building.columns.fill"
    case "automobile": return "car.fill"
    case "space": return "globe.americas.fill"
    case "economy": return "chart.line.uptrend.xyaxis"
    default: return "newspaper.fill"
    }
  }
}

struct BottomTabBar: View {
  @Binding var showingContact: Bool
  @Binding var showingRSS: Bool
  let isDarkMode: Bool

  var body: some View {
    HStack(spacing: 0) {
      TabBarButton(icon: "house.fill", isSelected: true)
      TabBarButton(icon: "envelope.fill", isSelected: false) {
        showingContact = true
      }
      TabBarButton(icon: "dot.radiowaves.left.and.right", isSelected: false) {
        showingRSS = true
      }
    }
    .padding(.horizontal, 20)
    .padding(.vertical, 12)
    .background(isDarkMode ? Color(red: 0.2, green: 0.2, blue: 0.25) : .white)
    .cornerRadius(25)
    .overlay(
      RoundedRectangle(cornerRadius: 25)
        .stroke(isDarkMode ? .gray : .black, lineWidth: 2)
    )
    .shadow(color: .black.opacity(0.2), radius: 2, x: 2, y: 2)
    .padding(.horizontal, 20)
  }
}

struct TabBarButton: View {
  let icon: String
  let isSelected: Bool
  let action: (() -> Void)?

  init(icon: String, isSelected: Bool, action: (() -> Void)? = nil) {
    self.icon = icon
    self.isSelected = isSelected
    self.action = action
  }

  var body: some View {
    Button(action: { action?() }) {
      Image(systemName: icon)
        .font(.system(size: 20))
        .foregroundColor(isSelected ? .blue : .gray)
        .frame(maxWidth: .infinity)
        .frame(height: 44)
    }
  }
}

#Preview { SelectionView() }
