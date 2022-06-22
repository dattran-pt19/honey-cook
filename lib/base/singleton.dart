import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:honey_cook/model/dish_model.dart';

import 'constants.dart';

final storage = FirebaseStorage.instance;
final db = FirebaseFirestore.instance;
final listDishesRef = db.collection(dbDishesCol).doc(dbDishesDoc);

List<SelectedDishModel> listSelectedDishes = [];