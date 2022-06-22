import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_observer/Observable.dart';
import 'package:flutter_observer/Observer.dart';
import 'package:honey_cook/base/constants.dart';
import 'package:honey_cook/base/singleton.dart';
import 'package:honey_cook/create_dish/create_dish.dart';
import 'package:honey_cook/firebase_options.dart';
import 'package:honey_cook/tab1_list_dishes/list_dishes.dart';
import 'package:honey_cook/tab2_list_selected/list_selected_dishes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Honey cook',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'List of dish'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with Observer {
  int _selectedIndex = 0;
  int _selectedDishesCount = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _openCreateDish() {
    Navigator.of(context).push(CupertinoPageRoute(
        fullscreenDialog: true, builder: (context) => const CreateDish()));
  }

  final List<AppBarModel> _listTabs = [
    AppBarModel(index: 0, view: const ListDishesView(), icon: Icons.view_list),
    AppBarModel(index: 1, view: const ListSelectedDishes(), icon: Icons.person)
  ];

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
      setState(() {
        final listCount = listSelectedDishes.map((e) => e.count);
        _selectedDishesCount = listCount.isEmpty ? 0 : listCount.reduce((value, element) => value + element);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildMainView();
  }

  Widget buildMainView() => Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: _listTabs.map((tab) => tab.view).toList(),
        ),
        bottomNavigationBar: buildBottomBar(),
        floatingActionButton: FloatingActionButton(
            onPressed: _openCreateDish, child: const Icon(Icons.add)),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      );

  Widget buildBottomBar() => BottomAppBar(
      color: Colors.white,
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _listTabs
            .map((tab) => GestureDetector(
                onTap: () => _onItemTapped(tab.index),
                child: Container(
                  margin: const EdgeInsets.all(8),
                  width: 40,
                  height: 40,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        tab.icon,
                        color: tab.index == _selectedIndex
                            ? Colors.blue
                            : Colors.black26,
                      ),
                      Visibility(
                        visible: _selectedDishesCount > 0 && tab.index == 1,
                        child: Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: Colors.red),
                            alignment: Alignment.center,
                            child: Text('$_selectedDishesCount', style: const TextStyle(color: Colors.white),),
                          ),
                        ),
                      )
                    ],
                  ),
                )))
            .toList(),
      ));
}

class AppBarModel {
  int index;
  Widget view;
  IconData icon;

  AppBarModel({required this.index, required this.view, required this.icon});
}
