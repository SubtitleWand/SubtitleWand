import 'dart:async';
import 'dart:io';
import 'dart:math' as Math;
import 'dart:ui';

import 'package:flutter/material.dart' hide Image;
import 'package:path/path.dart' as p;

/// Which way for Subtitle to align horizontally.
enum SubtitleHorizontalAlignment { left, center, right }

extension SubtitleHorizontalAlignmentExtension on SubtitleHorizontalAlignment {
  String get name {
    switch (this) {
      case SubtitleHorizontalAlignment.left:
        return 'Left';
      case SubtitleHorizontalAlignment.right:
        return 'Right';
      case SubtitleHorizontalAlignment.center:
        return 'Center';
    }
  }
}

/// Which way for Subtitle to align Vertically
enum SubtitleVerticalAlignment {
  top,
  center,
  bottom,
}

extension SubtitleVerticalAlignmentExtension on SubtitleVerticalAlignment {
  String get name {
    switch (this) {
      case SubtitleVerticalAlignment.top:
        return 'Top';
      case SubtitleVerticalAlignment.center:
        return 'Center';
      case SubtitleVerticalAlignment.bottom:
        return 'Bottom';
    }
  }
}

///
/// The painter used to render whole canvas.
///
class SubtitlePainter extends CustomPainter {
  SubtitlePainter({
    required this.propertyPaddingLeft,
    required this.propertyPaddingRight,
    required this.propertyPaddingTop,
    required this.propertyPaddingBottom,
    required this.propertyFontSize,
    required this.propertyFontColor,
    this.propertyFontFamily,
    required this.propertyBorderWidth,
    required this.propertyBorderColor,
    required this.propertyShadowX,
    required this.propertyShadowY,
    required this.propertyShadowSpread,
    required this.propertyShadowBlur,
    required this.propertyShadowColor,
    required this.verticalAlignment,
    required this.horizontalAlignment,
    required this.propertyCanvasResolutionX,
    required this.propertyCanvasResolutionY,
    required this.propertyCanvasBackgroundColor,
    this.translation = Offset.zero,
    this.scaleOffset = 0,
    required this.subtitleText,
    this.isDrawCanvasBg = true,
  });

  final double propertyPaddingLeft;
  final double propertyPaddingRight;
  final double propertyPaddingTop;
  final double propertyPaddingBottom;
  final double propertyFontSize;
  final Color propertyFontColor;
  final String? propertyFontFamily; // nullable to default font
  final double propertyBorderWidth;
  final Color propertyBorderColor;
  final double propertyShadowX;
  final double propertyShadowY;
  final int propertyShadowSpread;
  final double propertyShadowBlur;
  final Color propertyShadowColor;
  final SubtitleVerticalAlignment verticalAlignment;
  final SubtitleHorizontalAlignment horizontalAlignment;
  final double propertyCanvasResolutionX;
  final double propertyCanvasResolutionY;
  final Color propertyCanvasBackgroundColor;
  final bool isDrawCanvasBg;
  final Offset translation;
  final double scaleOffset;
  final String subtitleText;

  @override
  void paint(Canvas canvas, Size size) {
    final EdgeInsets padding = EdgeInsets.only(
      left: propertyPaddingLeft,
      right: propertyPaddingRight,
      top: propertyPaddingTop,
      bottom: propertyPaddingBottom,
    );

    Rect rect = Offset.zero &
        Size(propertyCanvasResolutionX, propertyCanvasResolutionY);

    double scaleX = propertyCanvasResolutionX / size.width;
    double scaleY = propertyCanvasResolutionY / size.height;
    double scale = 1.0 / Math.max(scaleX, scaleY);
    // Maximum canvas size that keep ratio and fit in Area
    double scaledWidth = propertyCanvasResolutionX * scale;
    double scaledHeight = propertyCanvasResolutionY * scale;

    // Check size difference
    double originOffsetX = (size.width - scaledWidth) / 2;
    double originOffsetY = (size.height - scaledHeight) / 2;

    // draw full background
    canvas.drawRect(Offset.zero & size, Paint()..color = Colors.black);

    // save and create a new canvas/transition for actual CANVAS
    canvas.saveLayer(null, Paint());
    canvas.translate(-translation.dx, -translation.dy);
    canvas.translate(originOffsetX, originOffsetY);
    canvas.scale(scale + (scaleOffset));

    // draw cancas background
    if (isDrawCanvasBg) {
      canvas.drawRect(
        rect,
        Paint()
          ..shader = LinearGradient(
            colors: [
              propertyCanvasBackgroundColor,
              propertyCanvasBackgroundColor
            ], // [const Color(0xFFFFFF00), const Color(0xFFffffff)],
          ).createShader(rect),
      );
    }
    final basicStyle = TextStyle(
      fontFamily: propertyFontFamily,
      fontSize: propertyFontSize,
      color: propertyFontColor,
    );

    TextPainter painter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: horizontalAlignment == SubtitleHorizontalAlignment.left
          ? TextAlign.left
          : horizontalAlignment == SubtitleHorizontalAlignment.right
              ? TextAlign.right
              : TextAlign.center,
    );

