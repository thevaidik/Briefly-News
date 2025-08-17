//
//  RSSCategoryManagementView.swift
//  Briefly
//
//  Created by Vaidik Dubey
//

import SwiftUI

struct RSSCategoryManagementView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var rssManager: RSSCategoryManager
    @State private var selectedCategory = "technology"
    @State private var showingAddFeed = false

    @State private var showingAddCategory = false
    @State private var showingEditCategory = false
    @State private var newFeedName = ""
    @State private var newFeedURL = ""
    @State private var newCategoryName = ""
    @State private var editCategoryName = ""
    
    private var availableCategories: [String] {
        rssManager.getAllCategories()
    }
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [
                    themeManager.isDarkMode ? Color(red: 0.1, green: 0.1, blue: 0.15) : Color(red: 0.75, green: 0.85, blue: 0.92),
                    themeManager.isDarkMode ? Color(red: 0.15, green: 0.15, blue: 0.2) : Color(red: 0.92, green: 0.95, blue: 0.98)
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
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(themeManager.isDarkMode ? .white : .black)
                            .frame(width: 32, height: 32)
                            .background(themeManager.isDarkMode ? Color(red: 0.2, green: 0.2, blue: 0.25) : .white)
                            .cornerRadius(16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(themeManager.isDarkMode ? .gray : .black, lineWidth: 1)
                            )
                            .shadow(color: .black.opacity(0.1), radius: 2, x: 1, y: 1)
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 2) {
                        Text("RSS Categories")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(themeManager.isDarkMode ? .white : .black)
                        
                        Text("Manage RSS Feeds")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    Button(action: { showingAddFeed = true }) {
                        Image(systemName: "plus")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(themeManager.isDarkMode ? .white : .black)
                            .frame(width: 32, height: 32)
                            .background(themeManager.isDarkMode ? Color(red: 0.2, green: 0.2, blue: 0.25) : .white)
                            .cornerRadius(16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(themeManager.isDarkMode ? .gray : .black, lineWidth: 1)
                            )
                            .shadow(color: .black.opacity(0.1), radius: 2, x: 1, y: 1)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                // Category Picker
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(availableCategories, id: \.self) { category in
                            Button(action: { selectedCategory = category }) {
                                Text(category.capitalized)
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(selectedCategory == category ? .white : (themeManager.isDarkMode ? .white : .black))
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(selectedCategory == category ? Color.blue : (themeManager.isDarkMode ? Color(red: 0.2, green: 0.2, blue: 0.25) : .white))
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(themeManager.isDarkMode ? .gray : .black, lineWidth: 1)
                                    )
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.top, 20)
                
                // RSS Feeds List
                ScrollView {
                    LazyVStack(spacing: 16) {
                        let feeds = rssManager.getFeeds(for: selectedCategory)
                        
                        if feeds.isEmpty {
                            VStack(spacing: 16) {
                                Image(systemName: "dot.radiowaves.left.and.right")
                                    .font(.system(size: 48, weight: .bold))
                                    .foregroundColor(.gray)
                                
                                Text("No RSS feeds configured")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.gray)
                                
                                Text("Tap the + button to add RSS feeds for \(selectedCategory)")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(.top, 60)
                        } else {
                            ForEach(feeds) { feed in
                                RSSFeedManagementRow(
                                    feed: feed,
                                    isDarkMode: themeManager.isDarkMode,
                                    onDelete: {
                                        rssManager.removeFeed(withId: feed.id, from: selectedCategory)
                                    }
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 100) // Add padding for bottom buttons
                }
                
                // Bottom Category Management Buttons
                VStack(spacing: 12) {
                    HStack(spacing: 12) {
                        Button(action: { showingAddCategory = true }) {
                            HStack(spacing: 8) {
                                Image(systemName: "folder.badge.plus")
                                    .font(.system(size: 16, weight: .black))
                                
                                Text("Add Category")
                                    .font(.system(size: 14, weight: .black))
                            }
                            .foregroundColor(.white)
                            .frame(height: 44)
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(22)
                            .overlay(
                                RoundedRectangle(cornerRadius: 22)
                                    .stroke(Color.black, lineWidth: 1.5)
                            )
                        }
                        
                        Button(action: { 
                            editCategoryName = selectedCategory
                            showingEditCategory = true 
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "pencil")
                                    .font(.system(size: 16, weight: .black))
                                
                                Text("Edit Category")
                                    .font(.system(size: 14, weight: .black))
                            }
                            .foregroundColor(.white)
                            .frame(height: 44)
                            .frame(maxWidth: .infinity)
                            .background(Color.orange)
                            .cornerRadius(22)
                            .overlay(
                                RoundedRectangle(cornerRadius: 22)
                                    .stroke(Color.black, lineWidth: 1.5)
                            )
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                .background(
                    LinearGradient(
                        colors: [
                            Color.clear,
                            themeManager.isDarkMode ? Color(red: 0.15, green: 0.15, blue: 0.2) : Color(red: 0.92, green: 0.95, blue: 0.98)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingAddFeed) {
            AddRSSFeedSheet(
                isDarkMode: themeManager.isDarkMode,
                category: selectedCategory,
                feedName: $newFeedName,
                feedURL: $newFeedURL,
                onAdd: { name, url in
                    let newFeed = CategoryRSSFeed(name: name, url: url, category: selectedCategory)
                    rssManager.addFeed(newFeed, to: selectedCategory)
                    newFeedName = ""
                    newFeedURL = ""
                    showingAddFeed = false
                }
            )
        }
        .sheet(isPresented: $showingAddCategory) {
            AddCategorySheet(
                isDarkMode: themeManager.isDarkMode,
                categoryName: $newCategoryName,
                onAdd: { name in
                    rssManager.addCategory(name)
                    selectedCategory = name.lowercased()
                    newCategoryName = ""
                    showingAddCategory = false
                }
            )
        }
        .sheet(isPresented: $showingEditCategory) {
            EditCategorySheet(
                isDarkMode: themeManager.isDarkMode,
                currentName: selectedCategory,
                newName: $editCategoryName,
                onRename: { newName in
                    rssManager.renameCategory(from: selectedCategory, to: newName)
                    selectedCategory = newName.lowercased()
                    editCategoryName = ""
                    showingEditCategory = false
                },
                onDelete: {
                    rssManager.removeCategory(selectedCategory)
                    selectedCategory = availableCategories.first ?? "technology"
                    showingEditCategory = false
                }
            )
        }

    }
}

struct RSSFeedManagementRow: View {
    let feed: CategoryRSSFeed
    let isDarkMode: Bool
    let onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            // RSS Icon
            Image(systemName: "dot.radiowaves.left.and.right")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.orange)
                .frame(width: 40, height: 40)
                .background(isDarkMode ? Color(red: 0.2, green: 0.2, blue: 0.25) : .white)
                .cornerRadius(20)
                .overlay(
                    Circle()
                        .stroke(isDarkMode ? .gray : .black, lineWidth: 1)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(feed.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(isDarkMode ? .white : .black)
                    .lineLimit(1)
                
                Text(feed.url)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
            
            Spacer()
            
            Button(action: onDelete) {
                Image(systemName: "trash")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.red)
                    .frame(width: 32, height: 32)
                    .background(isDarkMode ? Color(red: 0.2, green: 0.2, blue: 0.25) : .white)
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.red, lineWidth: 1)
                    )
            }
        }
        .padding(16)
        .background(isDarkMode ? Color(red: 0.2, green: 0.2, blue: 0.25) : .white)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isDarkMode ? .gray : .black, lineWidth: 1.5)
        )
        .shadow(color: .black.opacity(0.1), radius: 2, x: 2, y: 2)
    }
}

struct AddRSSFeedSheet: View {
    let isDarkMode: Bool
    let category: String
    @Binding var feedName: String
    @Binding var feedURL: String
    let onAdd: (String, String) -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    colors: [
                        isDarkMode ? Color(red: 0.1, green: 0.1, blue: 0.15) : Color(red: 0.75, green: 0.85, blue: 0.92),
                        isDarkMode ? Color(red: 0.15, green: 0.15, blue: 0.2) : Color(red: 0.92, green: 0.95, blue: 0.98)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    VStack(spacing: 16) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundColor(.blue)
                        
                        Text("Add RSS Feed to \(category.capitalized)")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(isDarkMode ? .white : .black)
                    }
                    .padding(.top, 20)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Feed Name")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(isDarkMode ? .white : .black)
                        
                        TextField("e.g., TechCrunch", text: $feedName)
                            .font(.system(size: 16))
                            .foregroundColor(isDarkMode ? .white : .black)
                            .padding(16)
                            .background(isDarkMode ? Color(red: 0.2, green: 0.2, blue: 0.25) : .white)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(isDarkMode ? .gray : .black, lineWidth: 1.5)
                            )
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("RSS URL")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(isDarkMode ? .white : .black)
                        
                        TextField("https://example.com/rss.xml", text: $feedURL)
                            .font(.system(size: 16))
                            .foregroundColor(isDarkMode ? .white : .black)
                            .padding(16)
                            .background(isDarkMode ? Color(red: 0.2, green: 0.2, blue: 0.25) : .white)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(isDarkMode ? .gray : .black, lineWidth: 1.5)
                            )
                    }
                    
                    Button {
                        onAdd(feedName, feedURL)
                    } label: {
                        Text("Add Feed")
                            .font(.system(size: 16, weight: .black))
                            .foregroundColor(.white)
                            .frame(height: 56)
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(28)
                            .overlay(
                                RoundedRectangle(cornerRadius: 28)
                                    .stroke(Color.black, lineWidth: 2)
                            )
                    }
                    .disabled(feedName.isEmpty || feedURL.isEmpty)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
            }
            .navigationTitle("Add RSS Feed")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(isDarkMode ? .white : .black)
                }
            }
        }
    }
}

