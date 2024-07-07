import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';

class CutoutPreview extends StatefulWidget {
  final Uint8List cutout;
  final Path clip;
  const CutoutPreview(this.cutout, this.clip);

  @override
  State<CutoutPreview> createState() => _CutoutPreview();
}

class _CutoutPreview extends State<CutoutPreview> {
  @override
  Widget build(BuildContext conetxt) {
    // print(widget.cutout);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.memory(
          widget.cutout,
        )
      ],
    );
  }
}

class CutoutClipper extends CustomClipper<ui.Path> {
  final Path path;
  CutoutClipper(this.path);
  // var _ratioW;
  // var _ratioH;
  // var _transform;

  @override
  getClip(Size size) {
    // get the ratio between normal bounds and given size
    // print(size);
    // print([path.getBounds().size.height, path.getBounds().size.width]);
    // _ratioH = size.height / path.getBounds().size.height;
    // _ratioW = size.width / path.getBounds().size.width;
    // print([_ratioH, _ratioW]);
    // _transform = Matrix4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1)
    //   ..scale(_ratioW, _ratioH);

    // return path.transform(_transform.storage);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) => true;
}
