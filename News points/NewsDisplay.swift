//
//  NewsDisplay.swift
//  News points
//
//  Created by Vaidik Dubey on 13/01/25.
//
import SwiftUI

struct NewsView: View {
    let newsItems: [NewsItem]
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            List(newsItems.prefix(10), id: \.content) { item in
                Text("• \(item.content)")
                    .padding(.vertical, 4)
            }
            
            Button("Back") {
                dismiss()
            }
            .buttonStyle(.bordered)
            .padding()
        }
        .navigationBarBackButtonHidden(true)
    }
}
