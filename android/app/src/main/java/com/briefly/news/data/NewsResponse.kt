package com.briefly.news.data

data class NewsResponse(
    val news: List<NewsItem>,
    val nextCursor: String?
)

data class NewsItem(
    val id: String,
    val title: String,
    val points: List<NewsPoint>
)

data class NewsPoint(
    val description: String,
    val url: String,
    val source: String,
    val publishedAt: String
)

data class ErrorResponse(
    val error: String
) 