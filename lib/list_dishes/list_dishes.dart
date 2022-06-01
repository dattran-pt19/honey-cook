import 'package:flutter/material.dart';
import 'package:honey_cook/components/search_view.dart';
import 'package:honey_cook/list_dishes/items/dish_item.dart';
import 'package:honey_cook/model/dish_filter_model.dart';
import 'package:honey_cook/model/dish_model.dart';

final List<DishModel> listDemoDish = [
  DishModel(id: 0, name: "Cơm thịt kho", listFilter: [DishFilter.rice]),
  DishModel(id: 0, name: "Salad Nga", listFilter: [DishFilter.vegetable]),
  DishModel(id: 0, name: "Nước dưa hấu", listFilter: [DishFilter.drink]),
  DishModel(
      id: 0,
      name: "Gà nướng tỏi",
      listFilter: [DishFilter.rice, DishFilter.meat]),
  DishModel(
      id: 0,
      name: "Mì xào bò mướp",
      listFilter: [DishFilter.rice, DishFilter.meat, DishFilter.vegetable]),
  DishModel(
      id: 0,
      name: "Sườn xào chua ngọt",
      listFilter: [DishFilter.drink, DishFilter.meat])
];

class ListDishesView extends StatefulWidget {
  const ListDishesView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ListDishesViewState();
  }
}

class _ListDishesViewState extends State<ListDishesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Danh sách món ăn",
            style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            SearchView(),
            Expanded(
                child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: listDemoDish.length,
                itemBuilder: (context, index) {
                  return DishItem(model: listDemoDish[index]);
                }),
              flex: 1,
            )
          ],
        ),
      ),
    );
  }
}
