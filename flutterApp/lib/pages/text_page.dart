import 'package:flutter/material.dart';
import 'profile_page.dart';
import 'home_page.dart';
import 'package:http/http.dart' as http;
import 'package:moivoice/provider/auth_provider.dart';
import 'dart:convert';
import 'package:moivoice/globals.dart' as globals;
import 'profile_page.dart' as profilePage;

class TextPage extends StatefulWidget {
  const TextPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<TextPage> createState() => TextPageState();
}

class TextPageState extends State<TextPage> {
  late String postText;
  var directPostDescriptionVisibility = false;
  var directPostButtonVisibility = true;
  bool postDirectly = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: globals.backgroundColor,
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
              color: globals.TextIconColor,
              tooltip: 'home',
              //color: Colors.green,
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const MyHomePage(title: 'MoiVoice');
                }));
              },
            ),
            IconButton(
              icon: const Icon(Icons.person),
              color: globals.TextIconColor,
              tooltip: 'profile',
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const ProfilePage(title: 'MoiVoice');
                }));
              },
            ),
          ],
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
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
                    postText = val;
                  },
                ),
              ),
              //visible only if posting publicly
              Visibility(
                visible: directPostButtonVisibility,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      directPostDescriptionVisibility = true;
                      directPostButtonVisibility = false;
                      postDirectly = true;
                    });
                  },
                  child: const Text(
                    '\n\n\nWant to send the post directly to admin? Send directly anonymously',
                  ),
                ),
              ),
              //visible only if posting directly to admin
              Visibility(
                  visible: directPostDescriptionVisibility,
                  child: Column(
                    children: [
                      const Text(
                          "\n\n\nYour post will be sent directly to the administration, so no one will view in publicly, \n and anonymously, it can't be traced back to you"),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            directPostDescriptionVisibility = false;
                            directPostButtonVisibility = true;
                            postDirectly = false;
                          });
                        },
                        child: const Text("Go back to posting publicly"),
                      )
                    ],
                  )),
            ],
          ),
        ),
        floatingActionButton: SizedBox(
          child: IconButton(
            onPressed: () {
              //if the user wants to post directly use postDirectly() else post
              (postDirectly) ? postDirect(postText) : post(postText);
            },
            icon: const Icon(Icons.send),
          ),
        ));
  }

  Future<void> post(String text) async {
    final response = await http
        .post(Uri.parse("http://192.168.43.167:3000/posts/postText"), headers: {
      "content-type": "application/x-www-form-urlencoded;charset=UTF-8",
    }, body: {
      //check if the user is in anonymous mode, then send the post with 'Anonymous'
      'userName': (profilePage.isAnonymous == true)
          ? "Anonymous"
          : AuthProvider.userName,
      'userEmail': (profilePage.isAnonymous == true)
          ? "Anonymous"
          : AuthProvider.userEmail,
      'post_type': 'text',
      'post': text
    });

    Map<String, dynamic> map = jsonDecode(response.body);

    if (map['message'] != null) {
      String message = map['message'];
      if (message == 'success') {
        Navigator.pushNamed(context, "/home");
      }
    }

    if (map['error'] != null) {
      String errorMessage = map['error']['message'];
    }
  }

  //handles direct posts
  Future<void> postDirect(String text) async {
    final response = await http.post(
        Uri.parse("http://192.168.43.167:3000/posts/postDirect"),
        headers: {
          "content-type": "application/x-www-form-urlencoded;charset=UTF-8",
        },
        body: {
          'post': text
        });

    
    Map<String, dynamic> map = jsonDecode(response.body);

    if (map['message'] != null) {
      String message = map['message'];
      if (message == 'success') {
        Navigator.pushNamed(context, "/home");
      }
    }

    if (map['error'] != null) {
      String errorMessage = map['error']['message'];
    }
  }
}
