import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_observer/Observable.dart';
import 'package:flutter_observer/Observer.dart';
import 'package:honey_cook/base/singleton.dart';

import '../base/constants.dart';

class ListSelectedDishes extends StatefulWidget {
  const ListSelectedDishes({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ListSelectedDishesState();
  }
}

class _ListSelectedDishesState extends State<ListSelectedDishes> with Observer {
  _eatDishes() async {
    await listDishesRef.update({
      dbListDishes: FieldValue.arrayRemove(
          listSelectedDishes.map((e) => e.dish.toFirestore()).toList())
    }).whenComplete(() {
      for (var element in listSelectedDishes) {
        element.dish.eatenNumber = (element.dish.eatenNumber ?? 0) + element.count;
      }
    });
    await listDishesRef.update({
      dbListDishes: FieldValue.arrayUnion(
          listSelectedDishes.map((e) => e.dish.toFirestore()).toList())
    });
    listSelectedDishes.clear();
    Observable.instance.notifyObservers([], notifyName: observableChangeSelectedDishes);
    Observable.instance.notifyObservers([], notifyName: observableSuccessCreate);
  }

  @override
  initState() {
    Observable.instance.addObserver(this);
    super.initState();
  }

  @override
  dispose() {
    Observable.instance.removeObserver(this);
    super.dispose();
  }

  @override
  update(Observable observable, String? notifyName, Map? map) {
    if (notifyName == observableChangeSelectedDishes) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Danh sách muốn ăn"),
        centerTitle: true,
      ),
      body: Container(
        margin: const EdgeInsets.only(bottom: 48),
        child: Column(
          children: [
            Expanded(
              child: listSelectedDishes.isEmpty
                  ? const Center(child: Text("Chưa chọn món nào"))
                  : ListView.builder(
                  padding: const EdgeInsets.only(top: 8, bottom: 24),
                  scrollDirection: Axis.vertical,
                  itemCount: listSelectedDishes.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      width: double.infinity,
                      child: Row(
                        children: [
                          Text("(${listSelectedDishes[index].count})",
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                          const SizedBox(width: 12),
                          Text(listSelectedDishes[index].dish.name ?? "",
                              style: const TextStyle(fontSize: 16))
                        ],
                      ),
                    );
                  }),
              flex: 1,
            ),
            ElevatedButton(
                onPressed: _eatDishes,
                child: const Text("Yêu cầu nấu")
            )
          ],
        ),
      ),
    );
  }


}