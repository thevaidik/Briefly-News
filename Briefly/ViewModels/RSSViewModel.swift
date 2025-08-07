//
//  RSSViewModel.swift
//  Briefly
//
//  Created by Vaidik Dubey
//

import Foundation

class RSSViewModel: ObservableObject {
    @Published var feed: RSSFeed?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func fetchRSSFeed(from urlString: String) async {
        await MainActor.run {
            isLoading = true
            errorMessage = nil
            feed = nil
        }
        
        guard let url = URL(string: urlString) else {
            await MainActor.run {
                errorMessage = "Invalid RSS URL"
                isLoading = false
            }
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let parser = RSSParser()
            
            if let parsedFeed = parser.parse(data: data) {
                await MainActor.run {
                    self.feed = parsedFeed
                    self.isLoading = false
                }
            } else {
                await MainActor.run {
                    self.errorMessage = "Failed to parse RSS feed"
                    self.isLoading = false
                }
            }
        } catch {
            await MainActor.run {
                self.errorMessage = "Failed to fetch RSS feed: \(error.localizedDescription)"
                self.isLoading = false
            }
        }
    }
}