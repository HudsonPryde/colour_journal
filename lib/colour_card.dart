import 'dart:typed_data';

import 'package:colour_journal/ntc.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'dao/card.dart';
import 'dao/collection.dart';

class ColourCard extends StatefulWidget {
  final String font;
  final Card card;

  const ColourCard(this.card, this.font, {super.key});

  @override
  State<ColourCard> createState() => _ColourCardState();
}

class _ColourCardState extends State<ColourCard> {
  Color _getTextColour() {
    if (widget.card.rgb.reduce((value, element) => value + element) / 3 < 255) {
      return const Color.fromRGBO(255, 255, 255, 0.69);
    } else {
      return const Color.fromRGBO(0, 0, 0, 0.69);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width / 2,
      ),
      child: Flex(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.45,
            height: MediaQuery.of(context).size.height * 0.3,
            decoration: BoxDecoration(
              color: widget.card.colour,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),
                  Image.memory(
                    widget.card.cutout as Uint8List,
                  ),
                  const Spacer(),
                  Text(
                    widget.card.name,
                    style: TextStyle(
                      fontSize: 24,
                      color: _getTextColour(),
                      fontFamily: widget.font,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    widget.card.hex,
                    style: TextStyle(
                      fontSize: 18,
                      color: _getTextColour(),
                      fontFamily: widget.font,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
