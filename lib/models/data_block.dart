import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class Databloc<T> {
  T dataType;
  Query query;
  int numberToLoadAtATime;
  int numberToLoadFromNextTime;
  Function documentSnapshotToT;
  bool showIndicator = false;
  DocumentSnapshot lastFetchedSnapshot;
  List<T> objectList;
  BehaviorSubject<List<T>> blocController;
  BehaviorSubject<bool> showIndicatorController;

  Databloc(
      {@required this.query,
      @required this.documentSnapshotToT,
      this.numberToLoadAtATime = 5,
      this.numberToLoadFromNextTime = 10}) {
    objectList = [];

    blocController = BehaviorSubject<List<T>>();
    showIndicatorController = BehaviorSubject<bool>();
  }

  Future<void> fetchNextSetOfData() async {
    try {
      updateIndicator(true);
      List<DocumentSnapshot> newDocumentList = (await query
              .startAfterDocument(lastFetchedSnapshot)
              .limit(numberToLoadFromNextTime)
              .get())
          .docs;
      if (newDocumentList.length != 0) {
        lastFetchedSnapshot = newDocumentList[newDocumentList.length - 1];
        newDocumentList.forEach((doc) {
          objectList.add(documentSnapshotToT(doc));
        });
        blocController.sink.add(objectList);
      }
    } on SocketException {
      blocController.sink.addError(SocketException("No internet connection"));
    } catch (e) {
      blocController.sink.addError(e);
    }
  }

  updateIndicator(bool value) async {
    showIndicator = value;
    showIndicatorController.sink.add(value);
  }

  void dispose() {
    blocController.close();
    showIndicatorController.close();
  }

  Stream get getShowIndicatorStream => showIndicatorController.stream;
  Stream<List<T>> get dataStream => blocController.stream;
  Future fetchInitialData() async {
    try {
      List<DocumentSnapshot> documents =
          (await query.limit(numberToLoadAtATime).get()).docs;
      try {
        if (documents.length == 0) {
          blocController.sink.addError("No data available");
        } else {
          lastFetchedSnapshot = documents[documents.length - 1];
        }
      } catch (e) {} //mmmmmmmmmmmm
      //Convert docuemnt snapshots to custom object
      documents.forEach((doc) {
        objectList.add(documentSnapshotToT(doc));
        blocController.sink.add(objectList);
      });
    } on SocketException {
      blocController.sink.addError(SocketException("No internet connection"));
    } catch (e) {
      blocController.sink.addError(e);
    }
  }
}
