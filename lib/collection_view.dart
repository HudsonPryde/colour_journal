import 'package:colour_journal/modals/card_details_modal.dart';
import 'package:colour_journal/theme.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dao/collection.dart';
import 'colour_card.dart';
import 'image_view.dart';

class CollectionView extends StatefulWidget {
  final Collection collection;
  const CollectionView(this.collection, {super.key});
  @override
  State<CollectionView> createState() => _CollectionViewState();
}

class _CollectionViewState extends State<CollectionView> {
  List<XFile>? _mediaFileList;

  dynamic _pickImageError;

  String? _retrieveDataError;

  final ImagePicker _picker = ImagePicker();

  void _setImageFileListFromFile(XFile? value) {
    setState(() {
      _mediaFileList = value == null ? null : <XFile>[value];
    });
    value?.readAsBytes().then((imageData) => {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) =>
                  ImageView(widget.collection.id, imageData),
            ),
          )
        });
  }

  Future<void> _onImageButtonPressed(ImageSource source,
      {required BuildContext context}) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      print(pickedFile?.name);
      _setImageFileListFromFile(pickedFile);
    } catch (e) {
      print(e);
      setState(() {
        _pickImageError = e;
      });
    }
  }
  // TODO: wrap colour cards in hero widget for cool effect

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      size: 28,
                      color: Colours.primary,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colours.tertiary, width: 2),
                      borderRadius: BorderRadius.circular(12.5),
                    ),
                    child: Text(
                      widget.collection.name,
                      style: const TextStyle(
                        fontFamily: "Inter",
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colours.primary,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Container(
                              height: MediaQuery.of(context).size.height * 0.25,
                              decoration: const BoxDecoration(
                                color: Colours.background,
                              ),
                              child: Column(children: [
                                Wrap(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(
                                            bottom: 32,
                                            top: 10,
                                          ),
                                          height: 4,
                                          width: 50,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            color: Colours.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      margin: const EdgeInsets.fromLTRB(
                                          20, 0, 20, 10),
                                      child: OutlinedButton(
                                        style: ButtonStyle(
                                          padding: MaterialStateProperty.all(
                                              const EdgeInsets.all(12)),
                                          shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),
                                          side: MaterialStateProperty.all(
                                            const BorderSide(
                                              width: 2.0,
                                              color: Colours.tertiary,
                                            ),
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          _onImageButtonPressed(
                                            ImageSource.camera,
                                            context: context,
                                          );
                                        },
                                        child: Flex(
                                          direction: Axis.horizontal,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Icon(
                                              Icons.camera_alt_outlined,
                                              size: 32,
                                              color: Colours.primary,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 6),
                                              child: Text(
                                                "Take a photo",
                                                style: TextStyle(
                                                  color: Colours.primary,
                                                  fontFamily: "Inter",
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.fromLTRB(
                                          20, 0, 20, 10),
                                      child: OutlinedButton(
                                        style: ButtonStyle(
                                          padding: MaterialStateProperty.all(
                                              const EdgeInsets.all(12)),
                                          shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),
                                          side: MaterialStateProperty.all(
                                            const BorderSide(
                                              width: 2.0,
                                              color: Colours.tertiary,
                                            ),
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          _onImageButtonPressed(
                                            ImageSource.gallery,
                                            context: context,
                                          );
                                        },
                                        child: Flex(
                                          direction: Axis.horizontal,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Icon(
                                              Icons.photo_library_outlined,
                                              size: 32,
                                              color: Colours.primary,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 6,
                                              ),
                                              child: Text(
                                                "Select an image",
                                                style: TextStyle(
                                                  color: Colours.primary,
                                                  fontFamily: "Inter",
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ]),
                            );
                          });
                    },
                    icon: const Icon(
                      Icons.add,
                      size: 32,
                      color: Colours.primary,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.collection.createdAt,
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: "Inter",
                      color: Colours.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Wrap(
                runSpacing: 20,
                children: List.from(
                  Provider.of<CollectionModel>(context, listen: true)
                      .getCollectionById(widget.collection.id)
                      .cards
                      .map(
                        (card) => GestureDetector(
                          onLongPress: () => showModalBottomSheet(
                              backgroundColor: Colors.transparent,
                              isScrollControlled: true,
                              context: context,
                              builder: (context) {
                                return SingleChildScrollView(
                                  child: Container(
                                    padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom,
                                    ),
                                    child: CardDetailsModal(card),
                                  ),
                                );
                              }),
                          child: ColourCard(card, widget.collection.font),
                        ),
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
