//
//  RSSModels.swift
//  Briefly
//
//  Created by Vaidik Dubey
//

import Foundation

struct RSSFeed: Codable {
    let title: String
    let description: String
    let link: String
    let items: [RSSItem]
}

struct RSSItem: Codable, Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let link: String
    let pubDate: String
    let source: String
    
    private enum CodingKeys: String, CodingKey {
        case title, description, link, pubDate, source
    }
}

// Category RSS Feed Management
struct CategoryRSSFeed: Codable, Identifiable {
    let id = UUID()
    let name: String
    let url: String
    let category: String
    
    private enum CodingKeys: String, CodingKey {
        case name, url, category
    }
}

struct CategoryRSSConfig: Codable {
    var categories: [String: [CategoryRSSFeed]]
    
    static let defaultConfig = CategoryRSSConfig(categories: [
        "technology": [
            CategoryRSSFeed(name: "TechCrunch", url: "https://techcrunch.com/feed/", category: "technology"),
            CategoryRSSFeed(name: "Ars Technica", url: "https://feeds.arstechnica.com/arstechnica/index", category: "technology"),
            CategoryRSSFeed(name: "The Verge", url: "https://www.theverge.com/rss/index.xml", category: "technology")
        ],
        "business": [
            CategoryRSSFeed(name: "Reuters Business", url: "https://feeds.reuters.com/reuters/businessNews", category: "business"),
            CategoryRSSFeed(name: "Bloomberg", url: "https://feeds.bloomberg.com/markets/news.rss", category: "business"),
            CategoryRSSFeed(name: "Business Insider", url: "https://feeds.businessinsider.com/custom/all", category: "business")
        ],
        "sports": [
            CategoryRSSFeed(name: "ESPN", url: "https://www.espn.com/espn/rss/news", category: "sports"),
            CategoryRSSFeed(name: "BBC Sport", url: "http://feeds.bbci.co.uk/sport/rss.xml", category: "sports"),
            CategoryRSSFeed(name: "Sports Illustrated", url: "https://www.si.com/rss/si_topstories.rss", category: "sports")
        ],
        "entertainment": [
            CategoryRSSFeed(name: "Entertainment Weekly", url: "https://ew.com/feed/", category: "entertainment"),
            CategoryRSSFeed(name: "Variety", url: "https://variety.com/feed/", category: "entertainment"),
            CategoryRSSFeed(name: "The Hollywood Reporter", url: "https://www.hollywoodreporter.com/feed/", category: "entertainment")
        ],
        "science": [
            CategoryRSSFeed(name: "Science Daily", url: "https://www.sciencedaily.com/rss/all.xml", category: "science"),
            CategoryRSSFeed(name: "Nature", url: "https://www.nature.com/nature.rss", category: "science"),
            CategoryRSSFeed(name: "Scientific American", url: "https://rss.sciam.com/ScientificAmerican-Global", category: "science")
        ],
        "world": [
            CategoryRSSFeed(name: "BBC World", url: "http://feeds.bbci.co.uk/news/world/rss.xml", category: "world"),
            CategoryRSSFeed(name: "Reuters World", url: "https://feeds.reuters.com/Reuters/worldNews", category: "world"),
            CategoryRSSFeed(name: "AP World News", url: "https://feeds.apnews.com/rss/apf-worldnews", category: "world")
        ],
        "health": [
            CategoryRSSFeed(name: "WebMD", url: "https://rssfeeds.webmd.com/rss/rss.aspx?RSSSource=RSS_PUBLIC", category: "health"),
            CategoryRSSFeed(name: "Health News", url: "https://www.medicalnewstoday.com/rss", category: "health"),
            CategoryRSSFeed(name: "Harvard Health", url: "https://www.health.harvard.edu/rss", category: "health")
        ],
        "ai": [
            CategoryRSSFeed(name: "AI News", url: "https://artificialintelligence-news.com/feed/", category: "ai"),
            CategoryRSSFeed(name: "MIT AI", url: "https://news.mit.edu/rss/topic/artificial-intelligence2", category: "ai"),
            CategoryRSSFeed(name: "OpenAI Blog", url: "https://openai.com/blog/rss.xml", category: "ai")
        ],
        "hollywood": [
            CategoryRSSFeed(name: "Variety", url: "https://variety.com/feed/", category: "hollywood"),
            CategoryRSSFeed(name: "The Hollywood Reporter", url: "https://www.hollywoodreporter.com/feed/", category: "hollywood"),
            CategoryRSSFeed(name: "Deadline", url: "https://deadline.com/feed/", category: "hollywood")
        ],
        "defence": [
            CategoryRSSFeed(name: "Defense News", url: "https://www.defensenews.com/arc/outboundfeeds/rss/", category: "defence"),
            CategoryRSSFeed(name: "Military Times", url: "https://www.militarytimes.com/arc/outboundfeeds/rss/", category: "defence"),
            CategoryRSSFeed(name: "Jane's Defence", url: "https://www.janes.com/feeds/defence-news", category: "defence")
        ],
        "politics": [
            CategoryRSSFeed(name: "Politico", url: "https://www.politico.com/rss/politics08.xml", category: "politics"),
            CategoryRSSFeed(name: "The Hill", url: "https://thehill.com/news/feed/", category: "politics"),
            CategoryRSSFeed(name: "Reuters Politics", url: "https://feeds.reuters.com/reuters/politicsNews", category: "politics")
        ],
        "automobile": [
            CategoryRSSFeed(name: "Motor Trend", url: "https://www.motortrend.com/feed/", category: "automobile"),
            CategoryRSSFeed(name: "Car and Driver", url: "https://www.caranddriver.com/rss/all.xml/", category: "automobile"),
            CategoryRSSFeed(name: "Automotive News", url: "https://www.autonews.com/rss.xml", category: "automobile")
        ],
        "space": [
            CategoryRSSFeed(name: "Space.com", url: "https://www.space.com/feeds/all", category: "space"),
            CategoryRSSFeed(name: "SpaceNews", url: "https://spacenews.com/feed/", category: "space"),
            CategoryRSSFeed(name: "NASA News", url: "https://www.nasa.gov/rss/dyn/breaking_news.rss", category: "space")
        ],
        "economy": [
            CategoryRSSFeed(name: "Financial Times", url: "https://www.ft.com/rss/home", category: "economy"),
            CategoryRSSFeed(name: "Wall Street Journal", url: "https://feeds.a.dj.com/rss/RSSMarketsMain.xml", category: "economy"),
            CategoryRSSFeed(name: "Reuters Economy", url: "https://feeds.reuters.com/reuters/economicNews", category: "economy")
        ]
    ])
}

