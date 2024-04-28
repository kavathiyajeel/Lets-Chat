import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/size.dart';

class ImageViewer extends StatefulWidget {
  final String link;

  const ImageViewer({required this.link, super.key});

  @override
  State<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      child: Container(
        color: Colors.transparent,
        child: Stack(
          children: [
            Positioned(
              top: deviceHeight * 0.020,
              right: deviceWidth * 0.008,
              child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    CupertinoIcons.clear_circled_solid,
                    color: Colors.white,
                  )),
            ),
            Center(
              child: Image.network(
                widget.link,
                width: double.infinity,
                height: deviceHeight * 0.45,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
