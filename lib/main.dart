import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:honey_cook/firebase_options.dart';
import 'package:honey_cook/list_api_test/list_api.dart';
import 'package:honey_cook/list_dishes/list_dishes.dart';

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
        primarySwatch: Colors.amber,
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

  final List<AppBarModel> _listTabs = [
    AppBarModel(view: const ListDishesView(), icon: Icons.view_list),
    AppBarModel(view: const ListApi(), icon: Icons.view_day),
    AppBarModel(view: const Center(child: Text("Cá nhân"),), icon: Icons.person)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _listTabs.map((tab) => tab.view).toList(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        items: _listTabs
            .map((tab) =>
                BottomNavigationBarItem(
                    icon: Icon(tab.icon),
                    label: ""
                ))
            .toList(),
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber,
        onTap: _onItemTapped,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }
}

class AppBarModel {
  Widget view;
  IconData icon;

  AppBarModel({required this.view, required this.icon});
}
