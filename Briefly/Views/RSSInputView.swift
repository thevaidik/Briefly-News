//
//  RSSInputView.swift
//  Briefly
//
//  Created by Vaidik Dubey
//

import SwiftUI

struct RSSInputView: View {
    let isDarkMode: Bool
    @Environment(\.dismiss) private var dismiss
    @StateObject private var rssViewModel = RSSViewModel()
    @State private var rssURL = ""
    @State private var showingRSSFeed = false
    
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
                            .font(.system(size: 18, weight: .black))
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
                    
                    Text("RSS Feed")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(isDarkMode ? .white : .black)
                    
                    Spacer()
                    
                    // Balance
                    Color.clear
                        .frame(width: 32, height: 32)
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                ScrollView {
                    VStack(spacing: 24) {
                        // RSS Icon
                        VStack(spacing: 16) {
                            Image(systemName: "dot.radiowaves.left.and.right")
                                .font(.system(size: 48, weight: .bold))
                                .foregroundColor(.orange)
                                .frame(width: 80, height: 80)
                                .background(isDarkMode ? Color(red: 0.2, green: 0.2, blue: 0.25) : .white)
                                .cornerRadius(40)
                                .overlay(
                                    Circle()
                                        .stroke(isDarkMode ? .gray : .black, lineWidth: 1.5)
                                )
                                .shadow(color: .black.opacity(0.1), radius: 2, x: 2, y: 2)
                            
                            VStack(spacing: 4) {
                                Text("Add RSS Feed")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(isDarkMode ? .white : .black)
                                
                                Text("Paste your RSS feed URL below")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.top, 40)
                        
                        // URL Input
                        VStack(alignment: .leading, spacing: 8) {
                            Text("RSS URL")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(isDarkMode ? .white : .black)
                            
                            TextField("https://example.com/rss.xml", text: $rssURL)
                                .font(.system(size: 16))
                                .foregroundColor(isDarkMode ? .white : .black)
                                .padding(16)
                                .background(isDarkMode ? Color(red: 0.2, green: 0.2, blue: 0.25) : .white)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(isDarkMode ? .gray : .black, lineWidth: 1.5)
                                )
                                .shadow(color: .black.opacity(0.1), radius: 2, x: 2, y: 2)
                        }
                        
                        // Fetch Button
                        Button {
                            Task {
                                await rssViewModel.fetchRSSFeed(from: rssURL)
                                if rssViewModel.feed != nil {
                                    showingRSSFeed = true
                                }
                            }
                        } label: {
                            HStack(spacing: 8) {
                                if rssViewModel.isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(0.8)
                                } else {
                                    Image(systemName: "arrow.down.circle.fill")
                                        .font(.system(size: 18, weight: .black))
                                }
                                
                                Text(rssViewModel.isLoading ? "Fetching..." : "Fetch RSS Feed")
                                    .font(.system(size: 16, weight: .black))
                            }
                            .foregroundColor(.white)
                            .frame(height: 56)
                            .frame(maxWidth: .infinity)
                            .background(Color.orange)
                            .cornerRadius(28)
                            .overlay(
                                RoundedRectangle(cornerRadius: 28)
                                    .stroke(Color.black, lineWidth: 2)
                            )
                            .shadow(color: .black.opacity(0.2), radius: 2, x: 3, y: 3)
                        }
                        .disabled(rssURL.isEmpty || rssViewModel.isLoading)
                        
                        // Error Message
                        if let errorMessage = rssViewModel.errorMessage {
                            Text(errorMessage)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                                .padding()
                                .background(isDarkMode ? Color(red: 0.2, green: 0.2, blue: 0.25) : .white)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(.red, lineWidth: 1.5)
                                )
                        }
                        
                        // Sample URLs
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Popular RSS Feeds")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(isDarkMode ? .white : .black)
                            
                            VStack(spacing: 8) {
                                sampleRSSButton("TechCrunch", "https://techcrunch.com/feed/")
                                sampleRSSButton("Foreign Affairs", "https://www.foreignaffairs.com/rss.xml")
                                sampleRSSButton("Hacker News", "https://hnrss.org/frontpage")
                            }
                        }
                        .padding(.top, 20)
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
        .navigationBarHidden(true)
        .navigationDestination(isPresented: $showingRSSFeed) {
            if let feed = rssViewModel.feed {
                RSSFeedView(feed: feed, isDarkMode: isDarkMode)
            }
        }
    }
    
    private func sampleRSSButton(_ title: String, _ url: String) -> some View {
        Button(action: { rssURL = url }) {
            HStack {
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(isDarkMode ? .white : .black)
                
                Spacer()
                
                Text("Tap to use")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.gray)
            }
            .padding(12)
            .background(isDarkMode ? Color(red: 0.2, green: 0.2, blue: 0.25) : .white)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isDarkMode ? .gray : .black, lineWidth: 1)
            )
        }
    }
}

#Preview {
    RSSInputView(isDarkMode: false)
}