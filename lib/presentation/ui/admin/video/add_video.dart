import 'dart:io';

import 'package:darky_app/presentation/ui/member/tutorial.dart';
import 'package:darky_app/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class AddVideoPage extends StatefulWidget {
  AddVideoPage({Key key}) : super(key: key);

  @override
  _AddVideoPageState createState() => _AddVideoPageState();
}

class _AddVideoPageState extends State<AddVideoPage> {
  bool isYoutubeVid = false;
  final videoName = "Video title";
  final TextEditingController nameController = TextEditingController();
  final TextEditingController yotubeLinkController = TextEditingController();
  String _retrieveDataError;
  VideoPlayerController _videoPlayerController;
  VideoPlayerController _toBeDisposed;
  List<String> sectionList = ['Breaking', 'Hip-Hop', 'Multi group', 'All'];
  static const Map<String, String> sectionFBSectionMap = {
    'Breaking': 'breaking_section',
    'Hip-Hop': 'hiphop_section',
    'Multi group': 'multi_group_section',
    'All': 'All'
  };
  static const Map<String, List<String>> sectionMoveTypes = {
    "breaking_section": [
      'freeze',
      'power-move',
      'power-tricks',
      'top-rock',
      'footwork'
    ],
    'hiphop_section': ['plastic', 'king-tut'],
    'multi_group_section': ['Multi group class'],
    'All': ['all']
  };

  List<int> tierList = List.generate(5, (index) => index);
  String dropDownValue;
  int tierDropDownValue;
  String moveTypeDropDownValue;
  File _videoToUpload; //Upload to firebase storage
  final picker = ImagePicker();

  //Play Video
  Future<void> _playVideo(PickedFile file) async {
    if (file != null && mounted) {
      await _disposeVideoController();
    }
    _videoPlayerController = VideoPlayerController.file(File(file.path));
    await _videoPlayerController.initialize();
    // await _videoPlayerController.setLooping(true);
    await _videoPlayerController.play();
    setState(() {});
  }

  void _onImageButtonPressed(ImageSource source) async {
    if (_videoPlayerController != null) {
      await _videoPlayerController.setVolume(0.0);
    }

    final PickedFile file = await picker.getVideo(
        source: source, maxDuration: const Duration(seconds: 10));
    _videoToUpload = File(file.path);
    await _playVideo(file);
  }

  void _onReplayButtonPressed() {
    if (_videoPlayerController != null) {
      _videoPlayerController.seekTo(Duration.zero);
    }
    return null;
  }

  //Picker

  Future<void> _disposeVideoController() async {
    if (_toBeDisposed != null) {
      await _toBeDisposed.dispose();
    }
    _toBeDisposed = _videoPlayerController;
    _videoPlayerController = null;
  }

  @override
  void initState() {
    dropDownValue = sectionList.first;
    tierDropDownValue = tierList.first;
    isYoutubeVid = false;
    super.initState();
  }

  @override
  void dispose() {
    _disposeVideoController();
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

  Widget _previewVideo() {
    final Text retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) return retrieveError;
    if (_videoPlayerController == null)
      return const Text(
        'You have not picked a video',
        textAlign: TextAlign.center,
      );
    return Padding(
      padding: const EdgeInsets.all(10),
      child: AspectRatioVideo(_videoPlayerController),
    );
  }

