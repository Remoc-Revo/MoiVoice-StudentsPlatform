import 'package:flutter/material.dart';
import 'dart:io' as io;
import 'home_page.dart' as homePage;
import 'profile_page.dart';
import 'package:http/http.dart' as http;
import 'profile_page.dart' as profilePage;
import 'package:moivoice/provider/auth_provider.dart';
import 'package:flutter/foundation.dart';
import 'dart:io' as io;

class ImgVidSelectPage extends StatefulWidget {
  const ImgVidSelectPage({
    Key? key,
    required this.title,
    required this.imgVid,
    required this.imgVidType,
  }) : super(key: key);

  final String title;
  final io.File imgVid;
  final String imgVidType;

  @override
  State<ImgVidSelectPage> createState() => ImgVidSelectPageState();
}

class ImgVidSelectPageState extends State<ImgVidSelectPage> {
  String caption = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          //automaticallyImplyLeading: false,
          title: Text(
            widget.title,
            style: const TextStyle(
              color: Colors.green,
              fontSize: 30,
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.home),
              tooltip: 'home',
              //color: Colors.green,
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const homePage.MyHomePage(title: 'MoiVoice');
                }));
              },
            ),
            IconButton(
              icon: const Icon(Icons.person),
              tooltip: 'profile',
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const ProfilePage(title: 'MoiVoice');
                }));
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: 200,
                child: Image.file(widget.imgVid)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: TextField(
                autocorrect: false,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                minLines: 1,
                maxLines: 14,
                decoration: InputDecoration(labelText: 'Write something...'),
                onChanged: (val) {
                  caption = val;
                },
              ),
            ),
          ],
        ),
        floatingActionButton: SizedBox(
          child: IconButton(
            onPressed: () {
              post(widget.imgVid, caption);
            },
            icon: const Icon(Icons.send),
          ),
        ));
  }

  Future<http.StreamedResponse> post(io.File imgVid, String text) async {
    final http.MultipartRequest request = http.MultipartRequest(
        'POST', Uri.parse("http://192.168.43.167:3000/posts/postImgVid"));
    request.headers.addAll(<String, String>{
      "content-type": "multipart/form-data",
    });
    io.File _file = io.File(imgVid.path);
    request.files.add(http.MultipartFile(
        'image', _file.readAsBytes().asStream(), _file.lengthSync(),
        filename: DateTime.now().microsecondsSinceEpoch.toString() +
            AuthProvider.userEmail +
            "-" +
            widget.imgVidType));

    Map<String, String> _fields = Map();
    _fields.addAll(<String, String>{
      //check if the user is in anonymous mode, then send the post with 'Anonymous'
      'userName': (profilePage.isAnonymous == true)
          ? "Anonymous"
          : AuthProvider.userName,
      'userEmail': (profilePage.isAnonymous == true)
          ? "Anonymous"
          : AuthProvider.userEmail,
      'post_type': 'imgVid',
      'caption': text,
      'fileName': DateTime.now().microsecondsSinceEpoch.toString() +
          AuthProvider.userEmail +
          "-" +
          widget.imgVidType
    });
    request.fields.addAll(_fields);
    http.StreamedResponse response = await request.send();

    if (response != null) {
      Navigator.pushNamed(context, "/home");
    }

    return response;
  }
}
