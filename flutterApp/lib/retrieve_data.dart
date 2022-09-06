import 'package:http/http.dart' as http;
import 'dart:convert';

class RetrieveData {
  static var fetchedPosts;
  static var fetchedDirectPosts;
  static var fetchedComments;
  static var fetchedSlaps;
  static var fetchedClaps;

  Future<bool> getPostsData() async {
    final response =
        await http.get(Uri.parse('http://192.168.43.167:3000/posts/getPosts'));
    Map<String, dynamic> map = jsonDecode(response.body);
    fetchedPosts = map['posts'];
    fetchedClaps = map['claps'];
    fetchedSlaps = map['slaps'];
    fetchedComments = map['comments'];
    return true;
  }

  Future<bool> getDirectPostsData() async {
    final response = await http
        .get(Uri.parse('http://192.168.43.167:3000/posts/getDirectPosts'));
    Map<String, dynamic> map = jsonDecode(response.body);
    print(map);
    fetchedDirectPosts = map['posts'];
    print(fetchedDirectPosts.length);

    return true;
  }
}
