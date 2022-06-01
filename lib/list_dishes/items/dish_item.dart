import 'package:flutter/material.dart';
import 'package:honey_cook/model/dish_model.dart';

class DishItem extends StatefulWidget {
  const DishItem({Key? key, required this.model}) : super(key: key);

  final DishModel model;

  @override
  State<StatefulWidget> createState() {
    return _DishItemState();
  }
}

class _DishItemState extends State<DishItem> {
  final List<Widget> listWidget = [];

  @override
  Widget build(BuildContext context) {
    listWidget.clear();
    for (int i = 0; i < widget.model.listFilter.length; i++) {
      if (i > 1) {
        break;
      }
      listWidget.add(Chip(
          padding: const EdgeInsets.all(6),
          label: Icon(widget.model.listFilter[i].icon, size: 12)));
    }
    listWidget.add(const SizedBox(width: 8));
    listWidget.add(Text("Đã ăn ${widget.model.eatenCount} lần",
        style: const TextStyle(fontSize: 12, color: Colors.black54)));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      height: 120,
      child: Row(
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints.tightForFinite(width: 120),
            child: Image.network(widget.model.image, fit: BoxFit.cover),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 0, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.model.name,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                            maxLines: 1,
                          ),
                          Expanded(
                              child: Container(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                    widget.model.description ??
                                        "Chưa có ghi chú",
                                    style: const TextStyle(
                                        color: Colors.black87, fontSize: 14)),
                              ),
                              flex: 1)
                        ],
                      ),
                      flex: 1),
                  Row(
                    children: [
                      Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: listWidget,
                          ),
                          flex: 1),
                      Icon(
                          widget.model.isFavourite
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber)
                    ],
                  )
                ],
              ),
            ),
            flex: 1,
          )
        ],
      ),
    );
  }
}