  Text _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    moveTypeDropDownValue =
        sectionMoveTypes['${sectionFBSectionMap['$dropDownValue']}'].first;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF6DC0C4),
          title: Text("Add video"),
        ),
        body: Stack(children: <Widget>[
          Container(
            height: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xFF263248),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                isYoutubeVid ? AddYoutubeVid() : _localVideo(),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: isYoutubeVid
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 190,
                              child: TextField(
                                controller: yotubeLinkController,
                                decoration: InputDecoration(
                                    hintText: "enter youtube link"),
                              ),
                            ),
                            _fab(
                                herotag: "uploadVid",
                                icon: Icon(Icons.upload_file),
                                color: Colors.green,
                                onpressed: () {
                                  if (nameController.text.length < 4) {
                                    print("enter name");
                                  } else {
                                    FireStorageService
                                        .uploadVideoToFirebaseStorage(
                                            type: moveTypeDropDownValue,
                                            name: nameController.text,
                                            isYoutubeVid: isYoutubeVid,
                                            youtubeLink:
                                                yotubeLinkController.text,
                                            section: sectionFBSectionMap[
                                                dropDownValue],
                                            tier: tierDropDownValue);
                                  }
                                })
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _fab(
                              herotag: "pickVid",
                              color: Colors.red,
                              icon: Icon(Icons.video_library),
                              onpressed: () {
                                _onImageButtonPressed(ImageSource.gallery);
                              },
                            ),
                            _fab(
                                icon: Icon(Icons.replay),
                                herotag: "replayVid",
                                color: Colors.blue,
                                onpressed: () {
                                  _onReplayButtonPressed();
                                }),
                            _fab(
                                color: Colors.limeAccent,
                                herotag: "playStopVid",
                                icon: Icon(Icons.pause),
                                onpressed: () {
                                  togglePlay();
                                }),
                            _fab(
                                herotag: "uploadVid",
                                icon: Icon(Icons.upload_file),
                                color: Colors.green,
                                onpressed: () {
                                  if (nameController.text.length < 4) {
                                    print("enter name");
                                  } else {
                                    FireStorageService
                                        .uploadVideoToFirebaseStorage(
                                            type: moveTypeDropDownValue,
                                            name: nameController.text,
                                            uploadMe: _videoToUpload,
                                            section: sectionFBSectionMap[
                                                dropDownValue],
                                            tier: tierDropDownValue);
                                  }
                                })
                          ],
                        ),
                ),
                Container(
                  width: 190,
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(hintText: "video/move name"),
                  ),
                ),

                Container(
                  padding: EdgeInsets.all(12),
                  child: Center(
                    child: Text("Set section and tier"),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    DropdownButton(
                        value: dropDownValue,
                        items: sectionList.map<DropdownMenuItem<String>>((val) {
                          return DropdownMenuItem(
                            child: Text(val),
                            value: val,
                          );
                        }).toList(),
                        onChanged: (newVal) {
                          setState(() {
                            dropDownValue = newVal;
                          });
                        }),
                    DropdownButton(
                        value: tierDropDownValue,
                        items: tierList
                            .map<DropdownMenuItem<int>>(
                                (val) => DropdownMenuItem(
                                      child: Text(val.toString()),
                                      value: val,
                                    ))
                            .toList(),
                        onChanged: (newVal) {
                          setState(() {
                            tierDropDownValue = newVal;
                          });
                        })
                  ],
                ),

                DropdownButton(
                    value: moveTypeDropDownValue,
                    items: sectionMoveTypes[
                            '${sectionFBSectionMap['$dropDownValue']}']
                        .map<DropdownMenuItem<String>>(
                            (val) => DropdownMenuItem(
                                  child: Text(val),
                                  value: val,
                                ))
                        .toList(),
                    onChanged: (newVal) {
                      setState(() {
                        moveTypeDropDownValue = newVal;
                      });
                    }),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Video from Youtube",
                      style: TextStyle(fontSize: 15),
                    ),
                    Switch(
                      activeColor: Colors.tealAccent,
                      activeTrackColor: Colors.purple,
                      value: isYoutubeVid,
                      onChanged: (val) {
                        setState(() {
                          isYoutubeVid = val;
                        });
                      },
                    ),
                  ],
                )

                //KAK VARIK SDELATY FIXED NO ETO OTSTOJ
              ],
            ),
          )
        ]));
  }

  _fab({String herotag, Function() onpressed, Icon icon, Color color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: FloatingActionButton(
        heroTag: herotag,
        backgroundColor: color,
        onPressed: onpressed,
        tooltip: 'Upload',
        child: icon,
      ),
    );
  }

  Future<void> retrieveLostData() async {
    final LostData response = await picker.getLostData();
    if (response.isEmpty) return;

    if (response.file != null) {
      if (response.type == RetrieveType.video) {
        await _playVideo(response.file);
      }
    } else
      _retrieveDataError = response.exception.code;
  }

  _localVideo() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          child: Center(
        child: Container(
          height: 196,
          width: MediaQuery.of(context).size.width / 1.2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(16.0),
            ),
            color: Colors.red.shade700,
          ),
          child: Center(
            child: FutureBuilder<void>(
              future: retrieveLostData(),
              builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return const Text(
                      'You have not yet picked an image.',
                      textAlign: TextAlign.center,
                    );
                  case ConnectionState.done:
                    return _previewVideo();
                  default:
                    if (snapshot.hasError) {
                      return Text(
                        'Pick image/video error: ${snapshot.error}}',
                        textAlign: TextAlign.center,
                      );
                    } else {
                      return const Text(
                        'You have not yet picked an image.',
                        textAlign: TextAlign.center,
                      );
                    }
                }
              },
            ),
          ),
        ),
      )),
    );
  }
}

class AddYoutubeVid extends StatefulWidget {
  AddYoutubeVid({Key key}) : super(key: key);

  @override
  _AddYoutubeVidState createState() => _AddYoutubeVidState();
}

class _AddYoutubeVidState extends State<AddYoutubeVid> {
  YoutubePlayerController _controller;
  TextEditingController _idController = TextEditingController();
  TextEditingController _seekToController;
  PlayerState _playerState;

  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;

