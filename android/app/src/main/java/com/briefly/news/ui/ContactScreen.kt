package com.briefly.news.ui

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowBack
import androidx.compose.material.icons.filled.Email
import androidx.compose.material.icons.filled.Info
// Changed to Info icon which should be available
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.platform.LocalUriHandler
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextDecoration
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ContactScreen(onNavigateUp: () -> Unit) {
    val email = "vaidik50000@gmail.com"
    val linkedin = "linkedin.com/company/briefly-news-app/?viewAsMember=true"
    val uriHandler = LocalUriHandler.current
    
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
                title = "Contact Us",
                onBackClick = onNavigateUp
            )
            
            Column(
                modifier = Modifier
                    .fillMaxSize()
                    .padding(20.dp),
                verticalArrangement = Arrangement.spacedBy(30.dp)
            ) {
                Text(
                    text = "Contact Us",
                    color = Color.White,
                    fontSize = 40.sp,
                    fontWeight = FontWeight.Bold,
                    modifier = Modifier.padding(top = 30.dp)
                )
                
                Spacer(modifier = Modifier.weight(1f))
                
                // Email section
                ContactItem(
                    icon = Icons.Default.Email,
                    title = "Email",
                    value = email,
                    onClick = { uriHandler.openUri("mailto:$email") }
                )
                
                // LinkedIn section
                ContactItem(
                    icon = Icons.Default.Info,
                    title = "LinkedIn",
                    value = linkedin,
                    onClick = { uriHandler.openUri("https://$linkedin") }
                )
                
                Spacer(modifier = Modifier.weight(2f))
            }
        }
    }
}

@Composable
fun ContactItem(
    icon: ImageVector,
    title: String,
    value: String,
    onClick: () -> Unit
) {
    Card(
        modifier = Modifier.fillMaxWidth(),
        shape = RoundedCornerShape(15.dp),
        colors = CardDefaults.cardColors(
            containerColor = Color.White.copy(alpha = 0.1f)
        )
    ) {
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .padding(16.dp),
            verticalArrangement = Arrangement.spacedBy(10.dp)
        ) {
            Row(
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                Icon(
                    imageVector = icon,
                    contentDescription = null,
                    tint = Color(0xFF007AFF),
                    modifier = Modifier.size(22.dp)
                )
                
                Text(
                    text = title,
                    color = Color.White,
                    fontWeight = FontWeight.Bold,
                    fontSize = 16.sp
                )
            }
            
            Text(
                text = value,
                color = Color(0xFF007AFF),
                textDecoration = TextDecoration.Underline,
                fontSize = 14.sp,
                modifier = Modifier
                    .padding(start = 30.dp)
                    .clickable(onClick = onClick)
            )
        }
    }
}