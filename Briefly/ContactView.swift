//
//  ContactView.swift
//  Briefly
//
//  Created by Vaidik Dubey
//

import SwiftUI

struct ContactView: View {
  private let email = "vaidik50000@gmail.com"
  private let linkedin = "linkedin.com/company/briefly-news-app/?viewAsMember=true"
  let isDarkMode: Bool

  @Environment(\.openURL) private var openURL
  @Environment(\.dismiss) private var dismiss

  var body: some View {
    ZStack {
      // Softer background that's easier on the eyes
      LinearGradient(
        colors: [
          isDarkMode ? Color(red: 0.1, green: 0.1, blue: 0.15) : Color(red: 0.75, green: 0.85, blue: 0.92),
          isDarkMode ? Color(red: 0.15, green: 0.15, blue: 0.2) : Color(red: 0.92, green: 0.95, blue: 0.98),
        ],
        startPoint: .top,
        endPoint: .bottom
      )
      .ignoresSafeArea()

      VStack(spacing: 0) {
        // Header
        HStack {
          Button(action: { dismiss() }) {
            Image(systemName: "chevron.left")
              .font(.system(size: 18, weight: .black))
              .foregroundColor(isDarkMode ? .white : .black)
              .frame(width: 32, height: 32)
              .background(isDarkMode ? Color(red: 0.2, green: 0.2, blue: 0.25) : .white)
              .cornerRadius(16)
              .overlay(
                RoundedRectangle(cornerRadius: 16)
                  .stroke(isDarkMode ? .gray : .black, lineWidth: 1)
              )
              .shadow(color: .black.opacity(0.1), radius: 2, x: 1, y: 1)
          }

          Spacer()

          Text("Contact Us")
            .font(.system(size: 18, weight: .bold))
            .foregroundColor(isDarkMode ? .white : .black)

          Spacer()

          // Balance
          Color.clear
            .frame(width: 32, height: 32)
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)

        ScrollView {
          VStack(spacing: 24) {
            // Profile section
            VStack(spacing: 16) {
              Circle()
                .fill(Color.blue)
                .frame(width: 80, height: 80)
                .overlay(
                  Image(systemName: "person.fill")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                )
                .overlay(
                  Circle()
                    .stroke(isDarkMode ? .gray : .black, lineWidth: 1.5)
                )
                .shadow(color: .black.opacity(0.1), radius: 2, x: 2, y: 2)

              VStack(spacing: 4) {
                Text("Briefly Team")
                  .font(.system(size: 20, weight: .bold))
                  .foregroundColor(Color.adaptive(light: .black, dark: .white))

                Text("Get in touch with us")
                  .font(.system(size: 14, weight: .medium))
                  .foregroundColor(Color.adaptive(light: .gray, dark: .gray))
              }
            }
            .padding(.top, 40)

            // Contact options
            VStack(spacing: 16) {
              modernContactItem(
                icon: "envelope.fill",
                title: "Email",
                subtitle: "Send us an email",
                value: email,
                action: { openURL(URL(string: "mailto:\(email)")!) }
              )

              modernContactItem(
                icon: "link",
                title: "LinkedIn",
                subtitle: "Connect with us",
                value: "Company Profile",
                action: { openURL(URL(string: "https://\(linkedin)")!) }
              )
            }

            // Additional info
            VStack(spacing: 12) {
              Text("We'd love to hear from you!")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(Color.adaptive(light: .black, dark: .white))
                .multilineTextAlignment(.center)

              Text(
                "Whether you have feedback, suggestions, or just want to say hello, don't hesitate to reach out."
              )
              .font(.system(size: 14))
              .foregroundColor(Color.adaptive(light: .gray, dark: .gray))
              .multilineTextAlignment(.center)
              .lineLimit(nil)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
          }
          .padding(.horizontal, 20)
        }
      }
    }
    .navigationBarHidden(true)
  }

  private func modernContactItem(
    icon: String, title: String, subtitle: String, value: String, action: @escaping () -> Void
  ) -> some View {
    Button(action: action) {
      HStack(spacing: 16) {
        // Icon
        Image(systemName: icon)
          .font(.system(size: 20, weight: .semibold))
          .foregroundColor(.white)
          .frame(width: 40, height: 40)
          .background(Color.blue)
          .cornerRadius(20)
          .overlay(
            RoundedRectangle(cornerRadius: 20)
              .stroke(Color.adaptive(light: .black, dark: Color.white.opacity(0.2)), lineWidth: 1)
          )

        // Content
        VStack(alignment: .leading, spacing: 2) {
          Text(title)
            .font(.system(size: 16, weight: .semibold))
            .foregroundColor(Color.adaptive(light: .black, dark: .white))

          Text(subtitle)
            .font(.system(size: 13))
            .foregroundColor(Color.adaptive(light: .gray, dark: .gray))
        }

        Spacer()

        // Arrow
        Image(systemName: "chevron.right")
          .font(.system(size: 14))
          .foregroundColor(Color.adaptive(light: .gray, dark: .gray))
      }
      .padding(16)
      .background(Color.adaptive(light: .white, dark: Color.white.opacity(0.1)))
      .cornerRadius(16)
      .overlay(
        RoundedRectangle(cornerRadius: 16)
          .stroke(Color.adaptive(light: .black, dark: Color.white.opacity(0.1)), lineWidth: 1.5)
      )
      .shadow(color: .black.opacity(0.1), radius: 2, x: 2, y: 2)
    }
  }
}

#Preview { ContactView(isDarkMode: false) }
