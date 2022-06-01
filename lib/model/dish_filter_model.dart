import 'package:flutter/material.dart';

class DishFilterModel {
  int id;
  String name;
  String? description;
  IconData icon;

  DishFilterModel({required this.id, required this.name, required this.icon});
}

class DishFilter {
  static final DishFilterModel rice = DishFilterModel(id: 0, name: "Cơm", icon: Icons.workspaces_filled);
  static final DishFilterModel vegetable = DishFilterModel(id: 0, name: "Salad", icon: Icons.nature);
  static final DishFilterModel drink = DishFilterModel(id: 0, name: "Đồ uống", icon: Icons.local_drink);
  static final DishFilterModel meat = DishFilterModel(id: 0, name: "Thịt", icon: Icons.fastfood);
}