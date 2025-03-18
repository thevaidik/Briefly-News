package com.briefly.news.ui

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.grid.GridCells
import androidx.compose.foundation.lazy.grid.LazyVerticalGrid
import androidx.compose.foundation.lazy.grid.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.briefly.news.viewmodel.NewsViewModel

@Composable
fun SelectionScreen(
    viewModel: NewsViewModel,
    onNavigateToNews: (String) -> Unit
) {
    val genres = listOf(
        "technology", "business", "sports", "entertainment", "science",
        "world", "health", "ai", "hollywood", "defence", "politics",
        "automobile", "space", "economy"
    )
    
    var selectedGenre by remember { mutableStateOf("bollywood") }
    var isLoading by remember { mutableStateOf(false) }

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
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(16.dp),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.spacedBy(20.dp)
        ) {
            Spacer(modifier = Modifier.height(50.dp))
            
            Text(
                text = "Explore News",
                fontSize = 40.sp,
                fontWeight = FontWeight.Bold,
                color = Color.White,
                modifier = Modifier.shadow(10.dp)
            )
            
            Text(
                text = "Select Genre",
                fontSize = 20.sp,
                color = Color.White.copy(alpha = 0.8f)
            )

            LazyVerticalGrid(
                columns = GridCells.Adaptive(minSize = 120.dp),
                horizontalArrangement = Arrangement.spacedBy(8.dp),
                verticalArrangement = Arrangement.spacedBy(8.dp),
                modifier = Modifier.weight(1f),
                contentPadding = PaddingValues(horizontal = 8.dp)
            ) {
                items(genres) { genre ->
                    GenreButton(
                        genre = genre,
                        isSelected = selectedGenre == genre,
                        onClick = { selectedGenre = genre }
                    )
                }
            }

            Button(
                onClick = {
                    isLoading = true
                    viewModel.fetchNews(selectedGenre) { success ->
                        isLoading = false
                        if (success) {
                            onNavigateToNews(selectedGenre)
                        }
                    }
                },
                modifier = Modifier
                    .fillMaxWidth()
                    .height(55.dp)
                    .padding(horizontal = 14.dp)
                    .shadow(10.dp, RoundedCornerShape(15.dp)),
                shape = RoundedCornerShape(15.dp),
                colors = ButtonDefaults.buttonColors(
                    containerColor = Color(0xFF007AFF)
                ),
                enabled = !isLoading
            ) {
                if (isLoading) {
                    CircularProgressIndicator(
                        modifier = Modifier.size(20.dp),
                        color = Color.White,
                        strokeWidth = 2.dp
                    )
                    Spacer(modifier = Modifier.width(8.dp))
                }
                Text(
                    text = if (isLoading) "Generating..." else "Generate News",
                    fontSize = 16.sp,
                    fontWeight = FontWeight.SemiBold,
                    color = Color.White
                )
            }
            
            Spacer(modifier = Modifier.height(30.dp))
        }
    }
}

@Composable
private fun GenreButton(
    genre: String,
    isSelected: Boolean,
    onClick: () -> Unit
) {
    Button(
        onClick = onClick,
        modifier = Modifier
            .shadow(
                elevation = if (isSelected) 5.dp else 0.dp,
                shape = RoundedCornerShape(25.dp)
            )
            .defaultMinSize(minWidth = 80.dp, minHeight = 36.dp)
            .height(36.dp),
        shape = RoundedCornerShape(25.dp),
        colors = ButtonDefaults.buttonColors(
            containerColor = if (isSelected) Color(0xFF007AFF) else Color.White.copy(alpha = 0.1f)
        ),
        contentPadding = PaddingValues(horizontal = 12.dp, vertical = 8.dp),
        border = if (isSelected) ButtonDefaults.outlinedButtonBorder else null
    ) {
        Text(
            text = genre,
            fontSize = 14.sp,
            fontWeight = if (isSelected) FontWeight.Bold else FontWeight.Medium,
            color = if (isSelected) Color.White else Color.Gray,
            textAlign = TextAlign.Center,
            maxLines = 1,
            overflow = TextOverflow.Ellipsis,
            modifier = Modifier.weight(1f, fill = false)
        )
    }
}
