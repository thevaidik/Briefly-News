//
//  RSSCategoryManager.swift
//  Briefly
//
//  Created by Vaidik Dubey
//

import Foundation

class RSSCategoryManager: ObservableObject {
    @Published var config: CategoryRSSConfig
    private let configURL: URL
    
    init() {
        // Store config in Documents directory
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        configURL = documentsPath.appendingPathComponent("rss_categories.json")
        
        // Load existing config or use default
        if let data = try? Data(contentsOf: configURL),
           let loadedConfig = try? JSONDecoder().decode(CategoryRSSConfig.self, from: data) {
            config = loadedConfig
        } else {
            config = CategoryRSSConfig.defaultConfig
            saveConfig()
        }
    }
    
    func addFeed(_ feed: CategoryRSSFeed, to category: String) {
        if config.categories[category] != nil {
            config.categories[category]?.append(feed)
        } else {
            config.categories[category] = [feed]
        }
        saveConfig()
    }
    
    func removeFeed(withId id: UUID, from category: String) {
        config.categories[category]?.removeAll { $0.id == id }
        saveConfig()
    }
    
    func getFeeds(for category: String) -> [CategoryRSSFeed] {
        return config.categories[category] ?? []
    }
    
    func getAllCategories() -> [String] {
        return Array(config.categories.keys).sorted()
    }
    
    // Category Management Functions
    func addCategory(_ categoryName: String) {
        let lowercasedName = categoryName.lowercased()
        if config.categories[lowercasedName] == nil {
            config.categories[lowercasedName] = []
            saveConfig()
        }
    }
    
    func removeCategory(_ categoryName: String) {
        config.categories.removeValue(forKey: categoryName.lowercased())
        saveConfig()
    }
    
    func renameCategory(from oldName: String, to newName: String) {
        let oldKey = oldName.lowercased()
        let newKey = newName.lowercased()
        
        guard oldKey != newKey, let feeds = config.categories[oldKey] else { return }
        
        // Update category name in all feeds
        let updatedFeeds = feeds.map { feed in
            CategoryRSSFeed(name: feed.name, url: feed.url, category: newKey)
        }
        
        // Remove old category and add new one
        config.categories.removeValue(forKey: oldKey)
        config.categories[newKey] = updatedFeeds
        saveConfig()
    }
    
    func categoryExists(_ categoryName: String) -> Bool {
        return config.categories[categoryName.lowercased()] != nil
    }
    
    private func saveConfig() {
        do {
            let data = try JSONEncoder().encode(config)
            try data.write(to: configURL)
        } catch {
            print("Failed to save RSS config: \(error)")
        }
    }
}