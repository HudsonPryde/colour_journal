import 'dart:typed_data';

import 'package:colour_journal/main.dart';
import 'package:colour_journal/theme.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'collection_view.dart';
import 'dao/card.dart' as my;
import 'dao/collection.dart';

class CollectionContainer extends StatefulWidget {
  final Collection collection;

  const CollectionContainer(this.collection, {super.key});
  @override
  State<CollectionContainer> createState() => _CollectionContainerState();
}

class _CollectionContainerState extends State<CollectionContainer> {
  double getAngle() {
    var angle = Random().nextDouble() * (-pi / 36);
    if (Random().nextBool()) {
      angle * -1;
    }
    return angle;
  }

  Color _getTextColour(my.Card card) {
    if (card.rgb.reduce((value, element) => value + element) / 3 < 255) {
      return const Color.fromRGBO(255, 255, 255, 0.69);
    } else {
      return const Color.fromRGBO(0, 0, 0, 0.69);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) =>
                  CollectionView(widget.collection),
            ),
          ),
          child: Stack(
            children: [
              ...widget.collection.cards.isNotEmpty
                  ? List.from(widget.collection.cards
                      .sublist(1, min(3, widget.collection.cards.length))
                      .map((e) {
                      return CollectionCard(e);
                    }))
                  : [],
              widget.collection.cards.isNotEmpty
                  ? Container(
                      // top card in stack gets date and cutout
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Color.fromRGBO(
                            widget.collection.cards[0].rgb[0],
                            widget.collection.cards[0].rgb[1],
                            widget.collection.cards[0].rgb[2],
                            1,
                          )),
                      height: 235,
                      width: 174,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.collection.createdAt,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color:
                                    _getTextColour(widget.collection.cards[0]),
                              ),
                            ),
                            const Spacer(),
                            Image.memory(
                              widget.collection.cards[0].cutout as Uint8List,
                            ),
                            const Spacer(),
                          ]),
                    )
                  : DottedBorder(
                      borderType: BorderType.RRect,
                      strokeWidth: 2,
                      padding: EdgeInsets.zero,
                      color: Colours.secondary,
                      radius: const Radius.circular(20),
                      dashPattern: const [6],
                      child: Container(
                        height: 235,
                        width: 174,
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          widget.collection.createdAt.toString(),
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colours.secondary,
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            widget.collection.name,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              color: Colours.primary,
              fontSize: 16,
            ),
          ),
        )
      ],
    );
  }
}

class CollectionCard extends StatelessWidget {
  final my.Card card;
  const CollectionCard(this.card, {super.key});

  double getAngle() {
    var angle = (-pi / 90) + (Random().nextDouble() * (-pi / 45));
    if (Random().nextBool()) {
      angle *= -1;
    }
    return angle;
  }

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: getAngle(),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Color.fromRGBO(card.rgb[0], card.rgb[1], card.rgb[2], 1),
        ),
        height: 235,
        width: 174,
      ),
    );
  }
}
