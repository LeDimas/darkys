import 'dart:io';

import 'package:darky_app/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddToFeedPage extends StatefulWidget {
  const AddToFeedPage({Key key}) : super(key: key);

  @override
  _AddToFeedPageState createState() => _AddToFeedPageState();
}

class _AddToFeedPageState extends State<AddToFeedPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  String _imageFile;
  String _imageFileBackground;
  bool notify = false;

  void _onImageButtonPressed(ImageSource source, BuildContext context) async {
    final pickedFile = await _picker.getImage(
      source: source,
    );

    if (pickedFile != null) {
      _imageFile = pickedFile.path;
      setState(() {});
      // FireStorageService.uploadAvatarToFirebaseStorage(
      //     uploadMe: _imageFile,
      //     email: context.read(authenticationServiceProvider).currentUserEmail);
    }
  }

  void _onBackgroundImageButtonPressed(
      ImageSource source, BuildContext context) async {
    final pickedFile = await _picker.getImage(
      source: source,
    );

    if (pickedFile != null) {
      _imageFileBackground = pickedFile.path;
      setState(() {});
      // FireStorageService.uploadAvatarToFirebaseStorage(
      //     uploadMe: _imageFile,
      //     email: context.read(authenticationServiceProvider).currentUserEmail);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
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
                        physics: AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(
                          vertical: 48.0,
                        ),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextField(
                                controller: titleController,
                                decoration:
                                    InputDecoration(hintText: "title name"),
                              ),
                              TextField(
                                controller: contentController,
                                decoration:
                                    InputDecoration(hintText: "content"),
                              ),
                              RaisedButton(
                                onPressed: () {
                                  _onImageButtonPressed(
                                      ImageSource.gallery, context);
                                },
                                color: Colors.red,
                                child: Text('add picture for ????'),
                              ),
                              RaisedButton(
                                onPressed: () {
                                  _onBackgroundImageButtonPressed(
                                      ImageSource.gallery, context);
                                },
                                color: Colors.blue,
                                child: Text('add backgroundpicture for post'),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Notify about this post"),
                                  Checkbox(
                                      value: notify,
                                      onChanged: (val) {
                                        setState(() {
                                          notify = val;
                                        });
                                      })
                                ],
                              ),
                              _imageFile == null
                                  ? Text('')
                                  : Image.file(
                                      File(_imageFile),
                                      height: 100,
                                      width: 100,
                                    ),
                              _imageFileBackground == null
                                  ? Text('')
                                  : Image.file(
                                      File(_imageFileBackground),
                                      height: 100,
                                      width: 100,
                                    ),
                              RaisedButton(
                                onPressed: () {
                                  FireStorageService.uploadFeed(
                                      notify: notify,
                                      title: titleController.text,
                                      content: contentController.text,
                                      image: File(_imageFile),
                                      backgroundImage: File(
                                        _imageFileBackground,
                                      ));
                                  contentController.clear();
                                  titleController.clear();
                                },
                                color: Colors.blue,
                                child: Text('make a post'),
                              ),
                            ]))))));
  }
}
