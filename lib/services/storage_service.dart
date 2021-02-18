import 'dart:io';

import 'package:darky_app/services/database_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FireStorageService {
  // ignore: unused_element
  FireStorageService._();
  FireStorageService();

  static Future<dynamic> getImageFromFirebaseStorage(
      BuildContext context, String image) async {
    return await FirebaseStorage.instance.ref().child(image).getDownloadURL();
  }

  static Future<String> uploadFeed(
      {String title,
      String content,
      File image,
      File backgroundImage,
      bool notify}) async {
    if (image != null) {
      var fileName = image.uri;
      var backFileName = backgroundImage.uri;

      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child('uploads/feedPhotos/$fileName');
      UploadTask uploadTask = firebaseStorageRef.putFile(image);
      uploadTask.then((taskSnap) {
        if (taskSnap.state == TaskState.success) {
          Reference firebaseStorageRef = FirebaseStorage.instance
              .ref()
              .child('uploads/feedPhotos/$backFileName');
          UploadTask uploadTask = firebaseStorageRef.putFile(backgroundImage);
          uploadTask.then((task) {
            if (task.state == TaskState.success) {
              taskSnap.ref.getDownloadURL().then((link) {
                task.ref.getDownloadURL().then((bgrLink) {
                  DatabaseService.publishPost(
                      content: content,
                      title: title,
                      image: link,
                      backgroundImage: bgrLink);
                });
              });
            }
          });

          if (notify) DatabaseService.notifyAll(message: content, title: title);
        }
      });
    }
    return null;
  }

  static Future uploadAvatarToFirebaseStorage({File uploadMe, String email}) {
    if (uploadMe != null) {
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child('uploads/photos/$email');
      UploadTask uploadTask = firebaseStorageRef.putFile(uploadMe);
      uploadTask.then((taskSnap) {
        if (taskSnap.state == TaskState.success) {
          taskSnap.ref
              .getDownloadURL()
              .then((url) => DatabaseService.setAvatar(email: email, url: url));
        }
      });
    }
    return null;
  }

  //upload video on storage
  static Future<dynamic> uploadVideoToFirebaseStorage(
      {File uploadMe,
      String name,
      bool isYoutubeVid = false,
      String section,
      String youtubeLink,
      int tier,
      String type}) async {
    if (uploadMe != null) {
      //Must have - make null check
      if (!isYoutubeVid) {
        Reference firebaseStorageRef =
            FirebaseStorage.instance.ref().child('uploads/videos/$name');

        UploadTask uploadTask = firebaseStorageRef.putFile(uploadMe);

        uploadTask.then((taskSnap) {
          if (taskSnap.state == TaskState.success) {
            taskSnap.ref.getDownloadURL().then((value) {
              DatabaseService.addVideoLink(
                  url: value,
                  isYoutubeVid: isYoutubeVid,
                  section: section,
                  name: name,
                  tier: tier,
                  type: type);
            });
          }
        });
      }
    } else {
      await DatabaseService.addVideoLink(
          url: youtubeLink,
          isYoutubeVid: isYoutubeVid,
          section: section,
          name: name,
          tier: tier,
          type: type);
    }
  }

  static Future deleteVideoFromFirebaseStorage(String name) async {
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('uploads/videos/$name');
    firebaseStorageRef.delete().then((value) => print("succesfully deleted"));
  }
  // static Future<Iterable<Map<String, Future<String>>>>
  //     getVideosFromFirestorage() async {
  //   //Must have - make null check
  //   List<String> links = List();
  //   Reference firebaseStorageRef =
  //       FirebaseStorage.instance.ref().child('uploads');
  //   var list = await firebaseStorageRef.listAll();
  //   list

  //   // list.items.forEach((ref) async {
  //   //   links.add(await ref.getDownloadURL());
  //   // });

  //   return ok;
  // }

}
