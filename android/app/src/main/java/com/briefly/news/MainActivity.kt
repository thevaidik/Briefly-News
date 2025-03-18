package com.briefly.news

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.runtime.Composable
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import com.briefly.news.ui.NewsScreen
import com.briefly.news.ui.SelectionScreen
import com.briefly.news.ui.theme.BrieflyNewsTheme
import com.briefly.news.viewmodel.NewsViewModel

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            BrieflyNewsTheme {
                BrieflyNewsApp()
            }
        }
    }
}

@Composable
fun BrieflyNewsApp() {
    val navController = rememberNavController()
    val viewModel = NewsViewModel()

    NavHost(navController = navController, startDestination = "selection") {
        composable("selection") {
            SelectionScreen(
                viewModel = viewModel,
                onNavigateToNews = { genre ->
                    navController.navigate("news/$genre")
                }
            )
        }
        composable("news/{genre}") { backStackEntry ->
            val genre = backStackEntry.arguments?.getString("genre") ?: return@composable
            NewsScreen(
                viewModel = viewModel,
                selectedGenre = genre,
                onNavigateUp = { navController.navigateUp() }
            )
        }
    }
}
