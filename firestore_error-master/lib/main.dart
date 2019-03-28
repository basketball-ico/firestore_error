import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  final FirebaseApp app = await FirebaseApp.configure(
    name: 'test',
    options: const FirebaseOptions(
      googleAppID: '1:79601577497:ios:5f2bcc6ba8cecddd',
      gcmSenderID: '79601577497',
      apiKey: 'AIzaSyArgmRGfB5kiQT6CunAOmKRVKEsxKmy6YI-G72PVU',
      projectID: 'flutter-firestore',
    ),
  );
  final Firestore firestore = Firestore(app: app);
  await firestore.settings(timestampsInSnapshotsEnabled: true);

  final repository = Repository(firestore);

  // Subscription that need to show the initial data
  (await repository.numberOfMessagesStream).listen((numberOfMessages) {
    print('Main subscription: $numberOfMessages');
  });

  // TODO: why?
  // TODO: comment the next line, and make hot restart to see the subscription initial data in console
  await repository.numberOfMessages;

  runApp(MaterialApp(home: Container()));
}

class Repository {
  Firestore firestore;
  Repository(this.firestore);

  Future<Stream<int>> get numberOfMessagesStream async {
    return firestore
        .collection('messages')
        .snapshots()
        .map((messages) => messages.documents.length);
  }

  Future<int> get numberOfMessages async {
    return (await firestore.collection('messages').getDocuments())
        .documents
        .length;
  }
}
