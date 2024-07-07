import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:colour_journal/dao/collection.dart';
import 'package:colour_journal/database.dart';
import 'package:colour_journal/ntc.dart';

import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:uuid/uuid.dart';

import 'dao/card.dart' as my;

final DatabaseService _databaseService = DatabaseService();
var uuid = const Uuid();

class ImageView extends StatefulWidget {
  final String collectionId;
  final Uint8List imageData;

  const ImageView(this.collectionId, this.imageData, {super.key});

  @override
  State<ImageView> createState() => _ImageViewState();
}

class CutoutPainter extends CustomPainter {
  final Path _path;
  CutoutPainter(this._path);
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
        _path, Paint()..color = const Color.fromRGBO(255, 255, 255, 0.5));
  }

  @override
  bool shouldRepaint(CutoutPainter oldDelegate) => true;
}

class _ImageViewState extends State<ImageView> {
  Offset _pos = const Offset(0, 0);
  double _stroke = 12;
  final Path _path = Path();
  late img.Image? _imageData;
  Color _pickedColour = Color.fromRGBO(255, 255, 255, 1);
  double _ratioH = 1;
  double _ratioW = 1;
  bool _visible = false;

  // input mode -> 0 = colour picker | 1 = image cutout
  int _mode = 0;
  final ui.PictureRecorder _recorder = ui.PictureRecorder();
  late Canvas _canvas;

  @override
  void initState() {
    decodeImageFromList(widget.imageData).then((value) => {
          setState(() {
            final imgBytes = img
                .decodePng(widget.imageData)
                ?.getBytes(order: img.ChannelOrder.rgba, alpha: 255);
            _imageData = img.Image.fromBytes(
                bytes: imgBytes!.buffer,
                numChannels: 4,
                width: value.width,
                height: value.height);
          })
        });

    setState(() => _canvas = Canvas(_recorder));
  }

  void _getPixelData() {
    img.Color? pixel = _imageData?.getPixelInterpolate(
        _pos.dx * _ratioW, _pos.dy * _ratioH,
        interpolation: img.Interpolation.linear);
    if (pixel == null) {
      return;
    }
    setState(() => _pickedColour =
        Color.fromARGB(255, pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt()));
  }

  void _handleSave() {
    if (_path.computeMetrics().isEmpty) {
      String colourName =
          Ntc().getColour(_pickedColour.value.toRadixString(16)) as String;
      Provider.of<CollectionModel>(context, listen: false).addCard(
          my.Card(
              uuid.v4(), colourName, _pickedColour, null, widget.collectionId),
          widget.collectionId);
      Navigator.maybePop(context);
    }
    // resize path using image ratio
    _path.close();
    Path clip;
    Matrix4 trans = Matrix4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1)
      ..scale(
        _ratioW,
        _ratioH,
      );
    clip = _path.transform(trans.storage);
    Rect clipBounds = clip.getBounds();

    // crop image to clip bounds
    final cutout = img.copyCrop(
      _imageData!,
      x: clipBounds.left.toInt(),
      y: clipBounds.top.toInt(),
      width: clipBounds.width.toInt(),
      height: clipBounds.height.toInt(),
    );

    // translate the clip to (0,0)
    clip = clip.shift(Offset(
      -clipBounds.left,
      -clipBounds.top,
    ));

    // TODO: replace this with a built-in function
    // make all pixels outside clip bounds transparent
    for (final pixel in cutout) {
      if (!clip.contains(
        Offset(
          pixel.x.toDouble(),
          pixel.y.toDouble(),
        ),
      )) {
        pixel.a = 0;
      }
    }

