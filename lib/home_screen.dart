import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_application/api_service.dart';
import 'package:news_application/dataModel.dart';
import 'package:news_application/news_detail.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NewsApiService _apiService = NewsApiService();
  TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  List<Article> _articles = [];

  Future<void> _searchArticles(String query) async {
    final articles = await _apiService.fetchArticles(query: query);
    setState(() {
      _articles = articles;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search articles...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white70),
          ),
          style: TextStyle(color: Colors.white),
          onSubmitted: (query) {
            if (query.isNotEmpty) {
              _searchArticles(query);
            }
          },
        )
            : const Text(
          'News Reader',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepOrange,
        elevation: 2,
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.clear : Icons.search,color: Colors.white70,),
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _searchController.clear();
                  _isSearching = false;
                  _articles.clear(); // Clear the articles when search is canceled
                } else {
                  _isSearching = true;
                }
              });
            },
          ),
        ],
      ),
      body: _isSearching
          ? _buildArticleList(_articles)
          : FutureBuilder<List<Article>>(
        future: _apiService.fetchArticles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.deepOrange));
          }

          if (snapshot.hasError) {
            return _buildErrorRetry();
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No articles available.'));
          }

          final articles = snapshot.data!;
          return _buildArticleList(articles);
        },
      ),
    );
  }

  Widget _buildArticleList(List<Article> articles) {

    if(articles.isEmpty)
      return _buildNoArticlesFound();
    else
    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: articles.length,
      itemBuilder: (context, index) {
        final article = articles[index];
        return _buildArticleCard(context, article);
      },
    );
  }

  Widget _buildArticleCard(BuildContext context, Article article) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: _buildArticleImage(article.urlToImage),
        title: _buildArticleTitle(article.title),
        subtitle: _buildArticleSubtitle(article.publishedAt),
        onTap: () => _navigateToArticleDetail(context, article),
      ),
    );
  }

  Widget _buildArticleImage(String? imageUrl) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          placeholder: (context, url) => const CircularProgressIndicator(color: Colors.deepOrange),
          errorWidget: (context, url, error) => const Icon(Icons.error),
          width: 65,
          height: 65,
          fit: BoxFit.cover,
        ),
      );
    }
    return const Icon(Icons.image_not_supported, size: 40, color: Colors.grey);
  }

  Widget _buildArticleTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildArticleSubtitle(String publishedAt) {
    return Text(
      'Published on: $publishedAt',
      style: const TextStyle(
        fontSize: 14,
        color: Colors.grey,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  void _navigateToArticleDetail(BuildContext context, Article article) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ArticleDetailScreen(article: article),
      ),
    );
  }

  Widget _buildErrorRetry() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 40),
          const SizedBox(height: 10),
          const Text('Failed to load news. Please try again.', textAlign: TextAlign.center),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              final articles = await _apiService.fetchArticles();
              setState(() {
                _articles = articles;
              });
            },
            child: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              backgroundColor: Colors.blueAccent,
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildNoArticlesFound() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.search_off, color: Colors.grey, size: 40),
        const SizedBox(height: 10),
        const Text(
          'No Articles Found',
          style: TextStyle(fontSize: 18, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}