import 'dart:ui';

import 'package:colour_journal/collection_card.dart';
import 'package:colour_journal/collection_search.dart';
import 'package:colour_journal/theme.dart';
import 'collection_view.dart';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'dao/card.dart' as my;
import 'dao/collection.dart';

import 'package:uuid/uuid.dart';

import 'modals/collection_details_modal.dart';

var uuid = const Uuid();

void main() async {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CollectionModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: const MyHomePage(day: 'Monday'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.day});

  final String day;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void handleCreateCollection() {
    Collection collection = CollectionModel().createCollection();
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => CollectionView(collection),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // get provider from widget context and load cards from db
    context.read<CollectionModel>().loadCollections();
    return Scaffold(
      backgroundColor: Colours.background,
      body: SafeArea(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.push(context, CollectionSearch()),
                  child: SizedBox(
                    width: 80,
                    child: Row(
                      children: const [
                        Icon(
                          Icons.search,
                          color: Colours.primary,
                          size: 28,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 100,
                  child: Text(
                    'Collections',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colours.primary,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                ),
                SizedBox(
                  width: 80,
                  child: OutlinedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      side: MaterialStateProperty.all(
                        const BorderSide(
                          width: 2.0,
                          color: Colours.tertiary,
                        ),
                      ),
                    ),
                    onPressed: () => handleCreateCollection(),
                    child: const Text(
                      'Create',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colours.primary,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Inter",
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Consumer<CollectionModel>(
            builder: (context, state, child) => Wrap(
              spacing: 30,
              children: List.from(
                state.collections.map((e) {
                  return GestureDetector(
                    onLongPress: () {
                      showModalBottomSheet(
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          builder: (context) {
                            return SingleChildScrollView(
                              child: Container(
                                padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom,
                                ),
                                child: CollectionDetailsModal(e),
                              ),
                            );
                          });
                    },
                    child: CollectionContainer(e),
                  );
                }),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
