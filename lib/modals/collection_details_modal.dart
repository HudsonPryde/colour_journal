import 'package:colour_journal/dao/collection.dart';
import 'package:colour_journal/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:colour_journal/dao/card.dart' as my;
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class CollectionDetailsModal extends StatefulWidget {
  final Collection collection;
  const CollectionDetailsModal(this.collection, {super.key});
  @override
  State<CollectionDetailsModal> createState() => _CollectionDetailsModalState();
}

class _CollectionDetailsModalState extends State<CollectionDetailsModal> {
  void _handleDeleteCollection() {
    Provider.of<CollectionModel>(context, listen: false)
        .deleteCollection(widget.collection.id);
    Navigator.pop(context);
  }

  void _handleCollectionRename(String name) {
    Provider.of<CollectionModel>(context, listen: false).renameCollection(
      name,
      widget.collection.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 372,
      padding: const EdgeInsets.only(
        bottom: 20,
        top: 10,
        right: 20,
        left: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                margin: const EdgeInsets.only(top: 12),
                height: 30,
                width: 250,
                child: CupertinoTextField(
                  textAlignVertical: TextAlignVertical.top,
                  controller: TextEditingController(
                    text: widget.collection.name,
                  ),
                  suffix: const Icon(
                    Icons.mode_edit_sharp,
                    color: Colours.secondary,
                    size: 24,
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
                  onSubmitted: (value) => _handleCollectionRename(value),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              children: [
                Row(
                  children: const [
                    Text(
                      "Details",
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: "Inter",
                        color: Colours.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Icon(
                              Icons.calendar_month_outlined,
                              color: Colours.primary,
                              size: 28,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                widget.collection.createdAtVerbose,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontFamily: "Inter",
                                  color: Colours.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Icon(
                              Icons.layers_outlined,
                              color: Colours.primary,
                              size: 28,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                "${widget.collection.cards.length} cards",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontFamily: "Inter",
                                  color: Colours.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Column(
                    children: [
                      Row(
                        children: const [
                          Text(
                            "Typeface",
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: "Inter",
                              color: Colours.secondary,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TypefaceButton(
                                widget.collection.id, "Inter", "System", "Aa"),
                            TypefaceButton(
                                widget.collection.id, "Coconat", "Serif", "Ss"),
                            TypefaceButton(
                                widget.collection.id, "Ribes", "Block", "Bb"),
                            TypefaceButton(
                                widget.collection.id, "Plex", "Mono", "00"),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => _handleDeleteCollection(),
                child: const Text(
                  'Delete Collection',
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

class TypefaceButton extends StatefulWidget {
  final String id;
  final String fontFamily;
  final String fontStyle;
  final String letters;

  const TypefaceButton(this.id, this.fontFamily, this.fontStyle, this.letters,
      {super.key});
  @override
  State<TypefaceButton> createState() => _TypefaceButtonState();
}

class _TypefaceButtonState extends State<TypefaceButton> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          Provider.of<CollectionModel>(context, listen: false)
              .changeCollectionFont(widget.fontFamily, widget.id);
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 100,
          decoration: BoxDecoration(
            color: Colours.quatranary,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              width: 2,
              color: Provider.of<CollectionModel>(context)
                          .getCollectionById(widget.id)
                          .font ==
                      widget.fontFamily
                  ? Colours.selected
                  : Colors.transparent,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.letters,
                style: TextStyle(
                  color: Colours.primary,
                  fontFamily: widget.fontFamily,
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                widget.fontStyle,
                style: TextStyle(
                  color: Colours.secondary,
                  fontFamily: widget.fontFamily,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
