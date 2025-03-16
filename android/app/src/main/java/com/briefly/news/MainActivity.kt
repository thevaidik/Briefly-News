package com.briefly.news

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.runtime.remember
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import com.briefly.news.ui.NewsScreen
import com.briefly.news.ui.SelectionScreen
import com.briefly.news.ui.theme.BrieflyTheme
import com.briefly.news.viewmodel.NewsViewModel

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            BrieflyTheme {
                val navController = rememberNavController()
                val newsViewModel: NewsViewModel = viewModel()

                NavHost(
                    navController = navController,
                    startDestination = "selection"
                ) {
                    composable("selection") {
                        SelectionScreen(
                            viewModel = newsViewModel,
                            onNavigateToNews = { genre ->
                                newsViewModel.fetchNews(genre)
                                navController.navigate("news/$genre")
                            }
                        )
                    }
                    composable(
                        route = "news/{genre}"
                    ) { backStackEntry ->
                        val genre = backStackEntry.arguments?.getString("genre") ?: return@composable
                        NewsScreen(
                            viewModel = newsViewModel,
                            selectedGenre = genre,
                            onNavigateUp = { navController.navigateUp() }
                        )
                    }
                }
            }
        }
    }
}
