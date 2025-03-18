//
//  DataModel.swift
//  News points
//
//  Created by Vaidik Dubey on 13/01/25.
//

import Foundation

struct NewsItem: Codable, Identifiable {
    var id = UUID()
    let title: String
    let description: String
    let link: String
    let pubDate: String
    let source: String
    
    // Remove id from coding keys since it's generated locally
    private enum CodingKeys: String, CodingKey {
        case title, description, link, pubDate, source
    }
}

struct NewsResponse: Codable {
    let genre: String
    let news: [NewsItem]
}

struct ErrorResponse: Codable {
    let error: String
}

class NewsViewModel: ObservableObject {
    @Published var newsItems: [NewsItem] = []
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    func fetchNews(genre: String) async {
        isLoading = true
        
        var components = URLComponents(string: "https://m4vnpasso7.execute-api.ap-south-1.amazonaws.com/getnews/")
        components?.path.append(genre.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? genre)
        
        guard let url = components?.url else {
            DispatchQueue.main.async {
                self.errorMessage = "Invalid URL"
                self.isLoading = false
            }
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                DispatchQueue.main.async {
                    self.errorMessage = errorResponse.error
                    self.newsItems = []
                    self.isLoading = false
                }
                return
            }
            
            let response = try JSONDecoder().decode(NewsResponse.self, from: data)
            DispatchQueue.main.async {
                self.errorMessage = nil
                self.newsItems = response.news
                self.isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Failed to fetch news: \(error.localizedDescription)"
                self.newsItems = []
                self.isLoading = false
            }
        }
    }
}
