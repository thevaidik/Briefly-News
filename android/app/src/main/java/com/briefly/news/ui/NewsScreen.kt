package com.briefly.news.ui

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.lazy.rememberLazyListState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowBack
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalUriHandler
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.briefly.news.viewmodel.NewsViewModel
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.Divider
import androidx.compose.material3.DividerDefaults
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.text.TextStyle
import com.briefly.news.data.NewsItem
import com.briefly.news.data.NewsPoint
import androidx.compose.foundation.clickable
import androidx.compose.foundation.border
import androidx.compose.foundation.BorderStroke

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun NewsScreen(
    viewModel: NewsViewModel,
    selectedGenre: String,
    onNavigateUp: () -> Unit
) {
    val listState = rememberLazyListState()
    var showLoadMore by remember { mutableStateOf(false) }

    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(
                brush = Brush.verticalGradient(
                    colors = listOf(
                        Color.Black,
                        Color.Gray.copy(alpha = 0.8f)
                    )
                )
            )
    ) {
        Column(modifier = Modifier.fillMaxSize()) {
            // Custom Navigation Bar
            CustomNavigationBar(
                title = "$selectedGenre News",
                onBackClick = onNavigateUp
            )
            
            // Content
            if (viewModel.isLoading) {
                Box(
                    modifier = Modifier.fillMaxSize(),
                    contentAlignment = Alignment.Center
                ) {
                    CircularProgressIndicator(
                        color = Color.White,
                        modifier = Modifier.size(48.dp)
                    )
                }
            } else if (viewModel.errorMessage != null) {
                ErrorView(
                    errorMessage = viewModel.errorMessage!!,
                    onRetry = { viewModel.fetchNews(selectedGenre) }
                )
            } else {
                LazyColumn(
                    state = listState,
                    contentPadding = PaddingValues(16.dp),
                    verticalArrangement = Arrangement.spacedBy(12.dp),
                    modifier = Modifier.fillMaxSize()
                ) {
                    items(
                        items = viewModel.newsItems,
                        key = { it.id }
                    ) { newsItem ->
                        NewsItemView(item = newsItem)
                    }
                    
                    // Add tap-to-load more button
                    if (viewModel.nextCursor != null) {
                        item {
                            Card(
                                modifier = Modifier
                                    .fillMaxWidth()
                                    .padding(16.dp)
                                    .clickable {
                                        viewModel.fetchMoreNews(selectedGenre)
                                    },
                                shape = RoundedCornerShape(12.dp),
                                colors = CardDefaults.cardColors(
                                    containerColor = Color.White.copy(alpha = 0.15f)
                                )
                            ) {
                                Box(
                                    modifier = Modifier
                                        .fillMaxWidth()
                                        .height(50.dp),
                                    contentAlignment = Alignment.Center
                                ) {
                                    if (viewModel.isLoadingMore) {
                                        CircularProgressIndicator(
                                            modifier = Modifier.size(24.dp),
                                            color = Color.White,
                                            strokeWidth = 2.dp
                                        )
                                    } else {
                                        Text(
                                            text = "Tap to Load More",
                                            color = Color.White.copy(alpha = 0.9f),
                                            fontSize = 14.sp,
                                            fontWeight = FontWeight.Medium
                                        )
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

@Composable
fun CustomNavigationBar(title: String, onBackClick: () -> Unit) {
    Column {
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .height(44.dp)
                .background(Color.Black.copy(alpha = 0.01f)),
            verticalAlignment = Alignment.CenterVertically
        ) {
            IconButton(onClick = onBackClick) {
                Icon(
                    imageVector = Icons.Default.ArrowBack,
                    contentDescription = "Back",
                    tint = Color.White
                )
            }
            
            Spacer(modifier = Modifier.weight(1f))
            
            Text(
                text = title,
                color = Color.White,
                fontSize = 17.sp,
                fontWeight = FontWeight.SemiBold
            )
            
            Spacer(modifier = Modifier.weight(1f))
            
            // Empty space for balance
            Spacer(modifier = Modifier.width(48.dp))
        }
        
        // Add Updated Daily text
        Text(
            text = "Updated Daily",
            color = Color.White.copy(alpha = 0.7f),
            fontSize = 12.sp,
            modifier = Modifier.align(Alignment.CenterHorizontally)
        )
    }
}

@Composable
fun ErrorView(errorMessage: String, onRetry: () -> Unit) {
    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(16.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center
    ) {
        Text(
            text = errorMessage,
            color = Color.White,
            textAlign = TextAlign.Center
        )
        
        Spacer(modifier = Modifier.height(16.dp))
        
        Button(onClick = onRetry) {
            Text("Retry")
        }
    }
}

@Composable
fun NewsItemView(item: NewsItem) {
    val uriHandler = LocalUriHandler.current
    
    Card(
        modifier = Modifier
            .fillMaxWidth()
            .shadow(4.dp, RoundedCornerShape(12.dp)),
        shape = RoundedCornerShape(12.dp),
        colors = CardDefaults.cardColors(
            containerColor = Color.Black.copy(alpha = 0.7f)
        )
    ) {
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .padding(16.dp)
        ) {
            // Title
            Text(
                text = item.title,
                color = Color.White,
                fontSize = 18.sp,
                fontWeight = FontWeight.Bold,
                modifier = Modifier.padding(bottom = 12.dp)
            )
            
            // Points
            item.points.forEachIndexed { index, point ->
                if (index > 0) {
                    Spacer(modifier = Modifier.height(12.dp))
                    Divider(color = Color.Gray.copy(alpha = 0.3f))
                    Spacer(modifier = Modifier.height(12.dp))
                }
                
                NewsPointView(point = point, uriHandler = uriHandler)
            }
        }
    }
}

@Composable
fun NewsPointView(point: NewsPoint, uriHandler: androidx.compose.ui.platform.UriHandler) {
    Column {
        // Description
        Text(
            text = point.description,
            color = Color.White.copy(alpha = 0.9f),
            fontSize = 14.sp,
            modifier = Modifier.padding(bottom = 8.dp),
            maxLines = 2,
            overflow = TextOverflow.Ellipsis
        )
        
        // Source and date info
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
        ) {
            Text(
                text = "Source: ${point.source}",
                color = Color.White.copy(alpha = 0.7f),
                fontSize = 12.sp
            )
            
            Text(
                text = formatPublishedDate(point.publishedAt),
                color = Color.White.copy(alpha = 0.7f),
                fontSize = 12.sp
            )
        }
        
        // Replace Button with Text for a more compact "Read more"
        Text(
            text = "Read more",
            color = Color(0xFF007AFF),  // iOS blue
            fontSize = 12.sp,
            fontWeight = FontWeight.Medium,
            modifier = Modifier
                .padding(top = 8.dp)
                .align(Alignment.Start)  // Align to start like iOS
                .clickable { uriHandler.openUri(point.url) }
        )
    }
}

// Update the date formatting function to keep only day, date and HH:MM
private fun formatPublishedDate(dateString: String): String {
    return try {
        // Example: "Tue, 18 Mar 2025 16:52:09 +00"
        // Extract day and date part
        val parts = dateString.split(" ")
        val day = parts[0].replace(",", "") // "Tue"
        val date = parts[1] // "18"
        val month = parts[2] // "Mar"
        
        // Extract time part - keep only HH:MM
        val timeParts = parts[4].split(":")
        val hour = timeParts[0] // "16"
        val minute = timeParts[1] // "52"
        
        "$day, $date $month $hour:$minute"
    } catch (e: Exception) {
        dateString // Return original string if parsing fails
    }
}
