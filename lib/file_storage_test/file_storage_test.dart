import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:honey_cook/main.dart';
import 'package:image_picker/image_picker.dart';

class FileStorageTest extends StatefulWidget {
  FileStorageTest({Key? key}) : super(key: key);

  final storageRef = storage.ref();

  @override
  State<StatefulWidget> createState() => _FileStorageTestState();
}

class _FileStorageTestState extends State<FileStorageTest> {
  uploadImage(XFile file) async {
    final motorImageRef = widget.storageRef.child("Dishes/${file.name}.jpg");

    final data = await file.readAsBytes();

    try {
      motorImageRef
          .putData(data,
          SettableMetadata(contentType: "image/jpeg"))
          .snapshotEvents
          .listen((event) {
        switch (event.state) {
          case TaskState.running:
            final progress =
                100.0 * (event.bytesTransferred / event.totalBytes);
            print("Upload is $progress% complete.");
            break;
          case TaskState.success:
            print("Success..");
            break;

          case TaskState.paused:
          // TODO: Handle this case.
            break;
          case TaskState.canceled:
          // TODO: Handle this case.
            break;
          case TaskState.error:
          // TODO: Handle this case.
            break;
        }
      });
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  final ImagePicker _picker = ImagePicker();

  openImagePicker() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      uploadImage(image);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: MaterialButton(
        child: const Text("Upload file"),
        onPressed: () => openImagePicker(),
      ),
    );
  }
}
