import 'package:flutter/material.dart';
import 'package:honey_cook/components/search_view.dart';
import 'package:honey_cook/list_dishes/items/dish_item.dart';
import 'package:honey_cook/main.dart';
import '../model/dish_model.dart';

class ListDishesView extends StatefulWidget {
  const ListDishesView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ListDishesViewState();
  }
}

class _ListDishesViewState extends State<ListDishesView> {
  var isLoaded = false;
  List<DishModel> listDishes = [];
  final dishesRef = db.collection("dishes").doc("dattran-dishes");

  @override
  initState() {
    super.initState();
    getData();
  }
  
  getData() async {
    dishesRef.get().then((value) {
      try {
        final data = (value.data() as Map<String,
            dynamic>)["listDishes"] as List<dynamic>;
        listDishes = data.map((value) {
          return DishModel.fromJson(value);
        }).toList();
      } catch(e) {
        debugPrint("Error get doc ${e.toString()}");
        listDishes = [];
      }
    },
    onError: (e) {
      debugPrint("Error get doc ref -- ${e.toString()}");
      listDishes = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Danh sách món ăn"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            const SearchView(),
            Expanded(
              child: listDishes.isEmpty
                  ? const Center(child: Text("Không có món ăn nào"))
                  : ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: listDishes.length,
                      itemBuilder: (context, index) {
                        return DishItem(model: listDishes[index]);
                      }),
              flex: 1,
            )
          ],
        ),
      ),
    );
  }
}
