import 'package:colour_journal/dao/collection.dart';
import 'package:colour_journal/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:colour_journal/dao/card.dart' as my;
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class CardDetailsModal extends StatefulWidget {
  final my.Card focusedCard;
  const CardDetailsModal(this.focusedCard, {super.key});
  @override
  State<CardDetailsModal> createState() => _CardDetailsModalState();
}

class _CardDetailsModalState extends State<CardDetailsModal> {
  void _handleDeleteCard() {
    Provider.of<CollectionModel>(context, listen: false)
        .deleteCard(widget.focusedCard);
    Navigator.pop(context);
  }

  void _handleClipboard(String data) {
    Clipboard.setData(ClipboardData(text: data));
  }

  void _handleCardRename(String name) {
    Provider.of<CollectionModel>(context, listen: false).renameCard(
      name,
      widget.focusedCard.id,
      widget.focusedCard.collectionId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.20,
      padding: const EdgeInsets.only(
        bottom: 20,
        top: 10,
        right: 20,
        left: 20,
      ),
      margin: const EdgeInsets.only(
        bottom: 20,
        top: 20,
        right: 20,
        left: 20,
      ),
      decoration: BoxDecoration(
        color: Colours.background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Container(
                height: 6,
                width: 55,
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colours.secondary,
                ),
              ),
              const Spacer(),
            ],
          ),
          Row(
            children: [
              Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  color: widget.focusedCard.colour,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        height: 30,
                        width: 250,
                        child: CupertinoTextField(
                          textAlignVertical: TextAlignVertical.top,
                          controller: TextEditingController(
                            text: widget.focusedCard.name,
                          ),
                          style: const TextStyle(
                            fontSize: 18,
                            fontFamily: "Inter",
                            color: Colours.primary,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: const BoxDecoration(
                            color: Colours.background,
                            border: Border(
                              bottom: BorderSide(
                                color: Colours.tertiary,
                                width: 2,
                              ),
                            ),
                          ),
                          onSubmitted: (value) => _handleCardRename(value),
                        ),
                      ),
                      const Icon(
                        Icons.mode_edit_sharp,
                        color: Colours.secondary,
                        size: 24,
                      )
                    ],
                  ),
                  GestureDetector(
                    onTap: () => _handleClipboard(widget.focusedCard.hex),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4),
                          child: Text(
                            widget.focusedCard.hex,
                            style: const TextStyle(
                              fontSize: 18,
                              fontFamily: "Inter",
                              color: Colours.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.copy,
                          color: Colours.secondary,
                          size: 20,
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _handleClipboard(widget.focusedCard.rgb.join(' / '));
                    },
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            widget.focusedCard.rgb.join(' / '),
                            style: const TextStyle(
                              fontSize: 18,
                              fontFamily: "Inter",
                              color: Colours.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.copy,
                          color: Colours.secondary,
                          size: 20,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => _handleDeleteCard(),
                child: const Text(
                  'Delete Card',
                  style: TextStyle(
                    color: Colours.danger,
                    fontSize: 18,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
