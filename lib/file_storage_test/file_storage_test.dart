import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class FileStorageTest extends StatefulWidget {
  FileStorageTest({Key? key}) : super(key: key);

  final storageRef = FirebaseStorage.instance.ref();

  @override
  State<StatefulWidget> createState() => _FileStorageTestState();
}

class _FileStorageTestState extends State<FileStorageTest> {
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: MaterialButton(
        child: const Text("Upload file"),
        onPressed: () async {
          final motorRef = widget.storageRef.child("motor.jpg");
          final motorImageRef = widget.storageRef.child("Dishes/motor.jpg");
          Directory appDocDir = await getApplicationDocumentsDirectory();
          String pathFile = '${appDocDir.absolute}/motor.jpg';
          File file = File(pathFile);

          try {
            await motorRef.putFile(file);
          } on FirebaseException catch (e) {
            //...
          }
        },
      ),
    );
  }
}