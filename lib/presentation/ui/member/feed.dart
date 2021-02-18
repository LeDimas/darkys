import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darky_app/services/database_service.dart';
import 'package:flutter/material.dart';

import 'package:darky_app/models/data_block.dart';
import 'package:darky_app/models/post.dart';
import 'package:darky_app/presentation/ui/admin/check/add_feed.dart';

class NewsFeedPage extends StatefulWidget {
  @override
  _NewsFeedPageState createState() => _NewsFeedPageState();
  final String role;
  const NewsFeedPage({
    Key key,
    this.role,
  }) : super(key: key);
}

class _NewsFeedPageState extends State<NewsFeedPage> {
  ScrollController scrollController = ScrollController();
  Databloc<Post> postsDataBloc;
  CollectionReference cr = FirebaseFirestore.instance.collection('feed');
  List news;

  Post convertDocSnapToPost(DocumentSnapshot doc) {
    return Post(
        back: doc.data()['background'],
        image: doc.data()['image'],
        title: doc.data()['title'],
        content: doc.data()['content']);
  }

  @override
  void initState() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        print('ping');
        postsDataBloc.fetchNextSetOfData();
      }
    });
    super.initState();
    postsDataBloc = Databloc<Post>(
        numberToLoadFromNextTime: 2,
        numberToLoadAtATime: 6,
        query: cr.orderBy("date", descending: true),
        documentSnapshotToT: convertDocSnapToPost);
    postsDataBloc.fetchInitialData();
  }

  @override
  void dispose() {
    postsDataBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color(0xFF6DC0C4),
          shadowColor: Colors.transparent,
          title: Text(
            "News Feed",
          ),
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color(0xFF263248),
          ),
          child: Container(
            height: double.infinity,
            child: SingleChildScrollView(
              controller: scrollController,
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(
                vertical: 48.0,
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        "Darky's Jaunumi",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 32.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width / 1.2,
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                            color: Color(0xff7E8AA2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(16.0))),
                        child: Column(
                          children: <Widget>[
                            // Stack(children: [
                            // FittedBox(
                            //   fit: BoxFit.contain,
                            //   child: Container(
                            //     height: 154,
                            //     width: MediaQuery.of(context).size.width / 1.2,
                            //     decoration: BoxDecoration(
                            //         color: Colors.white,
                            //         borderRadius:
                            //             BorderRadius.all(Radius.circular(16.0))),
                            //     child: Align(
                            //       alignment: Alignment.center,
                            //       child: Padding(
                            //         padding: const EdgeInsets.all(8.0),
                            //         child: Text(
                            //           "Treniņš nenotiek covid-19 dēļ",
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            // Padding(
                            //   padding: const EdgeInsets.all(8.0),
                            //   child: Row(
                            //     children: [
                            //       FittedBox(
                            //         fit: BoxFit.contain,
                            //         child: Container(
                            //           padding: EdgeInsets.all(16.0),
                            //           child: Text("Jaunums!"),
                            //           decoration: BoxDecoration(
                            //               color: Colors.amberAccent,
                            //               borderRadius: BorderRadius.all(
                            //                   Radius.circular(16.0))),
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            // ]),
                            StreamBuilder(
                                stream: postsDataBloc.dataStream,
                                builder: (_, snap) {
                                  if (snap.connectionState ==
                                      ConnectionState.waiting)
                                    return CircularProgressIndicator();

                                  List<Post> dataObjects = snap.data;
                                  if (dataObjects == null) {
                                    return Center(
                                      child: Text(
                                        "No docs",
                                        textAlign: TextAlign.center,
                                      ),
                                    );
                                  }
                                  if (snap.hasData &&
                                      snap.connectionState ==
                                          ConnectionState.active) {
                                    return ListView.builder(
                                      shrinkWrap: true,
                                      itemBuilder: (_, i) {
                                        return Container(
                                            height: 100,
                                            width: 200,
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      dataObjects[i].title,
                                                      style: TextStyle(
                                                          fontSize: 15),
                                                    ),
                                                    IconButton(
                                                        icon: Icon(Icons.delete,
                                                            color: Colors.red),
                                                        onPressed: () {
                                                          setState(() {
                                                            DatabaseService.deletePost(
                                                                title:
                                                                    dataObjects[
                                                                            i]
                                                                        .title);
                                                          });
                                                        })
                                                  ],
                                                ),
                                                Text(dataObjects[i].content)
                                              ],
                                            ));
                                      },
                                      itemCount: dataObjects.length,
                                    );
                                  }
                                  return CircularProgressIndicator();
                                }),
                            RaisedButton(
                              onPressed: () {
                                postsDataBloc.fetchNextSetOfData();
                              },
                              color: Colors.red,
                              child: Text("Load more"),
                            )
                            // StreamBuilder(
                            //     builder: (_, snap) {
                            //       if (snap.hasData &&
                            //           snap.connectionState ==
                            //               ConnectionState.active) {
                            //         var posts = snap.data as QuerySnapshot;
                            //         var postsList = posts.docs
                            //             .map((e) => Post(
                            //                 date: (e.data()['date'] as Timestamp)
                            //                     .toDate(),
                            //                 back: e.data()['background'],
                            //                 image: e.data()['image'],
                            //                 title: e.data()['title'],
                            //                 content: e.data()['content']))
                            //             .toList();
                            //         postsList
                            //             .sort((a, s) => s.date.compareTo(a.date));

                            //         return ListView.builder(
                            //           shrinkWrap: true,
                            //           itemBuilder: (_, i) {
                            //             return Container(
                            //               width: 250,
                            //               height: 150,
                            //               decoration: BoxDecoration(
                            //                   image: DecorationImage(
                            //                       image: NetworkImage(
                            //                           postsList[i].back))),
                            //               child: Column(
                            //                 children: [
                            //                   Text(postsList[i].title),
                            //                   Text(postsList[i].content),
                            //                   SizedBox(
                            //                     height: 10,
                            //                   ),
                            //                   Image.network(
                            //                     postsList[i].image,
                            //                     height: 30,
                            //                     width: 30,
                            //                   )
                            //                 ],
                            //               ),
                            //             );
                            //           },
                            //           itemCount: postsList.length,
                            //         );
                            //       }
                            //       return Text("");
                            //     },
                            //     stream:
                            //         context.read(databaseServiceProvider).getPosts),
                            // Container(
                            //   height: 300,
                            //   child: ListView.builder(
                            //     itemBuilder: (_, i) {
                            //       return ListTile(
                            //         title: Text('item $i'),
                            //       );
                            //     },
                            //     itemExtent: 70,
                            //     controller: scrollController,
                            //     itemCount: news.length,
                            //   ),
                            // )
                          ],
                        ),
                      ),
                    )
                  ]),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xFF6DC0C4),
          child: Icon(
            Icons.edit,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(context,
                new MaterialPageRoute(builder: (context) => AddToFeedPage()));
          },
        ));
  }
}
