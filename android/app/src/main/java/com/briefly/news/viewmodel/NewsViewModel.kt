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
                val response = newsService.getNews(genre)
                newsItems = response.news
                nextCursor = response.nextCursor
                println("DEBUG: Fetched news, nextCursor: $nextCursor")
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
                val response = newsService.getNewsWithCursor(genre, cursor)
                newsItems = newsItems + response.news
                nextCursor = response.nextCursor
                println("DEBUG: Fetched more news, new nextCursor: $nextCursor")
                isLoadingMore = false
                onComplete?.invoke(true)
            } catch (e: Exception) {
                errorMessage = "Failed to load more news: ${e.localizedMessage}"
                isLoadingMore = false
                onComplete?.invoke(false)
            }
        }
    }
}
