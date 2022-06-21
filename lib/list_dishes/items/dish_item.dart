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
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      height: 100,
      child: Row(
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints.tightForFinite(width: 120),
            child: widget.model.image?.isNotEmpty == true
                ? Image.network(widget.model.image!, fit: BoxFit.cover)
                : const Image(image: AssetImage('assets/motor.jpg')),
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
                            widget.model.name ?? "",
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          child: Text("Đã ăn ${widget.model.eatenNumber} lần",
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.black54)),
                          flex: 1),
                      Icon(
                          widget.model.love == true
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
