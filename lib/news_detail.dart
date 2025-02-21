import 'package:flutter/material.dart';
import 'package:news_application/api_service.dart';
import 'package:news_application/dataModel.dart';

class ArticleDetailScreen extends StatelessWidget {
  final Article article;

  ArticleDetailScreen({required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.white70,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(article.title, style: TextStyle(color: Colors.white70)),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              article.urlToImage != null && article.urlToImage!.isNotEmpty
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  article.urlToImage!,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              )
                  : Container(
                width: double.infinity,
                height: 250,
                color: Colors.grey[300],
                child: Center(
                  child: Icon(Icons.image_not_supported, color: Colors.grey),
                ),
              ),
              SizedBox(height: 16),

              // Title
              Text(
                article.title,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 8),

              // Content
              Text(
                article.content,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 16),

              // Published date
              Text(
                'Published on: ${article.publishedAt}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
