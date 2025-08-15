import Foundation

class NewsViewModel: ObservableObject {
    @Published var news: [NewsItem] = []
    @Published var isLoadingMore = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var nextCursor: String?
    
    private let rssManager = RSSCategoryManager()
    private var currentPage = 0
    private let itemsPerPage = 10
    
    func fetchNews(genre: String) async {
        // Reset state for new genre
        await MainActor.run {
            news = []
            nextCursor = nil
            errorMessage = nil
            isLoading = true
            currentPage = 0
        }
        
        await fetchNewsFromRSS(genre: genre)
        
        await MainActor.run {
            isLoading = false
        }
    }
    
    func fetchMoreNews(genre: String) async {
        guard !isLoadingMore, nextCursor != nil else { return }
        
        await MainActor.run {
            isLoadingMore = true
        }
        
        currentPage += 1
        await fetchNewsFromRSS(genre: genre, isLoadingMore: true)
        
        await MainActor.run {
            isLoadingMore = false
        }
    }
    
    private func fetchNewsFromRSS(genre: String, isLoadingMore: Bool = false) async {
        let feeds = rssManager.getFeeds(for: genre)
        
        guard !feeds.isEmpty else {
            await MainActor.run {
                errorMessage = "No RSS feeds configured for \(genre)"
            }
            return
        }
        
        var allItems: [RSSItem] = []
        
        // Fetch from all RSS feeds for this category
        await withTaskGroup(of: [RSSItem].self) { group in
            for feed in feeds {
                group.addTask {
                    await self.fetchRSSFeed(from: feed.url, source: feed.name)
                }
            }
            
            for await items in group {
                allItems.append(contentsOf: items)
            }
        }
        
        // Convert RSS items to NewsItems and sort by date
        let newsItems = allItems.compactMap { rssItem in
            convertRSSItemToNewsItem(rssItem, category: genre)
        }.sorted { item1, item2 in
            item1.timestamp > item2.timestamp
        }
        
        // Implement pagination
        let startIndex = currentPage * itemsPerPage
        let endIndex = min(startIndex + itemsPerPage, newsItems.count)
        
        guard startIndex < newsItems.count else {
            await MainActor.run {
                nextCursor = nil
            }
            return
        }
        
        let pageItems = Array(newsItems[startIndex..<endIndex])
        
        await MainActor.run {
            if isLoadingMore {
                self.news.append(contentsOf: pageItems)
            } else {
                self.news = pageItems
            }
            
            // Set next cursor if there are more items
            self.nextCursor = endIndex < newsItems.count ? "page_\(currentPage + 1)" : nil
        }
    }
    
    private func fetchRSSFeed(from urlString: String, source: String) async -> [RSSItem] {
        guard let url = URL(string: urlString) else { return [] }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let parser = RSSParser()
            
            if let feed = parser.parse(data: data, sourceName: source) {
                return feed.items
            }
        } catch {
            print("Failed to fetch RSS feed from \(urlString): \(error)")
        }
        
        return []
    }
    
    private func convertRSSItemToNewsItem(_ rssItem: RSSItem, category: String) -> NewsItem {
        let timestamp = parseRSSDate(rssItem.pubDate)
        
        return NewsItem(
            category: category,
            timestamp: timestamp,
            newsId: rssItem.id.uuidString,
            title: rssItem.title,
            points: [
                NewsPoint(
                    text: rssItem.title,
                    description: cleanHTMLDescription(rssItem.description),
                    url: rssItem.link,
                    source: rssItem.source,
                    publishedAt: rssItem.pubDate
                )
            ],
            fetchedAt: Int(Date().timeIntervalSince1970),
            ttl: 86400
        )
    }
    
    private func parseRSSDate(_ dateString: String) -> Int {
        let formatter = DateFormatter()
        let formats = [
            "EEE, dd MMM yyyy HH:mm:ss Z",
            "yyyy-MM-dd'T'HH:mm:ssZ",
            "yyyy-MM-dd HH:mm:ss",
            "EEE, dd MMM yyyy HH:mm:ss"
        ]
        
        for format in formats {
            formatter.dateFormat = format
            if let date = formatter.date(from: dateString) {
                return Int(date.timeIntervalSince1970)
            }
        }
        
        return Int(Date().timeIntervalSince1970)
    }
    
    private func cleanHTMLDescription(_ description: String) -> String {
        return description
            .replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
            .replacingOccurrences(of: "&nbsp;", with: " ")
            .replacingOccurrences(of: "&amp;", with: "&")
            .replacingOccurrences(of: "&lt;", with: "<")
            .replacingOccurrences(of: "&gt;", with: ">")
            .replacingOccurrences(of: "&quot;", with: "\"")
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
