//
//  NewsModels.swift
//  Briefly
//
//  Created by Vaidik Dubey on 13/01/25.
//

import Foundation

struct NewsResponse: Codable {
    let category: String
    let news: [NewsItem]
    let next_cursor: String?
    // Remove fetchedAt and ttl from here
}

struct NewsItem: Codable, Identifiable {
    let category: String
    let timestamp: Int
    let newsId: String
    let title: String
    let points: [NewsPoint]
    let fetchedAt: Int // Add these here
    let ttl: Int       // Add these here
    
    var id: String { newsId }
}

struct NewsPoint: Codable {
    let text: String
    let description: String
    let url: String
    let source: String
    let publishedAt: String
}

struct ErrorResponse: Codable {
    let error: String
} 