    verticalOffset() {
      return verticalAlignment == SubtitleVerticalAlignment.top
          ? Offset(padding.left, padding.top)
          : verticalAlignment == SubtitleVerticalAlignment.bottom
              ? Offset(
                  padding.left,
                  propertyCanvasResolutionY - painter.height - padding.bottom,
                )
              : Offset(
                  padding.left,
                  propertyCanvasResolutionY / 2 - painter.height / 2,
                );
    }

    // draw shadow
    if (propertyShadowX != 0 || propertyShadowY != 0) {
      TextSpan span = TextSpan(
        text: subtitleText,
        style: basicStyle.copyWith(
          shadows: [
            Shadow(
              blurRadius: propertyShadowBlur,
              color: propertyShadowColor,
              offset: Offset(propertyShadowX, propertyShadowY),
            )
          ],
        ),
      );
      painter.text = span;
      painter.layout(
        minWidth: propertyCanvasResolutionX - padding.right,
        maxWidth: propertyCanvasResolutionX - padding.right,
      );
      painter.paint(canvas, verticalOffset());
    }

    // draw text border
    if (propertyBorderWidth != 0) {
      TextSpan span = TextSpan(
        text: subtitleText,
        style: basicStyle.copyWith(
          foreground: Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = propertyBorderWidth
            ..color = propertyBorderColor,
        ),
      );
      painter.text = span;
      painter.layout(
        minWidth: propertyCanvasResolutionX - padding.right,
        maxWidth: propertyCanvasResolutionX - padding.right,
      );
      painter.paint(canvas, verticalOffset());
    }

    // draw text
    painter.text = TextSpan(
      text: subtitleText,
      style: basicStyle,
    );
    painter.layout(
      minWidth: propertyCanvasResolutionX - padding.right,
      maxWidth: propertyCanvasResolutionX - padding.right,
    );
    painter.paint(canvas, verticalOffset());

    canvas.restore();
  }

  ///
  /// save image with [canvasSize] and transform to [resolutionSize],
  /// and will be saved in [directory], the name is [snapshot].png
  ///
  Future<void> saveImage(
    Size canvasSize,
    Size resolutionSize,
    String directory,
    String snapshot,
  ) async {
    PictureRecorder recorder = PictureRecorder();
    Canvas canvas = Canvas(recorder);

    // bool originalSettingBackground = _isRenderBackground;
    // _isRenderBackground = false;

    paint(canvas, canvasSize);

    // _isRenderBackground = originalSettingBackground;

    Image image = await recorder
        .endRecording()
        .toImage(resolutionSize.width.toInt(), resolutionSize.height.toInt());
    var pngBytes = await image.toByteData(format: ImageByteFormat.png);

    // create folder first, but no mac, mac will create file with folders
    if (!Platform.isMacOS && !await Directory(directory).exists()) {
      await Directory(directory).create();
    }

    if (Platform.isMacOS) {
      Directory appDocDir =
          Directory(''); //await getApplicationDocumentsDirectory();
      String path = p.join(appDocDir.path, directory, '$snapshot.png');
      File createdFile = await File(path).create(recursive: true);
      await createdFile.writeAsBytes(pngBytes!.buffer.asInt8List());
    } else {
      await File('$directory/$snapshot.png')
          .writeAsBytes(pngBytes!.buffer.asInt8List());
    }
  }

  @override
  bool shouldRepaint(SubtitlePainter oldDelegate) {
    return oldDelegate.propertyPaddingLeft != propertyPaddingLeft ||
        oldDelegate.propertyPaddingRight != propertyPaddingRight ||
        oldDelegate.propertyPaddingTop != propertyPaddingTop ||
        oldDelegate.propertyPaddingBottom != propertyPaddingBottom ||
        oldDelegate.propertyFontSize != propertyFontSize ||
        oldDelegate.propertyFontColor != propertyFontColor ||
        oldDelegate.propertyFontFamily != propertyFontFamily ||
        oldDelegate.propertyBorderWidth != propertyBorderWidth ||
        oldDelegate.propertyBorderColor != propertyBorderColor ||
        oldDelegate.propertyShadowX != propertyShadowX ||
        oldDelegate.propertyShadowY != propertyShadowY ||
        oldDelegate.propertyShadowSpread != propertyShadowSpread ||
        oldDelegate.propertyShadowBlur != propertyShadowBlur ||
        oldDelegate.propertyShadowColor != propertyShadowColor ||
        oldDelegate.verticalAlignment != verticalAlignment ||
        oldDelegate.horizontalAlignment != horizontalAlignment ||
        oldDelegate.propertyCanvasResolutionX != propertyCanvasResolutionX ||
        oldDelegate.propertyCanvasResolutionY != propertyCanvasResolutionY ||
        oldDelegate.propertyCanvasBackgroundColor !=
            propertyCanvasBackgroundColor ||
        oldDelegate.isDrawCanvasBg != isDrawCanvasBg ||
        oldDelegate.translation != translation ||
        oldDelegate.scaleOffset != scaleOffset ||
        oldDelegate.subtitleText != subtitleText;
  }
}
