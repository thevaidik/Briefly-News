package com.briefly.news.data

data class NewsItem(
    val title: String,
    val description: String,
    val link: String,
    val pubDate: String,
    val source: String
)

data class NewsResponse(
    val genre: String,
    val news: List<NewsItem>
)

data class ErrorResponse(
    val error: String
)
