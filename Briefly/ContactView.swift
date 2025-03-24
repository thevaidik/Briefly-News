//
//  ContactView.swift
//  Briefly
//
//  Created by Vaidik Dubey
//

import SwiftUI

struct ContactView: View {
    private let email = "contact@briefly.news"
    private let linkedin = "linkedin.com/company/briefly-news"
    
    @Environment(\.openURL) private var openURL
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(colors: [.black, .gray.opacity(0.8)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Text("Contact Us")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(radius: 10)
                    .padding(.top, 50)
                
                Spacer()
                
                // Email section
                contactItem(
                    icon: "envelope.fill",
                    title: "Email",
                    value: email,
                    action: { openURL(URL(string: "mailto:\(email)")!) }
                )
                
                // LinkedIn section
                contactItem(
                    icon: "link",
                    title: "LinkedIn",
                    value: linkedin,
                    action: { openURL(URL(string: "https://\(linkedin)")!) }
                )
                
                Spacer()
                Spacer()
            }
            .padding(.horizontal, 20)
        }
        .navigationBarTitle("Contact Us", displayMode: .inline)
    }
    
    private func contactItem(icon: String, title: String, value: String, action: @escaping () -> Void) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 22))
                    .foregroundColor(.blue)
                
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
            }
            
            Button(action: action) {
                Text(value)
                    .font(.subheadline)
                    .foregroundColor(.blue)
                    .underline()
                    .padding(.leading, 30)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white.opacity(0.1))
        )
    }
}

#Preview { ContactView() }