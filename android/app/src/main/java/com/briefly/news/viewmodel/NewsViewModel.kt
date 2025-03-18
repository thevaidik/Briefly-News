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

interface NewsService {
    @GET("getnews/{genre}")
    suspend fun getNews(@Path("genre") genre: String): NewsResponse
}

class NewsViewModel : ViewModel() {
    var newsItems by mutableStateOf<List<NewsItem>>(emptyList())
        private set
    
    var errorMessage by mutableStateOf<String?>(null)
        private set
        
    var isLoading by mutableStateOf(false)
        private set

    private val retrofit = Retrofit.Builder()
        .baseUrl("https://m4vnpasso7.execute-api.ap-south-1.amazonaws.com/")
        .addConverterFactory(GsonConverterFactory.create())
        .build()

    private val newsService = retrofit.create(NewsService::class.java)

    fun fetchNews(genre: String, onComplete: ((Boolean) -> Unit)? = null) {
        viewModelScope.launch {
            isLoading = true
            errorMessage = null
            try {
                val response = newsService.getNews(genre)
                newsItems = response.news
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
}
