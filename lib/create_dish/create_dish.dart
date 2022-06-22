import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_observer/Observable.dart';
import 'package:honey_cook/base/constants.dart';
import 'package:honey_cook/model/dish_model.dart';
import 'package:image_picker/image_picker.dart';

import '../base/singleton.dart';

class CreateDish extends StatefulWidget {
  const CreateDish({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CreateDishState();
  }
}

class _CreateDishState extends State<CreateDish> with TickerProviderStateMixin {
  final DishModel model = DishModel();
  final _formKey = GlobalKey<FormState>();
  bool isLoaded = false;
  late AnimationController indicatorController;

  final ImagePicker _picker = ImagePicker();
  XFile? image;

  @override
  initState() {
    super.initState();
    indicatorController = AnimationController(
      vsync: this,
    )..addListener(() {
        setState(() {});
      });
  }

  @override
  dispose() {
    indicatorController.dispose();
    super.dispose();
  }

  void _openImagePicker() async {
    try {
      image = await _picker.pickImage(
          source: ImageSource.gallery, imageQuality: 40);
    } on PlatformException catch (e, stackTrace) {
      debugPrint('$e $stackTrace');
    }
    if (image != null) {
      setState(() {
        isLoaded = false;
      });
      uploadImage(image!);
    }
  }

  uploadImage(XFile file) async {
    final imageName = DateTime.now().toString();
    final motorImageRef =
        storage.ref().child("$storageDishes/dattran_$imageName}.jpg");

    final data = await file.readAsBytes();

    try {
      motorImageRef
          .putData(data, SettableMetadata(contentType: "image/jpeg"))
          .snapshotEvents
          .listen((event) async {
        switch (event.state) {
          case TaskState.running:
            final progress =
                100.0 * (event.bytesTransferred / event.totalBytes);
            indicatorController.value = progress;
            break;
          case TaskState.success:
            setState(() {
              isLoaded = true;
            });
            final downloadLink = await motorImageRef.getDownloadURL();
            model.image = downloadLink;
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

  addDish() async {
    await listDishesRef.get().then((value) {
      try {
        model.id = (value.data() as Map<String, dynamic>)[dbCurrentId] as int;
      } catch (e) {
        debugPrint("Error get doc ${e.toString()}");
        model.id = null;
      }
    });
    if (model.id != null) {
      model.id = model.id! + 1;
      listDishesRef.update({
        dbCurrentId: model.id,
        dbListDishes: FieldValue.arrayUnion([model.toFirestore()])
      }).whenComplete(() {
        Observable.instance
            .notifyObservers([], notifyName: observableSuccessCreate);
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildMainView();
  }

  Widget buildMainView() => Scaffold(
        appBar: AppBar(
          title: const Text("Thêm món ăn"),
          centerTitle: true,
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: ListView(
            children: [
              buildAddImage(),
              Container(
                padding: const EdgeInsets.all(16),
                child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      children: [
                        buildForm("Tên món", (value) {
                          if (value?.isEmpty == true) {
                            return "Không được bỏ trống tên món";
                          } else {
                            return null;
                          }
                        }, (value) {
                          model.name = value;
                        }),
                        spacing(),
                        buildForm("Ghi chú", (value) {
                          return null;
                        }, (value) {
                          model.description = value;
                        }),
                        spacing(),
                        buildAddButton()
                      ],
                    )),
              )
            ],
          ),
        ),
      );

  Widget buildAddImage() => Container(
        margin: const EdgeInsets.only(left: 16, top: 16, right: 16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue)),
        width: double.infinity,
        height: 200,
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Visibility(
              visible: image == null,
              child: Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue)),
                child: TextButton(
                  child: const Text("Tải ảnh lên"),
                  onPressed: _openImagePicker,
                ),
              ),
            ),
            Visibility(
                visible: image != null,
                child: image != null
                    ? Opacity(
                        opacity: isLoaded ? 1 : 0.7,
                        child: Image.file(
                          File(image!.path),
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Container()),
            Visibility(
                visible: image != null && !isLoaded,
                child: LinearProgressIndicator(
                  value: indicatorController.value,
                ))
          ],
        ),
      );

  Widget spacing() => const SizedBox(height: 16);

  Widget buildForm(String text, FormFieldValidator<String?> validator,
          ValueChanged<String> onValueChange) =>
      TextFormField(
        decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            labelText: text,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
        onChanged: onValueChange,
        validator: validator,
      );

  Widget buildAddButton() => ElevatedButton(
      child: const Text("Thêm món ăn"),
      onPressed: () {
        FocusScope.of(context).unfocus();
        final isValid = _formKey.currentState?.validate();
        if (isValid == true) {
          addDish();
        }
      });
}
