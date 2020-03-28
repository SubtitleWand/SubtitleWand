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
import 'package:subtitle_wand/utilities/logger_util.dart';

/// Which way for Subtitle to align horizontally.
enum SubtitleHorizontalAlignment {
  Left,
  Center,
  Right
}

/// Which way for Subtitle to align Vertically
enum SubtitleVerticalAlignment {
  // topLeft,
  // topCenter,
  // topRight,
  // centerLeft,
  Top,
  Center,
  Bottom,
  // centerRight,
  // bottomLeft,
  // bottomCenter,
  // bottomRight,
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
  }) 
    :  
      assert(painter != null && span != null),
      painter = painter,
      span = span,
      canvasResolution = canvasResolution ?? Size(1024, 768),
      canvasBackgroundColor = canvasBackgroundColor,
      super(key: key);

  @override
  _SubtitlePanelState createState() => _SubtitlePanelState();
}

class _SubtitlePanelState extends State<SubtitlePanel> {
  SubtitlePainter _painter;
  ScrollController _scaleScroller;
  Offset _translation = Offset(0, 0);
  bool isTapped = false;

  @override
  void initState() { 
    super.initState();
    _painter = widget.painter;
    _painter.update(span: widget.span, canvasResolution: widget.canvasResolution);
    _scaleScroller = ScrollController(initialScrollOffset: 0);
    _scaleScroller.addListener((){
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
    _scaleScroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Size renderSize = context.size;
    // 1920 / 500 = 3.x 用 3.x 去縮
    // 1080 / 500 = 2.x
    // 800 / 500 = 1.6
    // 900 / 500 = 1.8 用 1.8 縮
    // double scaleX = widget.canvasResolution.width / renderSize.width; 
    // double scaleY = widget.canvasResolution.height / renderSize.height;
    return LayoutBuilder(
      builder: (context, constraint) {
        double scaleX = widget.canvasResolution.width / constraint.biggest.width; 
        double scaleY = widget.canvasResolution.height / constraint.biggest.height;
        double scale =  1.0 / Math.max(scaleX, scaleY);
        double scaledWidth = widget.canvasResolution.width * scale;
        double scaledHeight = widget.canvasResolution.height * scale;
        double mouseScaler =  (_scaleScroller.hasClients ? (_scaleScroller.offset / 500) + 1.0 : 1.0);
        double finalScale = scale * mouseScaler;

        double widthTranslateMaximum = (scaledWidth * mouseScaler - scaledWidth).floorToDouble();
        double heightTranslateMaximum = (scaledHeight * mouseScaler - scaledHeight).floorToDouble();

        _translation = Offset(
          -Math.min(widthTranslateMaximum, _translation.dx > 0 ? 0.0 : _translation.dx.abs()),
          -Math.min(heightTranslateMaximum, _translation.dy > 0 ? 0.0 : _translation.dy.abs())
        );

        return Container(
          child: Stack(
            children: <Widget>[
              Transform.translate(
                offset: Offset(
                  scaleX > scaleY ? 0 : (constraint.biggest.width - scaledWidth) / 2,
                  scaleX < scaleY ? 0 : (constraint.biggest.height - scaledHeight) / 2,
                ) + _translation,
                child: Transform.scale(
                  alignment: Alignment.topLeft,
                  scale: finalScale,
                  child: CustomPaint(
                    size: widget.canvasResolution,
                    painter: _painter,
                  )
                )
              ),
              Positioned.fromRect(
                rect: scaleY > scaleX ? 
                  Offset((constraint.biggest.width - scaledWidth) / 2, 0) & Size(scaledWidth, scaledHeight)
                  :
                  Offset(0, (constraint.biggest.height - scaledHeight) / 2) & Size(scaledWidth, scaledHeight),
                // child: NotificationListener(
                //   onNotification: (notification) {
                //     setState(() {});
                //     return false;
                //   },
                //   child: SingleChildScrollView(
                //     controller: _scaleScroller,
                //     physics: isTapped ? NeverScrollableScrollPhysics() : AlwaysScrollableScrollPhysics(),
                //     child: Container(
                //       width: scaledWidth,
                //       height: scaledHeight + 1000, // 50 per scroll
                //       color: Colors.transparent,
                //     )
                //   )
                // )
                child: Listener(
                  onPointerDown: (pointer) {
                    isTapped = true;
                    setState(() {});
                  },
                  onPointerMove: (pointer) {
                    // if(pointer.delta.distance < 10)
                    //   return;
                    //if(pointer.delta.distance)
                    setState(() {});
                    _translation += pointer.delta;
                  },
                  onPointerUp: (pointer) {
                    isTapped = false;
                    setState(() {});
                  },
                  child: SingleChildScrollView(
                    controller: _scaleScroller,
                    physics: isTapped ? NeverScrollableScrollPhysics() : AlwaysScrollableScrollPhysics(),
                    child: Container(
                      width: scaledWidth,
                      height: scaledHeight + 1000, // 50 per scroll
                      color: Colors.transparent,
                    )
                  )
                ),
              ),
              // Positioned.fromRect(
              //   rect: scaleY > scaleX ? 
              //     Offset((constraint.biggest.width - scaledWidth) / 2, 0) & Size(scaledWidth, scaledHeight)
              //     :
              //     Offset(0, (constraint.biggest.height - scaledHeight) / 2) & Size(scaledWidth, scaledHeight),
              //   child: GestureDetector(
              //     onTapDown: (tap){
              //       isTapped = true; 
              //       setState(() {
              //       });
              //     },
              //     onTapUp: (tap){
              //       isTapped = false; 
              //       setState(() {
              //       });
              //     },
              //     onPanUpdate: (pan) {
              //       //print(pan);
              //       //isTapped = true;
              //       _translation += pan.delta;
              //       _translation = new Offset(
              //         Math.min(widthTranslateMaximum, _translation.dx.abs()).roundToDouble(),
              //         Math.min(heightTranslateMaximum, _translation.dy.abs()).roundToDouble()
              //       );
              //       setState(() {
              //       });
              //       //_painter.update(translate: _translation);
              //     },
              //     child: Container(color: Colors.transparent,),
              //   ),
              // ),
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
    var rect = Offset.zero & _canvasResolution;

    if(_isRenderBackground) {
      canvas.drawRect(rect, Paint()..shader = LinearGradient(
        colors:  [_canvasBackgroundColor, _canvasBackgroundColor] // [const Color(0xFFFFFF00), const Color(0xFFffffff)],
      ).createShader(rect));
    }
      // canvas.drawRect(rect, Paint()..shader = RadialGradient(
      //   center: const Alignment(0.7, -0.6),
      //   radius: 0.2,
      //   colors:  [const Color(0xFFFFFF00), const Color(0xFFffffff)],
      //   stops: [0.4, 1.0],
      // ).createShader(rect));

    TextSpan originalSpan = _textPainter.text as TextSpan;
    if(_shadows != null && _shadows.isNotEmpty) {
      // print("paint shadow");
      TextSpan shadowSpan = TextSpan(text: originalSpan.text, style: originalSpan.style.copyWith(
        /*foreground: _borderPaint != null ? _borderPaint : null,*/ shadows: _shadows));
      _textPainter.text = shadowSpan;
      _textPainter.layout(minWidth: _canvasResolution.width - _padding.right, maxWidth: _canvasResolution.width - _padding.right);
      if(_subtitleAlignment == SubtitleVerticalAlignment.Top) _textPainter.paint(canvas, Offset(_padding.left, _padding.top));
      if(_subtitleAlignment == SubtitleVerticalAlignment.Center) _textPainter.paint(canvas, Offset(_padding.left, _canvasResolution.height / 2 - _textPainter.height / 2));
      if(_subtitleAlignment == SubtitleVerticalAlignment.Bottom) _textPainter.paint(canvas, Offset(_padding.left, _canvasResolution.height - _textPainter.height - _padding.bottom));
    }

    if(_borderPaint != null && _borderPaint.strokeWidth > 0) {
      //print("paint border");
      TextSpan borderSpan = TextSpan(text: originalSpan.text, style: originalSpan.style.copyWith(
        foreground: _borderPaint));
      _textPainter.text = borderSpan;
      _textPainter.layout(minWidth: _canvasResolution.width - _padding.right, maxWidth: _canvasResolution.width - _padding.right);
      if(_subtitleAlignment == SubtitleVerticalAlignment.Top) _textPainter.paint(canvas, Offset(_padding.left, _padding.top));
      if(_subtitleAlignment == SubtitleVerticalAlignment.Center) _textPainter.paint(canvas, Offset(_padding.left, _canvasResolution.height / 2 - _textPainter.height / 2));
      if(_subtitleAlignment == SubtitleVerticalAlignment.Bottom) _textPainter.paint(canvas, Offset(_padding.left, _canvasResolution.height - _textPainter.height - _padding.bottom));
    }

    _textPainter.text = originalSpan;
    _textPainter.layout(minWidth: _canvasResolution.width - _padding.right, maxWidth: _canvasResolution.width - _padding.right);
    if(_subtitleAlignment == SubtitleVerticalAlignment.Top) _textPainter.paint(canvas, Offset(_padding.left, _padding.top));
    if(_subtitleAlignment == SubtitleVerticalAlignment.Center) _textPainter.paint(canvas, Offset(_padding.left, _canvasResolution.height / 2 - _textPainter.height / 2));
    if(_subtitleAlignment == SubtitleVerticalAlignment.Bottom) _textPainter.paint(canvas, Offset(_padding.left, _canvasResolution.height - _textPainter.height - _padding.bottom));
  }

  bool _update = true;
  Size _canvasResolution = Size(1024, 768);
  SubtitleVerticalAlignment _subtitleAlignment = SubtitleVerticalAlignment.Top;
  Paint _borderPaint;
  List<Shadow> _shadows;
  bool _isRenderBackground = true;
  Color _canvasBackgroundColor = ColorPalette.secondaryColor;

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
  }) {
    if(subtitleHorizontalAlignment != null) {
      TextAlign align = TextAlign.center;
      if(subtitleHorizontalAlignment == SubtitleHorizontalAlignment.Left) align = TextAlign.left;
      if(subtitleHorizontalAlignment == SubtitleHorizontalAlignment.Right) align = TextAlign.right;
      this._textPainter = TextPainter(textDirection: TextDirection.ltr, textAlign: align, text: span);
    }
    if(subtitleAlignment != null) this._subtitleAlignment = subtitleAlignment;
    if(span != null) this._textPainter.text = span;
    if(canvasResolution != null) this._canvasResolution = canvasResolution;
    if(padding != null) this._padding = padding;
    if(borderPaint != null) this._borderPaint = borderPaint;
    if(shadows != null) this._shadows = shadows;
    if(isRenderBackground != null) this._isRenderBackground = isRenderBackground;
    if(canvasBackgroundColor != null) this._canvasBackgroundColor = canvasBackgroundColor;
    _update = true;
  }

  ///
  /// save image with [canvasSize] and transform to [resolutionSize],
  /// and will be saved in [directory], the name is [snapshot].png
  ///
  Future<void> saveImage(Size canvasSize, Size resolutionSize, String directory, String snapshot) async {
    PictureRecorder recorder = PictureRecorder();
    Canvas canvas = Canvas(recorder);

    bool originalSettingBackground = this._isRenderBackground;
    this._isRenderBackground = false;
    
    this.paint(canvas, canvasSize);

    this._isRenderBackground = originalSettingBackground;
    
    Image image = await recorder.endRecording().toImage(resolutionSize.width.toInt(), resolutionSize.height.toInt());
    var pngBytes = await image.toByteData(format: ImageByteFormat.png);

    // create folder first, but no mac, mac will create file with folders
    if(!Platform.isMacOS && !await Directory("$directory").exists()) {
      await Directory("$directory").create();
    }

    if(Platform.isMacOS) {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String path = p.join(appDocDir.path, "$directory", "$snapshot.png");
      File createdFile = await File('$path').create(recursive: true);
      await createdFile.writeAsBytes(pngBytes.buffer.asInt8List());
      unawaited(LoggerUtil.getInstance().log("createFile: $path"));
    } else {
      await File('$directory/$snapshot.png').writeAsBytes(pngBytes.buffer.asInt8List());
      unawaited(LoggerUtil.getInstance().log("createFile: $directory/$snapshot.png"));
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    bool isNeedUpdated = _update;
    _update = false;
    return isNeedUpdated;
  }
}