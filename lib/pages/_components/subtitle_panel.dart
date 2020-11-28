import 'dart:async';
import 'dart:io';
import 'dart:math' as Math;
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pedantic/pedantic.dart';
import 'package:subtitle_wand/design/color_palette.dart';
import 'package:subtitle_wand/pages/_components/subtitle_panel_controller.dart';
import 'package:subtitle_wand/utilities/logger_util.dart';

/// Which way for Subtitle to align horizontally.
enum SubtitleHorizontalAlignment {
  Left,
  Center,
  Right
}

/// Which way for Subtitle to align Vertically
enum SubtitleVerticalAlignment {
  Top,
  Center,
  Bottom,
}

///
/// Subtitle Panel supports translation and scale.
///
class SubtitlePanel extends StatefulWidget {
  /// The painter used to draw on canvas. use It to take pictures.
  final SubtitlePainter painter;
  /// The span represent the content to render.
  final InlineSpan span;
  /// The resolution of canvas, give an full width as video desired, and suitable height will lead to goods mostly.
  final Size canvasResolution;
  /// The background color of canvas, will not be rendered in the canvas
  final Color canvasBackgroundColor;

  final SubtitlePanelScrollController scrollController;

  final SubtitlePanelMoveController moveController;

  /// Creates a Subtitle panel.
  ///
  /// The [painter] must not be null. 
  /// The [span] must not be null.
  SubtitlePanel({
    Key key,
    @required SubtitlePainter painter,
    @required InlineSpan span,
    Size canvasResolution,
    Color canvasBackgroundColor,
    SubtitlePanelMoveController pmoveController,
    SubtitlePanelScrollController pscrollController
  }) 
    :  
      assert(painter != null && span != null),
      painter = painter,
      span = span,
      canvasResolution = canvasResolution ?? Size(1024, 768),
      canvasBackgroundColor = canvasBackgroundColor,
      moveController = pmoveController ?? SubtitlePanelMoveController(Offset.zero),
      scrollController = pscrollController ?? SubtitlePanelScrollController(0),
      super(key: key);

  @override
  _SubtitlePanelState createState() => _SubtitlePanelState();
}

class _SubtitlePanelState extends State<SubtitlePanel> {
  SubtitlePainter _painter;
  bool isTapped = false;

  @override
  void initState() { 
    super.initState();
    _painter = widget.painter;
    _painter.update(span: widget.span, canvasResolution: widget.canvasResolution);
    widget.moveController.addListener(() {
      setState(() {});
    });
    widget.scrollController.addListener(() {
      setState(() {});
    });
  }

  @override
  void didUpdateWidget(SubtitlePanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    _painter.update(span: widget.span, canvasResolution: widget.canvasResolution, canvasBackgroundColor: widget.canvasBackgroundColor);
  }

  @override
  void dispose() { 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
        _painter.update(
          scaleOffset: widget.scrollController.value,
          translation: widget.moveController.value
        );

        return Container(
          child: Stack(
            children: <Widget>[
              LayoutBuilder(
                builder: (context, constraints) {
                  return CustomPaint(
                    size: Size(constraint.maxWidth, constraint.maxHeight),
                    painter: _painter,
                  );
                }
              ),
              Listener(
                onPointerDown: (pointer) {
                  isTapped = true;
                  setState(() {});
                },
                onPointerMove: (pointer) {
                  setState(() {});
                  widget.moveController.value -= pointer.delta;
                },
                onPointerUp: (pointer) {
                  isTapped = false;
                  setState(() {});
                },
                onPointerSignal: (pointer) {
                  if(pointer is PointerScrollEvent) {
                    widget.scrollController.value = Math.max(0.0, widget.scrollController.value + (pointer.scrollDelta.dy / 1000));
                    setState(() {});
                  }
                },
                child: Container(
                  color: Colors.transparent,
                )
              ),
            ],
          )
        );
      }
    );
  }
}

///
/// The painter used to render whole canvas.
///
class SubtitlePainter extends CustomPainter {
  TextPainter _textPainter;
  EdgeInsets _padding = EdgeInsets.only(left: 8, right: 8, top: 16, bottom: 16);
  SubtitlePainter()
    : _textPainter = TextPainter(textDirection: TextDirection.ltr,);

  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = Offset.zero & _canvasResolution;

