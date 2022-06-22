import 'package:flutter/material.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key, required this.onChangeText}) : super(key: key);

  final ValueChanged<String?> onChangeText;

  @override
  State<StatefulWidget> createState() {
    return _SearchViewState();
  }
}

class _SearchViewState extends State<SearchView> {
  @override
  initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: Colors.white,
      child: TextFormField(
        decoration: const InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black26,
              width: 0.5
            ),
            borderRadius: BorderRadius.all(Radius.circular(8))
          ),
          labelText: "Nhập tên món"
        ),
        onChanged: widget.onChangeText,
      ),
    );
  }
}