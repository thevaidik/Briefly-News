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
    
    private var items: [RSSItem] = []
    private var isInItem = false
    
    func parse(data: Data) -> RSSFeed? {
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
                source: feedTitle.trimmingCharacters(in: .whitespacesAndNewlines)
            )
            items.append(item)
            isInItem = false
        }
        currentElement = ""
    }
}