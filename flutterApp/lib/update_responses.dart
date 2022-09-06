import 'package:http/http.dart' as http;
import 'package:moivoice/provider/auth_provider.dart';

class UpdateResponses {
  static Future<void> clap(postId, postType) async {
    final response = await http
        .post(Uri.parse('http://192.168.43.167:3000/posts/clap'), headers: {
      "content-type": "application/x-www-form-urlencoded;charset=UTF-8",
    }, body: {
      'userName': AuthProvider.userName,
      'userEmail': AuthProvider.userEmail,
      'postId': postId,
      'postType': postType
    });
  }

  static Future<void> slap(postId, postType) async {
    final response = await http
        .post(Uri.parse('http://192.168.43.167:3000/posts/slap'), headers: {
      "content-type": "application/x-www-form-urlencoded;charset=UTF-8",
    }, body: {
      'userName': AuthProvider.userName,
      'userEmail': AuthProvider.userEmail,
      'postId': postId,
      'postType': postType
    });
  }

  static Future<void> comment(postId, postType, comment) async {
    final response = await http
        .post(Uri.parse('http://192.168.43.167:3000/posts/comment'), headers: {
      "content-type": "application/x-www-form-urlencoded;charset=UTF-8",
    }, body: {
      'userName': AuthProvider.userName,
      'userEmail': AuthProvider.userEmail,
      'postId': postId,
      'postType': postType,
      'comment': comment
    });
  }
}