struct AddCategorySheet: View {
    let isDarkMode: Bool
    @Binding var categoryName: String
    let onAdd: (String) -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    colors: [
                        isDarkMode ? Color(red: 0.1, green: 0.1, blue: 0.15) : Color(red: 0.75, green: 0.85, blue: 0.92),
                        isDarkMode ? Color(red: 0.15, green: 0.15, blue: 0.2) : Color(red: 0.92, green: 0.95, blue: 0.98)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    VStack(spacing: 16) {
                        Image(systemName: "folder.badge.plus")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundColor(.blue)
                        
                        Text("Add New Category")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(isDarkMode ? .white : .black)
                    }
                    .padding(.top, 20)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Category Name")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(isDarkMode ? .white : .black)
                        
                        TextField("e.g., Gaming", text: $categoryName)
                            .font(.system(size: 16))
                            .foregroundColor(isDarkMode ? .white : .black)
                            .padding(16)
                            .background(isDarkMode ? Color(red: 0.2, green: 0.2, blue: 0.25) : .white)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(isDarkMode ? .gray : .black, lineWidth: 1.5)
                            )
                    }
                    
                    Button {
                        onAdd(categoryName)
                    } label: {
                        Text("Add Category")
                            .font(.system(size: 16, weight: .black))
                            .foregroundColor(.white)
                            .frame(height: 56)
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(28)
                            .overlay(
                                RoundedRectangle(cornerRadius: 28)
                                    .stroke(Color.black, lineWidth: 2)
                            )
                    }
                    .disabled(categoryName.isEmpty)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
            }
            .navigationTitle("Add Category")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(isDarkMode ? .white : .black)
                }
            }
        }
    }
}

