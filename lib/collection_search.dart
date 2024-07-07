import 'dart:ui';

import 'package:colour_journal/dao/collection.dart';
import 'package:colour_journal/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'collection_card.dart';

class CollectionSearch extends ModalRoute {
  @override
  Duration get transitionDuration => Duration(milliseconds: 300);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => Colors.white.withOpacity(0.2);

  @override
  String get barrierLabel => "";

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(
    BuildContext context,
    Animation animation,
    Animation secondaryAnimation,
  ) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(16),
      color: Color.fromARGB(66, 252, 252, 252),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 7,
          sigmaY: 7,
        ),
        child: const SafeArea(child: CollectionSearchContent()),
      ),
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // You can add your own animations for the overlay content
    return FadeTransition(opacity: animation, child: child);
  }
}

class CollectionSearchContent extends StatefulWidget {
  const CollectionSearchContent({super.key});
  @override
  State<StatefulWidget> createState() => _CollectionSearchContentState();
}

class _CollectionSearchContentState extends State<CollectionSearchContent> {
  String query = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CupertinoTextField(
          decoration: BoxDecoration(
            color: Colours.background,
            borderRadius: BorderRadius.circular(25),
          ),
          style: const TextStyle(
            color: Colours.primary,
            fontFamily: "Inter",
            fontSize: 22,
          ),
          prefix: const Padding(
            padding: EdgeInsets.only(left: 4.0),
            child: Icon(
              Icons.search,
              color: Colours.primary,
              size: 28,
            ),
          ),
          suffix: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.close, color: Colours.primary, size: 28),
          ),
          autofocus: true,
          onChanged: (value) => setState(() {
            query = value;
          }),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Wrap(
            spacing: 30,
            children: List.from(
              Provider.of<CollectionModel>(context, listen: false)
                  .filterCollectionsByName(query)
                  .map((e) => CollectionContainer(e)),
            ),
          ),
        )
      ],
    );
  }
}
