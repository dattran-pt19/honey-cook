import 'package:flutter/material.dart';
import 'package:honey_cook/model/dish_model.dart';

class CreateDish extends StatefulWidget {
  const CreateDish({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CreateDishState();
  }
}

class _CreateDishState extends State<CreateDish> {
  final DishModel model = DishModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thêm món ăn"),
        centerTitle: true,
      ),
      body: Wrap(
        direction: Axis.vertical,
        spacing: 16,
        children: [
          Container(
            width: double.infinity,
            height: 200,
            child: Stack(
              alignment: AlignmentDirectional.center,
              fit: StackFit.expand,
              children: [

              ],
            ),
          )
        ],
      ),
    );
  }

}