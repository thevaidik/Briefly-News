package com.briefly.news.viewmodel

import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.briefly.news.data.NewsItem
import com.briefly.news.data.NewsResponse
import kotlinx.coroutines.launch
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import retrofit2.http.GET
import retrofit2.http.Path
import retrofit2.http.Query

interface NewsService {
    @GET("news/{genre}")
    suspend fun getNews(@Path("genre") genre: String): NewsResponse
    
    @GET("news/{genre}")
    suspend fun getNewsWithCursor(@Path("genre") genre: String, @Query("cursor") cursor: String): NewsResponse
}

class NewsViewModel : ViewModel() {
    var newsItems by mutableStateOf<List<NewsItem>>(emptyList())
        private set
    
    var errorMessage by mutableStateOf<String?>(null)
        private set
        
    var isLoading by mutableStateOf(false)
        private set
        
    var isLoadingMore by mutableStateOf(false)
        private set
    
    var nextCursor by mutableStateOf<String?>(null)
        private set

    private val retrofit = Retrofit.Builder()
        .baseUrl("https://qo6syrle6dnzs627xkjcyl7ol40ombnx.lambda-url.ap-south-1.on.aws/")
        .addConverterFactory(GsonConverterFactory.create())
        .build()

    private val newsService = retrofit.create(NewsService::class.java)

    fun fetchNews(genre: String, onComplete: ((Boolean) -> Unit)? = null) {
        viewModelScope.launch {
            isLoading = true
            errorMessage = null
            newsItems = emptyList()
            nextCursor = null
            
            try {
                println("DEBUG: Fetching initial news for genre: $genre")
                val response = newsService.getNews(genre)
                println("DEBUG: Received response with ${response.news.size} items, nextCursor: ${response.nextCursor}")
                newsItems = response.news
                nextCursor = response.nextCursor
                println("DEBUG: Updated state - newsItems: ${newsItems.size}, nextCursor: $nextCursor")
                isLoading = false
                onComplete?.invoke(true)
            } catch (e: Exception) {
                errorMessage = "Failed to fetch news: ${e.localizedMessage}"
                newsItems = emptyList()
                isLoading = false
                onComplete?.invoke(false)
            }
        }
    }
    
    fun fetchMoreNews(genre: String, onComplete: ((Boolean) -> Unit)? = null) {
        if (isLoadingMore || nextCursor == null) {
            println("DEBUG: fetchMoreNews called but isLoadingMore=$isLoadingMore or nextCursor is null")
            onComplete?.invoke(false)
            return
        }
        
        viewModelScope.launch {
            isLoadingMore = true
            
            try {
                val cursor = nextCursor!!
                println("DEBUG: Fetching more news with cursor: $cursor")
                println("DEBUG: Fetching more news with genre: $genre, cursor: $cursor")
                val response = newsService.getNewsWithCursor(genre, cursor)
                println("DEBUG: Received more news - ${response.news.size} items, new nextCursor: ${response.nextCursor}")
                
                // Create a new list with existing items and append new ones
                val updatedList = newsItems.toMutableList()
                updatedList.addAll(response.news)
                
                // Update the state
                newsItems = updatedList
                nextCursor = response.nextCursor
                
                println("DEBUG: Updated state - total items: ${newsItems.size}, nextCursor: $nextCursor")
                isLoadingMore = false
                onComplete?.invoke(true)
            } catch (e: Exception) {
                errorMessage = "Failed to load more news: ${e.localizedMessage}"
                println("ERROR: ${e.message}")
                e.printStackTrace()
                isLoadingMore = false
                onComplete?.invoke(false)
            }
        }
    }
}
