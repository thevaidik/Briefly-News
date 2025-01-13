//
//  DataModel.swift
//  News points
//
//  Created by Vaidik Dubey on 13/01/25.
//
import Foundation

struct NewsItem: Decodable {
    let content: String
}

class NewsViewModel: ObservableObject {
    @Published var newsItems: [NewsItem] = []
    
    func fetchNews(genre: String) async {
        // Replace with your actual API endpoint
        guard let url = URL(string: "YOUR_API_ENDPOINT/\(genre)") else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedResponse = try JSONDecoder().decode([NewsItem].self, from: data)
            DispatchQueue.main.async {
                self.newsItems = decodedResponse
            }
        } catch {
            print("Error fetching news: \(error)")
        }
    }
}
