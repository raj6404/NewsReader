import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news_application/dataModel.dart';

class NewsApiService {
  static const String _apiKey = '518839f1eefc4fcdabf68cfb97cae8db';
  static const String _baseUrl = 'https://newsapi.org/v2/top-headlines';

  Future<List<Article>> fetchArticles({String? query}) async {
    String url = '$_baseUrl?country=us&apiKey=$_apiKey';

    if (query != null && query.isNotEmpty) {
      url += '&q=$query';
    }

    final response = await http.get(Uri.parse(url));
    print('Searching : ${response.body} --------$url');
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Article> articles = (data['articles'] as List)
          .map((article) => Article.fromJson(article))
          .toList();
      return articles;
    } else {
      throw Exception('Failed to load news');
    }
  }
}