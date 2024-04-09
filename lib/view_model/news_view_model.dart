

import 'package:newappofapi/Models/CategoriesNewsModel.dart';
import 'package:newappofapi/Models/NewsChannelsHeadlinesModel.dart';
import 'package:newappofapi/Repository/news_repository.dart';

class NewsViewModel{
  final _rep = NewsRepository();

  Future<NewsChannelsHeadlinesModel> fetchNewChannelHeadlinesApi(String channelname) async{
    final response = await _rep.fetchNewChannelHeadlinesApi(channelname);
    return response ;
  }

  Future<CategoriesNewsModel> fetchCategoriesNewsApi(String category) async{
    final response = await _rep.fetchCategoriesNewsApi(category);
    return response ;
  }

}