import 'package:chewie/chewie.dart';
import 'package:darky_app/models/consts.dart';

import 'package:darky_app/presentation/ui/admin/video/add_video.dart';
import 'package:darky_app/presentation/ui/admin/video/certain_video_tut.dart';
import 'package:darky_app/services/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:darky_app/presentation/widgets/fancy_fab.dart';

import 'package:darky_app/services/database_service.dart';

import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class TutorialPage extends StatefulWidget {
  final String role;

  const TutorialPage({Key key, this.role}) : super(key: key);
  @override
  _TutorialPageState createState() => _TutorialPageState();
}

class _TutorialPageState extends State<TutorialPage> {
  final videoName = "Video title";
  List<String> links = List();
  String sectionFilter;
  int tierFilter;

  VideoPlayerController _videoPlayerController;

  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // _disposeVideoController();
    super.dispose();
  }

  void togglePlay() {
    if (_videoPlayerController != null) {
      if (_videoPlayerController.value.isPlaying) {
        _videoPlayerController.setVolume(0);
        _videoPlayerController.pause();
      } else {
        _videoPlayerController.setVolume(10);
        _videoPlayerController.play();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          shadowColor: Colors.transparent,
          backgroundColor: Color(0xFF6DC0C4),
          title: Text("Tutorial Screen"),
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color(0xFF263248),
          ),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Center(
                  child: Text(
                    "Pamācību Video",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              this.widget.role == "admin" || this.widget.role == "coach"
                  ? FutureBuilder(
                      future: DatabaseService.getVideos(sectionFilter),
                      builder: (_, snap) {
                        if (snap.hasData &&
                            snap.connectionState == ConnectionState.done) {
                          var nameLinkTierMapList =
                              snap.data as List<Map<String, dynamic>>;
                          if (tierFilter != null) {
                            nameLinkTierMapList.retainWhere(
                                (map) => tierFilter == map['tier']);
                          }
                          return Expanded(
                            child: Column(
                              children: [
                                //otdelno filtrovanie dlya mema zamutity
                                Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: _sectionFilterRowButtons()),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      _tierFilterRowButtons(),
                                    ]),
                                Expanded(
                                    child: ListView.builder(
                                        itemCount: nameLinkTierMapList.length,
                                        itemBuilder: (_, i) {
                                          return InkWell(
                                            onTap: () {
                                              if (mounted) {
                                                Navigator.push(
                                                    context,
                                                    new MaterialPageRoute(
                                                        builder: (context) =>
                                                            CertainVideoTut(
                                                              isYoutube:
                                                                  nameLinkTierMapList[
                                                                          i][
                                                                      'youtube'],
                                                              name:
                                                                  nameLinkTierMapList[
                                                                          i]
                                                                      ['name'],
                                                              link:
                                                                  nameLinkTierMapList[
                                                                          i]
                                                                      ['link'],
                                                            )));
                                              }
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(24.0),
                                              child: Container(
                                                height: 200,
                                                width: 150,
                                                decoration: BoxDecoration(
                                                    color: Colors.amber,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10))),
                                                child: Center(
                                                  child: Text(
                                                    nameLinkTierMapList[i]
                                                        ['name'],
                                                    style: TextStyle(
                                                        fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        })),
                              ],
                            ),
                          );
                        }
                        return CircularProgressIndicator();
                      },
                    )
                  : StreamBuilder<Object>(
                      stream: DatabaseService.getMemberSectionsStream(context
                          .read(authenticationServiceProvider)
                          .currentUserEmail),
                      builder: (context, snapshot) {
                        if (snapshot.hasData &&
                            snapshot.connectionState ==
                                ConnectionState.active) {
                          var sections = snapshot.data as List;
                          sections.add('All');
                          return Expanded(
                            child: Column(
                              children: [
                                Container(
                                  height: 20,
                                  padding: EdgeInsets.only(
                                      left: (sections.length / 0.05)),
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (_, i) {
                                      return RaisedButton(
                                        onPressed: () {
                                          setState(() {
                                            if (sections[i] != 'All') {
                                              sectionFilter = sections[i];
                                            } else {
                                              sectionFilter = null;
                                            }
                                          });
                                        },
                                        color: Colors.cyan,
                                        child: Text(sections[i] == 'All'
                                            ? 'All'
                                            : btnSectionFilterMap[sections[i]]),
                                      );
                                    },
                                    itemCount: sections.length,
                                  ),
                                ),
                                FutureBuilder(
                                  future: DatabaseService.getMemberVideos(
                                      context
                                          .read(authenticationServiceProvider)
                                          .currentUserEmail,
                                      membSec: sectionFilter),
                                  builder: (_, snap) {
                                    if (snap.hasData &&
                                        snap.connectionState ==
                                            ConnectionState.done) {
                                      var nameLinkTierMapList = snap.data
                                          as List<Map<String, dynamic>>;
                                      // if (tierFilter != null) {
                                      //   nameLinkTierMapList.retainWhere((map) =>
                                      //       tierFilter == int.tryParse(map['tier']));
                                      // }
                                      return Expanded(
                                          child: ListView.builder(
                                              itemCount:
                                                  nameLinkTierMapList.length,
                                              itemBuilder: (_, i) {
                                                return InkWell(
                                                  onTap: () {
                                                    if (mounted) {
                                                      Navigator.push(
                                                          context,
                                                          new MaterialPageRoute(
                                                              builder: (context) =>
                                                                  CertainVideoTut(
                                                                    isYoutube:
                                                                        nameLinkTierMapList[i]
                                                                            [
                                                                            'youtube'],
                                                                    name: nameLinkTierMapList[
                                                                            i][
                                                                        'name'],
                                                                    link: nameLinkTierMapList[
                                                                            i][
                                                                        'link'],
                                                                  )));
                                                    }
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            24.0),
                                                    child: Container(
                                                      height: 200,
                                                      width: 150,
                                                      decoration: BoxDecoration(
                                                          color: Colors.amber,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10))),
                                                      child: Center(
                                                        child: Text(
                                                          nameLinkTierMapList[i]
                                                              ['name'],
                                                          style: TextStyle(
                                                              fontSize: 24,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }));
                                    }
                                    return CircularProgressIndicator();
                                  },
                                ),
                              ],
                            ),
                          );
                        }
                        return SizedBox(
                          height: 100,
                          width: 100,
                        );
                      })
            ],
          ),
        ),
        floatingActionButton: widget.role == 'coach' || widget.role == "admin"
            ? FancyFab(
                heroTag: "fncyBtn1",
                heroTagAdd: "btnAdd1",
                heroTagGallery: "btnGlry1",
                heroTagInbox: "btnInbx1",
                onAddPressed: () async {
                  if (mounted) {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => AddVideoPage()));
                  }
                },
                onGalleryPressed: () {})
            : null);
  }

  _sectionFilterRowButtons() {
    return Row(
      children: [
        RaisedButton(
          onPressed: () {
            setState(() {
              sectionFilter = "";
            });
          },
          child: Text("all"),
          color: Colors.amber[50],
        ),
        RaisedButton(
          onPressed: () {
            setState(() {
              sectionFilter = "breaking_section";
            });
          },
          child: Text("Breaking"),
          color: Colors.amber[50],
        ),
        RaisedButton(
          onPressed: () {
            setState(() {
              sectionFilter = "hiphop_section";
            });
          },
          child: Text("Hip-Hop"),
          color: Colors.amber[50],
        ),
        RaisedButton(
          onPressed: () {
            setState(() {
              sectionFilter = "multi_group_section";
            });
          },
          child: Text("Multi-group"),
          color: Colors.amber[50],
        )
      ],
    );
  }

  _tierFilterRowButtons() {
    return ButtonTheme(
      minWidth: 20,
      height: 10,
      child: ButtonBar(
        alignment: MainAxisAlignment.center,
        children: [
          RaisedButton(
            onPressed: () {
              setState(() {
                tierFilter = 0;
              });
            },
            child: Text("0"),
            color: Colors.amber[50],
          ),
          RaisedButton(
            onPressed: () {
              setState(() {
                tierFilter = 1;
              });
            },
            child: Text("1"),
            color: Colors.amber[50],
          ),
          RaisedButton(
            onPressed: () {
              setState(() {
                tierFilter = 2;
              });
            },
            child: Text("2"),
            color: Colors.amber[50],
          ),
          RaisedButton(
            onPressed: () {
              setState(() {
                tierFilter = 3;
              });
            },
            child: Text("3"),
            color: Colors.amber[50],
          ),
          RaisedButton(
            onPressed: () {
              setState(() {
                tierFilter = null;
              });
            },
            child: Text("All"),
            color: Colors.amber[50],
          )
        ],
      ),
    );
  }
}

