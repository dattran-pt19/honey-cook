import 'package:cloud_firestore/cloud_firestore.dart';

class DishModel {
  int? id;
  String? image;
  String? name;
  String? description;
  bool? love = false;
  int? eatenNumber = 0;
  String? recipe;

  DishModel({
    this.id, this.image,
    this.name, this.description,
    this.love, this.eatenNumber,
    this.recipe
  });

  factory DishModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    return DishModel(
        id: data?['id'],
        name: data?['name'],
        image: data?['image'],
        description: data?['description'],
        love: data?['love'],
        eatenNumber: data?['eatenNumber'],
        recipe: data?['recipe']
    );
  }

  factory DishModel.fromJson(
      Map<String, dynamic> json) {
    final data = json;
    return DishModel(
        id: data['id'],
        name: data['name'],
        image: data['image'],
        description: data['description'],
        love: data['love'],
        eatenNumber: data['eatenNumber'],
        recipe: data['recipe']
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "id": id,
      "name": name,
      "image": image,
      "description": description,
      "love": love,
      "eatenNumber": eatenNumber,
      "recipe": recipe
    };
  }
}

class SelectedDishModel {
  SelectedDishModel({ required this.dish });

  int count = 1;
  DishModel dish;

  getId() => dish.id ?? 0;

  increase() {
    count += 1;
  }
}