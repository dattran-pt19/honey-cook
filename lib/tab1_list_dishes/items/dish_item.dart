import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:honey_cook/model/dish_model.dart';

import '../../base/constants.dart';
import '../../base/singleton.dart';

class DishItem extends StatefulWidget {
  const DishItem({Key? key, required this.model, required this.onClickCell}) : super(key: key);

  final DishModel model;
  final GestureTapCallback onClickCell;

  @override
  State<StatefulWidget> createState() {
    return _DishItemState();
  }
}

class _DishItemState extends State<DishItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onClickCell,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        height: 100,
        child: Row(
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints.tightForFinite(width: 120),
              child: widget.model.image?.isNotEmpty == true
                  ? CachedNetworkImage(
                imageUrl: widget.model.image!,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                progressIndicatorBuilder: (context, url, downloadProgress) {
                  return Center(
                    child: CircularProgressIndicator(
                      value: downloadProgress.progress,
                    ),
                  );
                },
              )
                  : const Image(image: AssetImage('assets/motor.jpg')),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.only(left: 16, top: 4),
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
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                widget.model.description ?? "Chưa có ghi chú",
                                style: const TextStyle(
                                    color: Colors.black87, fontSize: 14),
                                maxLines: 2,
                              ),
                            )
                          ],
                        ),
                        flex: 1),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            (widget.model.eatenNumber == null ||
                                widget.model.eatenNumber == 0)
                                ? "Chưa ăn phát lào"
                                : "Đã ăn ${widget.model.eatenNumber} lần",
                            style: const TextStyle(
                                fontSize: 12, color: Colors.black54)),
                        const Spacer(),
                        IconButton(
                            padding: const EdgeInsets.all(2),
                            constraints: const BoxConstraints(),
                            onPressed: () {
                              listDishesRef.update({
                                dbListDishes: FieldValue.arrayRemove(
                                    [widget.model.toFirestore()])
                              });
                              setState(() {
                                widget.model.love = !(widget.model.love ?? false);
                              });
                              listDishesRef.update({
                                dbListDishes: FieldValue.arrayUnion(
                                    [widget.model.toFirestore()])
                              });
                            },
                            icon: Icon(
                                widget.model.love == true
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Colors.amber))
                      ],
                    )
                  ],
                ),
              ),
              flex: 1,
            )
          ],
        ),
      ),
    );
  }
}
