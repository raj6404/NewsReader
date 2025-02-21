import 'package:flutter/material.dart';
import 'package:news_application/api_service.dart';
import 'package:news_application/dataModel.dart';

class NewsProvider extends ChangeNotifier {
  List<Article> _articles = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Article> get articles => _articles;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchArticles() async {
    _isLoading = true;
    notifyListeners();
    try {
      final fetchedArticles = await NewsApiService().fetchArticles();
      _articles = fetchedArticles;
      _errorMessage = '';
    } catch (error) {
      _errorMessage = 'Failed to load news';
    }
    _isLoading = false;
    notifyListeners();
  }
}
