import Foundation

class NewsViewModel: ObservableObject {
    @Published var news: [NewsItem] = []
    @Published var isLoadingMore = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var nextCursor: String?
    private let baseURL = "https://qo6syrle6dnzs627xkjcyl7ol40ombnx.lambda-url.ap-south-1.on.aws"
    
    func fetchNews(genre: String) async {
        // Reset state for new genre
        await MainActor.run {
            news = []
            nextCursor = nil
            errorMessage = nil
            isLoading = true
        }
        
        await fetchNewsPage(genre: genre)
        
        await MainActor.run {
            isLoading = false
        }
    }
    
    func fetchMoreNews(genre: String) async {
        guard !isLoadingMore, let cursor = nextCursor else { return }
        
        isLoadingMore = true
        await fetchNewsPage(genre: genre, cursor: cursor)
        isLoadingMore = false
    }
    
    private func fetchNewsPage(genre: String, cursor: String? = nil) async {
        var urlString = "\(baseURL)/news/\(genre)"
        if let cursor {
            urlString += "?cursor=\(cursor)"
        }
        
        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async {
                self.errorMessage = "Invalid URL"
            }
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            // First try to decode potential error response
            if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                DispatchQueue.main.async {
                    self.errorMessage = errorResponse.error
                }
                return
            }
            
            let response = try JSONDecoder().decode(NewsResponse.self, from: data)
            
            DispatchQueue.main.async {
                self.news.append(contentsOf: response.news)
                self.nextCursor = response.next_cursor
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Failed to load news: \(error.localizedDescription)"
            }
            print("Error fetching news: \(error)")
        }
    }
}