    double scaleX = _canvasResolution.width / size.width; 
    double scaleY = _canvasResolution.height / size.height;
    double scale =  1.0 / Math.max(scaleX, scaleY);
    // Maximum canvas size that keep ratio and fit in Area
    double scaledWidth = _canvasResolution.width * scale;
    double scaledHeight = _canvasResolution.height * scale;

    // Check size difference
    double originOffsetX = (size.width - scaledWidth) / 2;
    double originOffsetY = (size.height - scaledHeight) / 2;

    // draw full background
    canvas.drawRect(Offset.zero & size, Paint()..color = Colors.black);

    // save and create a new canvas/transition for actual CANVAS
    canvas.saveLayer(null, Paint());
    canvas.translate(-_translation.dx, -_translation.dy);
    canvas.translate(originOffsetX, originOffsetY);
    canvas.scale(scale + (_scaleOffset ?? 0));

    // draw cancas background
    if(_isRenderBackground) {
      canvas.drawRect(rect, Paint()..shader = LinearGradient(
        colors:  [_canvasBackgroundColor, _canvasBackgroundColor] // [const Color(0xFFFFFF00), const Color(0xFFffffff)],
      ).createShader(rect));
    }

    // draw shadow
    TextSpan originalSpan = _textPainter.text as TextSpan;
    if(_shadows != null && _shadows.isNotEmpty) {
      TextSpan shadowSpan = TextSpan(text: originalSpan.text, style: originalSpan.style.copyWith( 
          shadows: _shadows
        )
      );
      _textPainter.text = shadowSpan;
      _textPainter.layout(minWidth: _canvasResolution.width - _padding.right, maxWidth: _canvasResolution.width - _padding.right);
      if(_subtitleAlignment == SubtitleVerticalAlignment.Top) _textPainter.paint(canvas, Offset(_padding.left, _padding.top));
      if(_subtitleAlignment == SubtitleVerticalAlignment.Center) _textPainter.paint(canvas, Offset(_padding.left, _canvasResolution.height / 2 - _textPainter.height / 2));
      if(_subtitleAlignment == SubtitleVerticalAlignment.Bottom) _textPainter.paint(canvas, Offset(_padding.left, _canvasResolution.height - _textPainter.height - _padding.bottom));
    }

    // draw text border
    if(_borderPaint != null && _borderPaint.strokeWidth > 0) {
      TextSpan borderSpan = TextSpan(text: originalSpan.text, style: originalSpan.style.copyWith(
        foreground: _borderPaint));
      _textPainter.text = borderSpan;
      _textPainter.layout(minWidth: _canvasResolution.width - _padding.right, maxWidth: _canvasResolution.width - _padding.right);
      if(_subtitleAlignment == SubtitleVerticalAlignment.Top) _textPainter.paint(canvas, Offset(_padding.left, _padding.top));
      if(_subtitleAlignment == SubtitleVerticalAlignment.Center) _textPainter.paint(canvas, Offset(_padding.left, _canvasResolution.height / 2 - _textPainter.height / 2));
      if(_subtitleAlignment == SubtitleVerticalAlignment.Bottom) _textPainter.paint(canvas, Offset(_padding.left, _canvasResolution.height - _textPainter.height - _padding.bottom));
    }

    // draw text
    _textPainter.text = originalSpan;
    _textPainter.layout(minWidth: _canvasResolution.width - _padding.right, maxWidth: _canvasResolution.width - _padding.right);
    if(_subtitleAlignment == SubtitleVerticalAlignment.Top) _textPainter.paint(canvas, Offset(_padding.left, _padding.top));
    if(_subtitleAlignment == SubtitleVerticalAlignment.Center) _textPainter.paint(canvas, Offset(_padding.left, _canvasResolution.height / 2 - _textPainter.height / 2));
    if(_subtitleAlignment == SubtitleVerticalAlignment.Bottom) _textPainter.paint(canvas, Offset(_padding.left, _canvasResolution.height - _textPainter.height - _padding.bottom));
    