// RSS Parser
class RSSParser: NSObject, XMLParserDelegate {
    private var currentElement = ""
    private var currentTitle = ""
    private var currentDescription = ""
    private var currentLink = ""
    private var currentPubDate = ""
    private var feedTitle = ""
    private var feedDescription = ""
    private var feedLink = ""
    private var sourceName = ""
    
    private var items: [RSSItem] = []
    private var isInItem = false
    
    func parse(data: Data, sourceName: String = "") -> RSSFeed? {
        self.sourceName = sourceName
        let parser = XMLParser(data: data)
        parser.delegate = self
        
        if parser.parse() {
            return RSSFeed(
                title: feedTitle,
                description: feedDescription,
                link: feedLink,
                items: items
            )
        }
        return nil
    }
    
    // MARK: - XMLParserDelegate
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        
        if elementName == "item" {
            isInItem = true
            currentTitle = ""
            currentDescription = ""
            currentLink = ""
            currentPubDate = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let trimmedString = string.trimmingCharacters(in: .whitespacesAndNewlines)
        
        switch currentElement {
        case "title":
            if isInItem {
                currentTitle += trimmedString
            } else {
                feedTitle += trimmedString
            }
        case "description":
            if isInItem {
                currentDescription += trimmedString
            } else {
                feedDescription += trimmedString
            }
        case "link":
            if isInItem {
                currentLink += trimmedString
            } else {
                feedLink += trimmedString
            }
        case "pubDate":
            currentPubDate += trimmedString
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            let item = RSSItem(
                title: currentTitle.trimmingCharacters(in: .whitespacesAndNewlines),
                description: currentDescription.trimmingCharacters(in: .whitespacesAndNewlines),
                link: currentLink.trimmingCharacters(in: .whitespacesAndNewlines),
                pubDate: currentPubDate.trimmingCharacters(in: .whitespacesAndNewlines),
                source: sourceName.isEmpty ? feedTitle.trimmingCharacters(in: .whitespacesAndNewlines) : sourceName
            )
            items.append(item)
            isInItem = false
        }
        currentElement = ""
    }
}