class AspectRatioVideo extends StatefulWidget {
  AspectRatioVideo(this.controller);

  final VideoPlayerController controller;

  @override
  AspectRatioVideoState createState() => AspectRatioVideoState();
}

class AspectRatioVideoState extends State<AspectRatioVideo> {
  VideoPlayerController get controller => widget.controller;
  bool initialized = false;

  void _onVideoControllerUpdate() {
    if (!mounted) {
      return;
    }
    if (initialized != controller.value.initialized) {
      initialized = controller.value.initialized;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    controller.addListener(_onVideoControllerUpdate);
  }

  @override
  void dispose() {
    controller.removeListener(_onVideoControllerUpdate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (initialized) {
      return Center(
        child: AspectRatio(
          aspectRatio: controller.value?.aspectRatio,
          child: VideoPlayer(controller),
        ),
      );
    } else {
      return Container();
    }
  }
}

class ChewieVideo extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const ChewieVideo({this.title = 'Chewie Demo'});

  final String title;

  @override
  State<StatefulWidget> createState() {
    return _ChewieVideoState();
  }
}

class _ChewieVideoState extends State<ChewieVideo> {
  VideoPlayerController _videoPlayerController1;

  ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    // initializePlayer();
  }

  @override
  void dispose() {
    _videoPlayerController1.dispose();

    _chewieController.dispose();
    super.dispose();
  }

