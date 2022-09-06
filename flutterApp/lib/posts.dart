import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:moivoice/retrieve_data.dart';
import 'package:moivoice/update_responses.dart';
import 'pages/home_page.dart' as homePage;
import 'pages/admin_view.dart' as adminHomePage;
import 'package:moivoice/provider/auth_provider.dart';
import 'dart:io' as io;

class Posts extends StatefulWidget {
  const Posts({Key? key}) : super(key: key);

  @override
  State<Posts> createState() => PostsState();
}

class PostsState extends State<Posts> {
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
                    future: RetrieveData().getPostsData(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data) {
                          //if the user is an administrator
                          if (AuthProvider.userId == '1') {
                            return (adminHomePage.viewOrder == 'latest')
                                ? Column(children: buildLatestPosts())
                                : Column(children: buildTrendingPosts());
                          }
                          //for students
                          else {
                            return (homePage.viewOrder == 'latest')
                                ? Column(children: buildLatestPosts())
                                : Column(children: buildTrendingPosts());
                          }
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
  var textVisibility = false;
  var imageVisibility = false;
  var image;

  List<Widget> buildLatestPosts() {
    final children = <Widget>[];

    for (var i = 0; i < RetrieveData.fetchedPosts.length; i++) {
      postId = RetrieveData.fetchedPosts[i]['id'];

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
                    Material(
                      shape: const CircleBorder(),
                      color: Colors.grey,
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.person),
                      ),
                    ),
                    //"Person's Name here"
                    Text(RetrieveData.fetchedPosts[i]['user_name'].toString(),
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
                      child: Column(
                        children: [
                          Text(RetrieveData.fetchedPosts[i]['post'].toString())
                        ],
                      ),
                    ),
                  ]),
                ),
              ),
              SizedBox(
                height: 40.0,
                child: Row(children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, bottom: 0.0, right: 25.0, top: 0.0),
                    child: SizedBox(
                      child: Row(children: [
                        IconButton(
                            onPressed: () async {
                              UpdateResponses.clap(
                                  RetrieveData.fetchedPosts[i]['id'].toString(),
                                  'Text');
                            },
                            icon: Image.asset(
                              "./../assets/img/clap.jpeg",
                              width: 40.0,
                              height: 40.0,
                            ),
                            tooltip: 'clap'),
                        Text(RetrieveData.fetchedClaps['$postId'] != null
                            ? RetrieveData.fetchedClaps['$postId'].length
                                .toString()
                            : "0")
                      ]),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, bottom: 0.0, right: 45.0, top: 0.0),
                    child: SizedBox(
                      child: Row(children: [
                        IconButton(
                            onPressed: () {
                              UpdateResponses.slap(
                                  RetrieveData.fetchedPosts[i]['id'].toString(),
                                  'Text');
                            },
                            icon: Icon(Icons.back_hand_outlined),
                            tooltip: 'Slap'),
                        Text(RetrieveData.fetchedSlaps['$postId'] != null
                            ? RetrieveData.fetchedSlaps['$postId'].length
                                .toString()
                            : "0")
                      ]),
                    ),
                  ),
                  SizedBox(
                    child: Row(children: [
                      IconButton(
                          onPressed: () {
                            setState(() {
                              if (commentsVisibility != true) {
                                commentsVisibility = true;
                              } else {
                                commentsVisibility = false;
                              }
                            });
                          },
                          icon: Icon(Icons.comment_outlined),
                          tooltip: 'Comment'),
                      Text(RetrieveData.fetchedComments['$postId'] != null
                          ? RetrieveData.fetchedComments['$postId'].length
                              .toString()
                          : "0")
                    ]),
                  ),
                ]),
              ),
              Visibility(
                visible: commentsVisibility,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        child: Padding(
                            padding: const EdgeInsets.only(
                                left: 30.0, bottom: 2.0, right: 30.0, top: 2.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Material(
                                  shape: const CircleBorder(),
                                  color: Colors.grey,
                                  child: IconButton(
                                      icon: Icon(Icons.person),
                                      onPressed: () {}),
                                ),
                                SizedBox(
                                  width: 300.0,
                                  child: TextField(
                                    controller: _controller,
                                    autocorrect: false,
                                    keyboardType: TextInputType.multiline,
                                    textInputAction: TextInputAction.newline,
                                    minLines: 3,
                                    maxLines: null,
                                    decoration: InputDecoration(
                                      labelText: 'Write your comment',
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          UpdateResponses.comment(
                                              RetrieveData.fetchedPosts[i]['id']
                                                  .toString(),
                                              'Text',
                                              comment);
                                          _controller.clear();
                                        },
                                        icon: const Icon(Icons.send),
                                      ),
                                    ),
                                    onChanged: (val) {
                                      comment = val;
                                    },
                                  ),
                                ),
                              ],
                            )),
                      ),
                      ...buildComments(postId),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ),
      );
    }

    return children;
  }

  List<Widget> buildComments(postId) {
    final children = <Widget>[];

    //display comments for the post if any using the post id
    if (RetrieveData.fetchedComments['$postId'] != null) {
      for (var i = 0; i < RetrieveData.fetchedComments['$postId'].length; i++) {
        children.add(Padding(
          padding: const EdgeInsets.only(
              left: 10.0, bottom: 8.0, right: 10.0, top: 6.0),
          child: Container(
            child: Column(children: [
              SizedBox(
                child: Row(children: [
                  Material(
                    shape: const CircleBorder(),
                    color: Colors.grey,
                    child:
                        IconButton(icon: Icon(Icons.person), onPressed: () {}),
                  ),
                  Text(RetrieveData.fetchedComments['$postId'][i]['user_name']),
                ]),
              ),
              SizedBox(
                child:
                    Text(RetrieveData.fetchedComments['$postId'][i]['comment']),
              ),
            ]),
          ),
        ));
      }
    }
    return children;
  }

  //-----------------ORDERING THE POSTS ACCORDING TO LEVEL OF RESPONSES FROM USERS-----------------//
  //implemented using a linked list

  //head of posts' linked list
  late PostNode head;

  //building post according to the most trending
  List<Widget> buildTrendingPosts() {
    final children = <Widget>[];

    for (var i = 0; i < RetrieveData.fetchedPosts.length; i++) {
      //var commentsVisibility = false;
      postId = RetrieveData.fetchedPosts[i]['id'];
      //compute how trendy the post is by adding comments,slaps and claps
      var trendWeight = RetrieveData.fetchedComments['$postId'].length +
          RetrieveData.fetchedSlaps['$postId'].length +
          RetrieveData.fetchedClaps['$postId'].length;

      if (i == 0) {
        head = PostNode(id: postId, weight: trendWeight);
      } else {
        addNode(postId, trendWeight);
      }
    }
    print(head);

    PostNode? current = head;
    while (current!.next != null) {
      postId = current.id;
      int postindex = postIndex(postId);

      print(
          "\n\n RUNTIMETYPE::::::::::::${RetrieveData.fetchedPosts[current.id - 1].runtimeType}");
      print('\n\ni: ${current.id - 1} postid: $postId');
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
                    Material(
                      shape: const CircleBorder(),
                      color: Colors.grey,
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.person),
                      ),
                    ),
                    //"Person's Name here"
                    Text(
                        RetrieveData.fetchedPosts[postindex]['user_name']
                            .toString(),
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
                      child: Text(RetrieveData.fetchedPosts[postindex]['post']
                          .toString()),
                    ),
                  ]),
                ),
              ),
              SizedBox(
                height: 40.0,
                child: Row(children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, bottom: 0.0, right: 25.0, top: 0.0),
                    child: SizedBox(
                      child: Row(children: [
                        IconButton(
                            onPressed: () async {
                              UpdateResponses.clap(
                                  RetrieveData.fetchedPosts[postindex]['id']
                                      .toString(),
                                  'Text');
                            },
                            icon: Image.asset(
                              "./../assets/img/clap.jpeg",
                              width: 40.0,
                              height: 40.0,
                            ),
                            tooltip: 'clap'),
                        Text(RetrieveData.fetchedClaps['$postId'] != null
                            ? RetrieveData.fetchedClaps['$postId'].length
                                .toString()
                            : "0")
                      ]),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, bottom: 0.0, right: 45.0, top: 0.0),
                    child: SizedBox(
                      child: Row(children: [
                        IconButton(
                            onPressed: () {
                              UpdateResponses.slap(
                                  RetrieveData.fetchedPosts[postindex]['id']
                                      .toString(),
                                  'Text');
                            },
                            icon: Icon(Icons.back_hand_outlined),
                            tooltip: 'Slap'),
                        Text(RetrieveData.fetchedSlaps['$postId'] != null
                            ? RetrieveData.fetchedSlaps['$postId'].length
                                .toString()
                            : "0")
                      ]),
                    ),
                  ),
                  SizedBox(
                    child: Row(children: [
                      IconButton(
                          onPressed: () {
                            setState(() {
                              if (commentsVisibility != true) {
                                commentsVisibility = true;
                              } else {
                                commentsVisibility = false;
                              }
                            });
                          },
                          icon: Icon(Icons.comment_outlined),
                          tooltip: 'Comment'),
                      Text(RetrieveData.fetchedComments['$postId'] != null
                          ? RetrieveData.fetchedComments['$postId'].length
                              .toString()
                          : "0")
                    ]),
                  ),
                ]),
              ),
              Visibility(
                visible: commentsVisibility,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        child: Padding(
                            padding: const EdgeInsets.only(
                                left: 30.0, bottom: 2.0, right: 30.0, top: 2.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Material(
                                  shape: const CircleBorder(),
                                  color: Colors.grey,
                                  child: IconButton(
                                      icon: Icon(Icons.person),
                                      onPressed: () {}),
                                ),
                                SizedBox(
                                  width: 300.0,
                                  child: TextField(
                                    controller: _controller,
                                    autocorrect: false,
                                    keyboardType: TextInputType.multiline,
                                    textInputAction: TextInputAction.newline,
                                    minLines: 3,
                                    maxLines: null,
                                    decoration: InputDecoration(
                                      labelText: 'Write your comment',
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          UpdateResponses.comment(
                                              RetrieveData
                                                  .fetchedPosts[postindex]['id']
                                                  .toString(),
                                              'Text',
                                              comment);
                                          _controller.clear();
                                        },
                                        icon: const Icon(Icons.send),
                                      ),
                                    ),
                                    onChanged: (val) {
                                      comment = val;
                                    },
                                  ),
                                ),
                              ],
                            )),
                      ),
                      ...buildComments(postId),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ),
      );
      current = current.next;
    }

    return children;
  }

  int postIndex(postId) {
    for (int i = 0; i < RetrieveData.fetchedPosts.length; i++) {
      if (RetrieveData.fetchedPosts[i]['id'] == postId) {
        return i;
      }
    }
    return 0;
  }

  void addNode(id, newNodeWeight) {
    PostNode newNode = PostNode(id: id, weight: newNodeWeight);
    //current node in the linked list
    PostNode? current;
    //add node at the beginning of the linked list
    if (newNodeWeight > head.weight) {
      newNode.next = head;
      head = newNode;
    }
    //new node's weight is less than head's weight
    else {
      current = head;
      while (current!.next != null) {
        //adding node in between nodes
        if ((current.weight > newNodeWeight &&
                current.next!.weight < newNodeWeight) ||
            current.weight == newNodeWeight) {
          newNode.next = current.next;
          current.next = newNode;
          break;
        }
        current = (current.next != null) ? current.next : null;
      }
      //if the new node has the least weight in the linked list
      if (current.next == null) {
        current.next = newNode;
      }
    }
  }
}

//each node is a post for all post's linked list
class PostNode<T> {
  PostNode({required this.weight, required this.id, this.next});
  T weight;
  T id;
  PostNode<T>? next;

  /*@override
  String toString() {
    if (next == null) return '$id:$weight';
    return '$id:$weight -> ${next.toString()}';
  }*/
}
