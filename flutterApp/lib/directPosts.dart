import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:moivoice/retrieve_data.dart';
import 'package:moivoice/update_responses.dart';

class directPosts extends StatefulWidget {
  const directPosts({Key? key}) : super(key: key);

  @override
  State<directPosts> createState() => directPostsState();
}

class directPostsState extends State<directPosts> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 800.0,
      height: 880.0,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
                child: FutureBuilder(
                    future: RetrieveData().getDirectPostsData(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data) {
                          return Column(children: buildPostBox());
                        }
                      }
                      return const CircularProgressIndicator();
                    })),
          ),
        ],
      ),
    );
  }

  var commentsVisibility = false;
  var comment;
  var _controller = TextEditingController();
  var postId;

  List<Widget> buildPostBox() {
    final children = <Widget>[];
    //print("loaded$loaded");
    //RetrieveData().getPosts();

    print("posts: ${RetrieveData.fetchedDirectPosts}}");

    for (var i = 0; i < RetrieveData.fetchedDirectPosts.length; i++) {
      //var commentsVisibility = false;
      postId = RetrieveData.fetchedPosts[i]['id'];
      print('\n\ni: $i postid: $postId');
      children.add(
        Padding(
          padding: const EdgeInsets.only(
              left: 0.0, bottom: 6.0, right: 0.0, top: 7.0),
          child: Container(
            width: 600.0,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              color: Colors.white,
            ),
            child: Column(children: [
              SizedBox(
                height: 30.0,
                child: Row(
                  children: [
                    Text(" ",
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: 240.0,
                child: SingleChildScrollView(
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10, bottom: 100, right: 10, top: 10),
                      child: Text(RetrieveData.fetchedDirectPosts[i]['post']
                          .toString()),
                    ),
                    Text(''), //Captions here
                  ]),
                ),
              ),
            ]),
          ),
        ),
      );
    }

    return children;
  }
}