  Future<void> initializePlayer() async {
    _videoPlayerController1 = VideoPlayerController.network(
        '      https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4');
    await _videoPlayerController1.initialize();

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController1,
      autoPlay: true,
      looping: true,
      // Try playing around with some of these other options:

      // showControls: false,
      // materialProgressColors: ChewieProgressColors(
      //   playedColor: Colors.red,
      //   handleColor: Colors.blue,
      //   backgroundColor: Colors.grey,
      //   bufferedColor: Colors.lightGreen,
      // ),
      // placeholder: Container(
      //   color: Colors.grey,
      // ),
      // autoInitialize: true,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: 3 > 2
            // _chewieController != null &&
            //         _chewieController.videoPlayerController.value.initialized
            ? Text("ok")
            // Chewie(
            //     controller: _chewieController,
            //   )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text('Loading'),
                ],
              ),
      ),
    );
    // FlatButton(
    //   onPressed: () {
    //     _chewieController.enterFullScreen();
    //   },
    //   child: const Text('Fullscreen'),
    // ),
    // Row(
    //   children: <Widget>[
    //     Expanded(
    //       child: FlatButton(
    //         onPressed: () {
    //           setState(() {
    //             _chewieController.dispose();
    //             _videoPlayerController1.pause();
    //             _videoPlayerController1.seekTo(const Duration());
    //             _chewieController = ChewieController(
    //               videoPlayerController: _videoPlayerController1,
    //               autoPlay: true,
    //               looping: true,
    //             );
    //           });
    //         },
    //         child: const Padding(
    //           padding: EdgeInsets.symmetric(vertical: 16.0),
    //           child: Text("Landscape Video"),
    //         ),
    //       ),
    //     ),
    //   ],
    // ),
    // Row(
    //   children: <Widget>[
    //     Expanded(
    //       child: FlatButton(
    //         onPressed: () {
    //           setState(() {
    //             _platform = TargetPlatform.android;
    //           });
    //         },
    //         child: const Padding(
    //           padding: EdgeInsets.symmetric(vertical: 16.0),
    //           child: Text("Android controls"),
    //         ),
    //       ),
    //     ),
    //     Expanded(
    //       child: FlatButton(
    //         onPressed: () {
    //           setState(() {
    //             _platform = TargetPlatform.iOS;
    //           });
    //         },
    //         child: const Padding(
    //           padding: EdgeInsets.symmetric(vertical: 16.0),
    //           child: Text("iOS controls"),
    //         ),
    //       ),
    //     )
    //   ],
    // )
  }
}