struct EditCategorySheet: View {
    let isDarkMode: Bool
    let currentName: String
    @Binding var newName: String
    let onRename: (String) -> Void
    let onDelete: () -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var showingDeleteConfirmation = false
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    colors: [
                        isDarkMode ? Color(red: 0.1, green: 0.1, blue: 0.15) : Color(red: 0.75, green: 0.85, blue: 0.92),
                        isDarkMode ? Color(red: 0.15, green: 0.15, blue: 0.2) : Color(red: 0.92, green: 0.95, blue: 0.98)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    VStack(spacing: 16) {
                        Image(systemName: "folder.badge.gearshape")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundColor(.orange)
                        
                        Text("Edit \(currentName.capitalized)")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(isDarkMode ? .white : .black)
                    }
                    .padding(.top, 20)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Category Name")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(isDarkMode ? .white : .black)
                        
                        TextField("Category name", text: $newName)
                            .font(.system(size: 16))
                            .foregroundColor(isDarkMode ? .white : .black)
                            .padding(16)
                            .background(isDarkMode ? Color(red: 0.2, green: 0.2, blue: 0.25) : .white)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(isDarkMode ? .gray : .black, lineWidth: 1.5)
                            )
                    }
                    
                    VStack(spacing: 12) {
                        Button {
                            onRename(newName)
                        } label: {
                            Text("Rename Category")
                                .font(.system(size: 16, weight: .black))
                                .foregroundColor(.white)
                                .frame(height: 56)
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .cornerRadius(28)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 28)
                                        .stroke(Color.black, lineWidth: 2)
                                )
                        }
                        .disabled(newName.isEmpty || newName.lowercased() == currentName.lowercased())
                        
                        Button {
                            showingDeleteConfirmation = true
                        } label: {
                            Text("Delete Category")
                                .font(.system(size: 16, weight: .black))
                                .foregroundColor(.white)
                                .frame(height: 56)
                                .frame(maxWidth: .infinity)
                                .background(Color.red)
                                .cornerRadius(28)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 28)
                                        .stroke(Color.black, lineWidth: 2)
                                )
                        }
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
            }
            .navigationTitle("Edit Category")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(isDarkMode ? .white : .black)
                }
            }
            .alert("Delete Category", isPresented: $showingDeleteConfirmation) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    onDelete()
                }
            } message: {
                Text("Are you sure you want to delete the \(currentName.capitalized) category? This will remove all RSS feeds in this category.")
            }
        }
    }
}

#Preview {
    RSSCategoryManagementView()
        .environmentObject(ThemeManager())
        .environmentObject(RSSCategoryManager())
}