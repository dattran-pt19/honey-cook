import 'package:flutter/material.dart';
import 'package:flutter_observer/Observable.dart';
import 'package:flutter_observer/Observer.dart';
import 'package:honey_cook/base/constants.dart';
import 'package:honey_cook/tab1_list_dishes/items/dish_item.dart';
import '../base/singleton.dart';
import '../model/dish_model.dart';

class ListDishesView extends StatefulWidget {
  const ListDishesView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ListDishesViewState();
  }
}

class _ListDishesViewState extends State<ListDishesView> with Observer {
  var isLoaded = false;
  List<DishModel> listDishes = [];
  List<DishModel> listFilterDishes = [];

  final TextEditingController _textController = TextEditingController();

  @override
  initState() {
    Observable.instance.addObserver(this);
    super.initState();
    getData();
  }

  @override
  dispose() {
    Observable.instance.removeObserver(this);
    super.dispose();
  }

  @override
  update(Observable observable, String? notifyName, Map? map) {
    if (notifyName == observableSuccessCreate) {
      getData();
    }
  }

  updateList(List<DishModel> list) {
    listDishes = list;
    listDishes.sort((p1, p2) => ((p1.id ?? 0).compareTo(p2.id ?? 0)));
    listFilterDishes = listDishes;
  }

  getData() async {
    _textController.clear();
    await listDishesRef.get().then((value) {
      try {
        final data = (value.data() as Map<String, dynamic>)[dbListDishes]
            as List<dynamic>;
        updateList(data.map((value) {
          return DishModel.fromJson(value);
        }).toList());
      } catch (e) {
        debugPrint("Error get doc ${e.toString()}");
        updateList([]);
      }
    }, onError: (e) {
      debugPrint("Error get doc ref -- ${e.toString()}");
      updateList([]);
    });
    setState(() {
      isLoaded = true;
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
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              buildSearch(),
              Expanded(
                child: Visibility(
                  visible: isLoaded,
                  child: listFilterDishes.isEmpty
                      ? const Center(child: Text("Không có món ăn nào"))
                      : ListView.builder(
                          padding: const EdgeInsets.only(bottom: 24),
                          scrollDirection: Axis.vertical,
                          itemCount: listFilterDishes.length,
                          itemBuilder: (context, index) {
                            return DishItem(
                              model: listFilterDishes[index],
                              onClickCell: () {
                                if (listSelectedDishes.map((e) => e.getId()).contains(listFilterDishes[index].id)) {
                                  listSelectedDishes.firstWhere((element) => element.getId() == listFilterDishes[index].id).increase();
                                } else {
                                  listSelectedDishes.add(SelectedDishModel(dish: listFilterDishes[index]));
                                }
                                Observable.instance.notifyObservers([], notifyName: observableChangeSelectedDishes);
                              },
                            );
                          }),
                  replacement: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                flex: 1,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSearch() => Container(
        height: 60,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        color: Colors.white,
        child: TextFormField(
          decoration: const InputDecoration(
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black26, width: 0.5),
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              labelText: "Nhập tên món"),
          onChanged: (value) {
            listFilterDishes = listDishes.where((element) {
              return element.name
                      ?.toLowerCase()
                      .contains(value.toLowerCase()) ==
                  true;
            }).toList();
            setState(() {});
          },
        ),
      );
}