    String id = uuid.v4();
    final pngCutout = img.encodePng(cutout, filter: img.PngFilter.sub);
    String colourName =
        Ntc().getColour(_pickedColour.value.toRadixString(16)) as String;
    _databaseService.insertCard(
      my.Card(id, colourName, _pickedColour, pngCutout, widget.collectionId),
    );
    Provider.of<CollectionModel>(context, listen: false).addCard(
        my.Card(id, colourName, _pickedColour, pngCutout, widget.collectionId),
        widget.collectionId);
    Navigator.maybePop(
      context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: OverflowBar(
            alignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                splashRadius: 20.0,
                onPressed: () => ModalRoute.of(context)?.navigator?.maybePop(),
                icon: Icon(Icons.arrow_back_ios, color: Colors.blue[200]),
              ),
              IconButton(
                splashRadius: 20.0,
                onPressed: () => _handleSave(),
                icon: Icon(
                  Icons.done,
                  color: Colors.blue[200],
                  size: 30,
                ),
              ),
            ],
          ),
        ),
      ),
      Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height * 0.75,
        width: MediaQuery.of(context).size.width * 0.9,
        child: Stack(children: [
          Builder(
            builder: (context) {
              return GestureDetector(
                onPanStart: (details) {
                  setState(() {
                    _ratioH = _imageData!.height / context.size!.height;
                    _ratioW = _imageData!.width / context.size!.width;
                  });
                  _pos = details.localPosition;
                  if (_mode == 0) {
                    setState(() {
                      _visible = true;
                    });
                    _getPixelData();
                  } else {
                    setState(() => _path.addOval(
                        Rect.fromCircle(center: _pos, radius: _stroke)));
                  }
                },
                onPanUpdate: (details) {
                  _pos = details.localPosition;
                  if (_mode == 1) {
                    setState(() => _path.addOval(
                        Rect.fromCircle(center: _pos, radius: _stroke)));
                  } else {
                    _getPixelData();
                  }
                },
                onPanEnd: (details) {
                  setState(() => _visible = false);
                },
                child: CustomPaint(
                  foregroundPainter: CutoutPainter(_path),
                  willChange: true,
                  child: Image.memory(
                    widget.imageData,
                    isAntiAlias: true,
                  ),
                ),
              );
            },
          ),
          Positioned(
            top: _pos.dy - 45,
            left: _pos.dx - 35 / 2,
            child: Visibility(
              visible: _visible,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color.fromRGBO(255, 255, 255, 1),
                    width: 3,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  color: _pickedColour,
                ),
                width: 35,
                height: 35,
              ),
            ),
          ),
        ]),
      ),
      Material(
          color: Colors.transparent,
          child: Padding(
              padding: const EdgeInsetsDirectional.only(end: 15),
              child: Column(children: [
                OverflowBar(
                  spacing: 12,
                  alignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color.fromRGBO(255, 255, 255, 1),
                              width: 3),
                          borderRadius: BorderRadius.circular(10),
                          color: _pickedColour),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: _mode == 0 ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(50)),
                      child: IconButton(
                        color: _mode == 0 ? Colors.black87 : Colors.white,
                        splashRadius: 20.0,
                        onPressed: () => setState(() => _mode = 0),
                        icon: const Icon(Icons.colorize),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: _mode == 1 ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(50)),
                      child: IconButton(
                        color: _mode == 1 ? Colors.black87 : Colors.white,
                        splashRadius: 20.0,
                        onPressed: () => setState(() => _mode = 1),
                        icon: const Icon(Icons.cut),
                      ),
                    ),
                    IconButton(
                      color: Colors.white,
                      splashRadius: 20.0,
                      onPressed: () => setState(() => _path.reset()),
                      icon: const Icon(Icons.undo),
                    ),
                  ],
                ),
                OverflowBar(
                  spacing: 0,
                  alignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.white),
                      height: _stroke * _ratioH * _ratioW,
                      width: _stroke * _ratioH * _ratioW,
                    ),
                    SizedBox(
                        width: 200,
                        child: Slider(
                          min: 5,
                          max: 20,
                          value: _stroke,
                          onChanged: (double value) =>
                              setState(() => _stroke = value),
                          thumbColor: Colors.white,
                          activeColor: Colors.white70,
                        )),
                  ],
                ),
              ]))),
    ]);
  }
}
