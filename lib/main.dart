import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:honey_cook/create_dish/create_dish.dart';
import 'package:honey_cook/firebase_options.dart';
import 'package:honey_cook/list_dishes/list_dishes.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'file_storage_test/file_storage_test.dart';

final storage = FirebaseStorage.instance;
final db = FirebaseFirestore.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
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

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  openCreateDish() {
    Navigator.of(context).push(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => const CreateDish()
      )
    );
  }

  final List<AppBarModel> _listTabs = [
    AppBarModel(index: 0, view: const ListDishesView(), icon: Icons.view_list),
    AppBarModel(index: 1, view: FileStorageTest(), icon: Icons.person)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _listTabs.map((tab) => tab.view).toList(),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 4,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _listTabs.map((tab) => IconButton(
              onPressed: () => _onItemTapped(tab.index),
              icon: Icon(
                tab.icon,
                color: tab.index == _selectedIndex ? Colors.blue : Colors.black26,
              )
          )).toList(),
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openCreateDish();
        },
        child: const Icon(Icons.add)
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class AppBarModel {
  int index;
  Widget view;
  IconData icon;

  AppBarModel({required this.index, required this.view, required this.icon});
}
