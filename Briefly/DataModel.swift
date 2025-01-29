//
//  DataModel.swift
//  News points
//
//  Created by Vaidik Dubey on 13/01/25.
//

import Foundation

//struct NewsItem: Codable, Identifiable {
//    var id = UUID()
//    let title: String
//    let description: String
//    let link: String
//    let pubDate: String
//    let source: String
//}
//
//class NewsViewModel: ObservableObject {
//    @Published var newsItems: [NewsItem] = []
//    
//    func fetchNews(genre: String) async {
//        guard let url = URL(string: "https://m4vnpasso7.execute-api.ap-south-1.amazonaws.com/getnews/\(genre)") else {
//            return
//        }
//        
//        do {
//            let (data, _) = try await URLSession.shared.data(from: url)
//            let response = try JSONDecoder().decode([String: [NewsItem]].self, from: data)
//            
//            DispatchQueue.main.async {
//                self.newsItems = response["news"] ?? []
//            }
//        } catch {
//            print("Error fetching news: \(error)")
//        }
//    }
//}

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
    
    func fetchNews(genre: String) async {
        guard let url = URL(string: "https://m4vnpasso7.execute-api.ap-south-1.amazonaws.com/getnews/\(genre)") else {
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            // Try to decode as error response first
            if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                DispatchQueue.main.async {
                    self.errorMessage = errorResponse.error
                    self.newsItems = []
                }
                return
            }
            
            // If not an error, decode as news response
            let response = try JSONDecoder().decode(NewsResponse.self, from: data)
            DispatchQueue.main.async {
                self.errorMessage = nil
                self.newsItems = response.news
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Failed to fetch news: \(error.localizedDescription)"
                self.newsItems = []
            }
        }
    }
}
