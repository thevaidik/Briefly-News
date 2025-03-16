package com.briefly.news.ui

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.grid.GridCells
import androidx.compose.foundation.lazy.grid.LazyVerticalGrid
import androidx.compose.foundation.lazy.grid.items
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.briefly.news.viewmodel.NewsViewModel

@Composable
fun SelectionScreen(
    viewModel: NewsViewModel,
    onNavigateToNews: (String) -> Unit
) {
    val genres = listOf(
        "technology", "business", "sports", "entertainment", 
        "science", "world", "health", "ai", "hollywood", 
        "defence", "politics", "automobile", "space", "economy"
    )
    
    var selectedGenre by remember { mutableStateOf("bollywood") }

    Box(
        modifier = Modifier.fillMaxSize()
    ) {
        Surface(
            modifier = Modifier.fillMaxSize(),
            color = MaterialTheme.colorScheme.surface
        ) {
            Column(
                modifier = Modifier
                    .fillMaxSize()
                    .padding(16.dp),
                horizontalAlignment = Alignment.CenterHorizontally
            ) {
                Spacer(modifier = Modifier.height(50.dp))
                
                Text(
                    text = "Explore News",
                    fontSize = 40.sp,
                    fontWeight = FontWeight.Bold,
                    color = MaterialTheme.colorScheme.primary
                )
                
                Text(
                    text = "Select Genre",
                    fontSize = 20.sp,
                    color = MaterialTheme.colorScheme.onSurface.copy(alpha = 0.8f),
                    modifier = Modifier.padding(vertical = 16.dp)
                )
                
                LazyVerticalGrid(
                    columns = GridCells.Adaptive(minSize = 100.dp),
                    contentPadding = PaddingValues(8.dp),
                    horizontalArrangement = Arrangement.spacedBy(8.dp),
                    verticalArrangement = Arrangement.spacedBy(8.dp)
                ) {
                    items(genres) { genre ->
                        GenreButton(
                            genre = genre,
                            isSelected = selectedGenre == genre,
                            onClick = { selectedGenre = genre }
                        )
                    }
                }
                
                Spacer(modifier = Modifier.weight(1f))
                
                Button(
                    onClick = { onNavigateToNews(selectedGenre) },
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(55.dp)
                        .padding(horizontal = 16.dp),
                    shape = MaterialTheme.shapes.medium
                ) {
                    Text("Generate News")
                }
                
                Spacer(modifier = Modifier.height(50.dp))
            }
        }
    }
}

@Composable
fun GenreButton(
    genre: String,
    isSelected: Boolean,
    onClick: () -> Unit
) {
    Button(
        onClick = onClick,
        colors = ButtonDefaults.buttonColors(
            containerColor = if (isSelected) 
                MaterialTheme.colorScheme.primary 
            else 
                MaterialTheme.colorScheme.surface,
            contentColor = if (isSelected) 
                MaterialTheme.colorScheme.onPrimary 
            else 
                MaterialTheme.colorScheme.onSurface
        ),
        shape = MaterialTheme.shapes.medium,
        modifier = Modifier.height(40.dp)
    ) {
        Text(
            text = genre,
            fontSize = 14.sp,
            fontWeight = if (isSelected) FontWeight.Bold else FontWeight.Normal
        )
    }
}