  final List<String> _ids = [
    'nPt8bK2gbaU',
  ];

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: _ids.first,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(listener);
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
      });
    }
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    _idController.dispose();
    _seekToController.dispose();
    super.dispose();
  }

  Widget _text(String title, String value) {
    return RichText(
      text: TextSpan(
        text: '$title : ',
        style: const TextStyle(
          color: Colors.blueAccent,
          fontWeight: FontWeight.bold,
        ),
        children: [
          TextSpan(
            text: value ?? '',
            style: const TextStyle(
              color: Colors.blueAccent,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStateColor(PlayerState state) {
    switch (state) {
      case PlayerState.unknown:
        return Colors.grey[700];
      case PlayerState.unStarted:
        return Colors.pink;
      case PlayerState.ended:
        return Colors.red;
      case PlayerState.playing:
        return Colors.blueAccent;
      case PlayerState.paused:
        return Colors.orange;
      case PlayerState.buffering:
        return Colors.yellow;
      case PlayerState.cued:
        return Colors.blue[900];
      default:
        return Colors.blue;
    }
  }

  Widget get _space => const SizedBox(height: 10);

  Widget _loadCueButton(String action) {
    return Expanded(
      child: MaterialButton(
        color: Colors.blueAccent,
        onPressed: _isPlayerReady
            ? () {
                if (_idController.text.isNotEmpty) {
                  var id = YoutubePlayer.convertUrlToId(
                    _idController.text,
                  );
                  if (action == 'LOAD') _controller.load(id);
                  if (action == 'CUE') _controller.cue(id);
                  FocusScope.of(context).requestFocus(FocusNode());
                } else {
                  print('Source can\'t be empty!');
                }
              }
            : null,
        disabledColor: Colors.grey,
        disabledTextColor: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0),
          child: Text(
            action,
            style: const TextStyle(
              fontSize: 18.0,
              color: Colors.white,
              fontWeight: FontWeight.w300,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 550,
      child: YoutubePlayerBuilder(
        onExitFullScreen: () {
          // The player forces portraitUp after exiting fullscreen. This overrides the behaviour.
          SystemChrome.setPreferredOrientations(DeviceOrientation.values);
        },
        player: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
          progressIndicatorColor: Colors.blueAccent,
          onReady: () {
            _isPlayerReady = true;
          },
          onEnded: (data) {
            _controller
                .load(_ids[(_ids.indexOf(data.videoId) + 1) % _ids.length]);
            print('Next Video Started!');
          },
        ),
        builder: (context, player) => ListView(
          children: [
            player,
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // _space,
                  // _text('Title', _videoMetaData.title),
                  // _space,
                  // _text('Channel', _videoMetaData.author),
                  // _space,
                  // _text('Video Id', _videoMetaData.videoId),
                  // _space,
                  Row(
                    children: [
                      _text(
                        'Playback Quality',
                        _controller.value.playbackQuality,
                      ),
                      const Spacer(),
                      _text(
                        'Playback Rate',
                        '${_controller.value.playbackRate}x  ',
                      ),
                    ],
                  ),
                  _space,
                  TextField(
                    enabled: _isPlayerReady,
                    controller: _idController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter youtube \<video id\> or \<link\>',
                      fillColor: Colors.blueAccent.withAlpha(20),
                      filled: true,
                      hintStyle: const TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Colors.blueAccent,
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => _idController.clear(),
                      ),
                    ),
                  ),
                  _space,
                  Row(
                    children: [
                      _loadCueButton('LOAD'),
                      const SizedBox(width: 10.0),
                      _loadCueButton('CUE'),
                    ],
                  ),
                  _space,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Icon(
                          _controller.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                        ),
                        onPressed: _isPlayerReady
                            ? () {
                                _controller.value.isPlaying
                                    ? _controller.pause()
                                    : _controller.play();
                                setState(() {});
                              }
                            : null,
                      ),
                      IconButton(
                        icon: Icon(_muted ? Icons.volume_off : Icons.volume_up),
                        onPressed: _isPlayerReady
                            ? () {
                                _muted
                                    ? _controller.unMute()
                                    : _controller.mute();
                                setState(() {
                                  _muted = !_muted;
                                });
                              }
                            : null,
                      ),
                      FullScreenButton(
                        controller: _controller,
                        color: Colors.blueAccent,
                      ),
                    ],
                  ),
                  _space,
                  Row(
                    children: <Widget>[
                      const Text(
                        "Volume",
                        style: TextStyle(fontWeight: FontWeight.w300),
                      ),
                      Expanded(
                        child: Slider(
                          inactiveColor: Colors.transparent,
                          value: _volume,
                          min: 0.0,
                          max: 100.0,
                          divisions: 10,
                          label: '${(_volume).round()}',
                          onChanged: _isPlayerReady
                              ? (value) {
                                  setState(() {
                                    _volume = value;
                                  });
                                  _controller.setVolume(_volume.round());
                                }
                              : null,
                        ),
                      ),
                    ],
                  ),
                  _space,
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 800),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: _getStateColor(_playerState),
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      _playerState.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
