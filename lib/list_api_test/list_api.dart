import 'package:flutter/material.dart';
import 'package:honey_cook/list_api_test/list_api_model.dart';
import 'package:honey_cook/list_api_test/list_api_service.dart';

class ListApi extends StatefulWidget {
  const ListApi({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ListApiState();
  }
}

class _ListApiState extends State<ListApi> {
  List<ApiModel>? list;
  var isLoaded = false;

  @override
  void initState() {
    super.initState();

    getData();
  }

  getData() async {
    list = await ListApiService().getApi() ?? [];
    if (list != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách'),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        child: Visibility(
          visible: isLoaded,
          child: ListView.builder(
              itemCount: list?.length,
              itemBuilder: (context, index) {
                return ListTile(
                    title: Text(list![index].title.value ?? ''),
                    subtitle: Text(list![index].body.value ?? ''));
              }),
          replacement: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