    canvas.restore();
  }

  bool _update = true;
  Size _canvasResolution = Size(1024, 768);
  SubtitleVerticalAlignment _subtitleAlignment = SubtitleVerticalAlignment.Top;
  Paint _borderPaint;
  List<Shadow> _shadows;
  bool _isRenderBackground = true;
  Color _canvasBackgroundColor = ColorPalette.secondaryColor;

  double _scaleOffset = 0;
  Offset _translation = Offset(0, 0);

  ///
  /// update the [span], which should have been used as subtitle span.
  /// 
  /// [subtitleHorizontalAlignment] for textAlign in horizontal in canvas.
  /// [subtitleAlignment] for verical algin in canvas.
  /// [padding] prevent subtitle from touching edge and give suitable area.
  /// [borderPaint], which should describe all painting style, wiil be positioned at lowest layer.
  /// [shadows], which support multi shadow, but currently can't work well with border.
  void update({
    InlineSpan span,
    Size canvasResolution,
    // TextAlign align,
    SubtitleHorizontalAlignment subtitleHorizontalAlignment,
    SubtitleVerticalAlignment subtitleAlignment,
    EdgeInsets padding,
    Paint borderPaint,
    List<Shadow> shadows,
    bool isRenderBackground,
    Color canvasBackgroundColor,
    double scaleOffset,
    Offset translation,
  }) {
    if(subtitleHorizontalAlignment != null) {
      TextAlign align = TextAlign.center;
      if(subtitleHorizontalAlignment == SubtitleHorizontalAlignment.Left) align = TextAlign.left;
      if(subtitleHorizontalAlignment == SubtitleHorizontalAlignment.Right) align = TextAlign.right;
      _textPainter = TextPainter(textDirection: TextDirection.ltr, textAlign: align, text: span);
    }
    if(subtitleAlignment != null) _subtitleAlignment = subtitleAlignment;
    if(span != null) _textPainter.text = span;
    if(canvasResolution != null) _canvasResolution = canvasResolution;
    if(padding != null) _padding = padding;
    if(borderPaint != null) _borderPaint = borderPaint;
    if(shadows != null) _shadows = shadows;
    if(isRenderBackground != null) _isRenderBackground = isRenderBackground;
    if(canvasBackgroundColor != null) _canvasBackgroundColor = canvasBackgroundColor;
    if(scaleOffset != null) _scaleOffset = scaleOffset;
    if(translation != null) _translation = translation;
    _update = true;
  }

  ///
  /// save image with [canvasSize] and transform to [resolutionSize],
  /// and will be saved in [directory], the name is [snapshot].png
  ///
  Future<void> saveImage(Size canvasSize, Size resolutionSize, String directory, String snapshot) async {
    PictureRecorder recorder = PictureRecorder();
    Canvas canvas = Canvas(recorder);

    bool originalSettingBackground = _isRenderBackground;
    _isRenderBackground = false;
    
    paint(canvas, canvasSize);

    _isRenderBackground = originalSettingBackground;
    
    Image image = await recorder.endRecording().toImage(resolutionSize.width.toInt(), resolutionSize.height.toInt());
    var pngBytes = await image.toByteData(format: ImageByteFormat.png);

    // create folder first, but no mac, mac will create file with folders
    if(!Platform.isMacOS && !await Directory('$directory').exists()) {
      await Directory('$directory').create();
    }

    if(Platform.isMacOS) {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String path = p.join(appDocDir.path, '$directory', '$snapshot.png');
      File createdFile = await File('$path').create(recursive: true);
      await createdFile.writeAsBytes(pngBytes.buffer.asInt8List());
      unawaited(LoggerUtil.getInstance().log('createFile: $path'));
    } else {
      await File('$directory/$snapshot.png').writeAsBytes(pngBytes.buffer.asInt8List());
      unawaited(LoggerUtil.getInstance().log('createFile: $directory/$snapshot.png'));
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    bool isNeedUpdated = _update;
    _update = false;
    return isNeedUpdated;
  }
}