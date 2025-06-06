package com.briefly.news.data

import com.google.gson.annotations.SerializedName

data class NewsResponse(
    @SerializedName("news")
    val news: List<NewsItem>,
    
    @SerializedName("next_cursor")
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