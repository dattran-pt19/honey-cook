import 'package:flutter/material.dart';
import 'package:honey_cook/components/search_view.dart';

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
        title: const Text("Danh sách món ăn", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: const [
            SearchView()
          ],
        ),
      ),
    );
  }
}