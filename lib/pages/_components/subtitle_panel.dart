import 'dart:async';
import 'dart:io';
import 'dart:math' as Math;
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:subtitle_wand/design/color_palette.dart';

class SubtitlePanel extends StatefulWidget {
  final SubtitlePainter _painter;
  final InlineSpan _span;
  final Size _canvasResolution;
  final Color _canvasBackgroundColor;
  SubtitlePanel({
    Key key,
    @required SubtitlePainter painter,
    @required InlineSpan span,
    Size canvasResolution,
    Color canvasBackgroundColor,
  }) 
    :  
      assert(painter != null && span != null),
      _painter = painter,
      _span = span,
      _canvasResolution = canvasResolution ?? Size(1024, 768),
      _canvasBackgroundColor = canvasBackgroundColor,
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
    _painter = widget._painter;
    _painter.update(span: widget._span, canvasResolution: widget._canvasResolution);
    _scaleScroller = ScrollController(initialScrollOffset: 0);
    _scaleScroller.addListener((){
      print("update view");
      setState(() {});
    });
  }

  @override
  void didUpdateWidget(SubtitlePanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    _painter.update(span: widget._span, canvasResolution: widget._canvasResolution, canvasBackgroundColor: widget._canvasBackgroundColor);
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
    // double scaleX = widget._canvasResolution.width / renderSize.width; 
    // double scaleY = widget._canvasResolution.height / renderSize.height;
    return LayoutBuilder(
      builder: (context, constraint) {
        double scaleX = widget._canvasResolution.width / constraint.biggest.width; 
        double scaleY = widget._canvasResolution.height / constraint.biggest.height;
        double scale =  1.0 / Math.max(scaleX, scaleY);
        double scaledWidth = widget._canvasResolution.width * scale;
        double scaledHeight = widget._canvasResolution.height * scale;
        double mouseScaler =  (_scaleScroller.hasClients ? (_scaleScroller.offset / 500) + 1.0 : 1.0);
        double finalScale = scale * mouseScaler;
        print(mouseScaler);
        double widthTranslateMaximum = (scaledWidth * mouseScaler - scaledWidth).floorToDouble();
        double heightTranslateMaximum = (scaledHeight * mouseScaler - scaledHeight).floorToDouble();
        print("$widthTranslateMaximum, $heightTranslateMaximum");

        print(_translation);
        _translation = Offset(
          -Math.min(widthTranslateMaximum, _translation.dx > 0 ? 0.0 : _translation.dx.abs()),
          -Math.min(heightTranslateMaximum, _translation.dy > 0 ? 0.0 : _translation.dy.abs())
        );
        print(_translation);

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
                    size: widget._canvasResolution,
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
                    print("down");
                    print(pointer.localPosition);
                    setState(() {});
                  },
                  onPointerMove: (pointer) {
                    print("move: ${pointer.delta.distance}");
                    // if(pointer.delta.distance < 10)
                    //   return;
                    //if(pointer.delta.distance)
                    setState(() {});
                    _translation += pointer.delta;
                  },
                  onPointerUp: (pointer) {
                    isTapped = false;
                    setState(() {});
                    print("up");
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

enum SubtitleVerticleAlignment {
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
      if(_subtitleAlignment == SubtitleVerticleAlignment.Top) _textPainter.paint(canvas, Offset(_padding.left, _padding.top));
      if(_subtitleAlignment == SubtitleVerticleAlignment.Center) _textPainter.paint(canvas, Offset(_padding.left, _canvasResolution.height / 2 - _textPainter.height / 2));
      if(_subtitleAlignment == SubtitleVerticleAlignment.Bottom) _textPainter.paint(canvas, Offset(_padding.left, _canvasResolution.height - _textPainter.height - _padding.bottom));
    }

    if(_borderPaint != null && _borderPaint.strokeWidth > 0) {
      //print("paint border");
      TextSpan borderSpan = TextSpan(text: originalSpan.text, style: originalSpan.style.copyWith(
        foreground: _borderPaint));
      _textPainter.text = borderSpan;
      _textPainter.layout(minWidth: _canvasResolution.width - _padding.right, maxWidth: _canvasResolution.width - _padding.right);
      if(_subtitleAlignment == SubtitleVerticleAlignment.Top) _textPainter.paint(canvas, Offset(_padding.left, _padding.top));
      if(_subtitleAlignment == SubtitleVerticleAlignment.Center) _textPainter.paint(canvas, Offset(_padding.left, _canvasResolution.height / 2 - _textPainter.height / 2));
      if(_subtitleAlignment == SubtitleVerticleAlignment.Bottom) _textPainter.paint(canvas, Offset(_padding.left, _canvasResolution.height - _textPainter.height - _padding.bottom));
    }

    _textPainter.text = originalSpan;
    _textPainter.layout(minWidth: _canvasResolution.width - _padding.right, maxWidth: _canvasResolution.width - _padding.right);
    if(_subtitleAlignment == SubtitleVerticleAlignment.Top) _textPainter.paint(canvas, Offset(_padding.left, _padding.top));
    if(_subtitleAlignment == SubtitleVerticleAlignment.Center) _textPainter.paint(canvas, Offset(_padding.left, _canvasResolution.height / 2 - _textPainter.height / 2));
    if(_subtitleAlignment == SubtitleVerticleAlignment.Bottom) _textPainter.paint(canvas, Offset(_padding.left, _canvasResolution.height - _textPainter.height - _padding.bottom));
  }

  bool _update = true;
  Size _canvasResolution = Size(1024, 768);
  SubtitleVerticleAlignment _subtitleAlignment = SubtitleVerticleAlignment.Top;
  Paint _borderPaint;
  List<Shadow> _shadows;
  bool _isRenderBackground = true;
  Color _canvasBackgroundColor = ColorPalette.secondaryColor;
  void update({
    InlineSpan span,
    Size canvasResolution,
    TextAlign align,
    SubtitleVerticleAlignment subtitleAlignment,
    EdgeInsets padding,
    Paint borderPaint,
    List<Shadow> shadows,
    bool isRenderBackground,
    Color canvasBackgroundColor,
  }) {
    if(align != null) this._textPainter = TextPainter(textDirection: TextDirection.ltr, textAlign: align, text: span);
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

  Future<void> saveImage(Size canvasSize, Size resolutionSize, String directory, String snapshot) async {
    PictureRecorder recorder = PictureRecorder();
    Canvas canvas = Canvas(recorder);

    bool originalSettingBackground = this._isRenderBackground;
    this._isRenderBackground = false;
    
    this.paint(canvas, canvasSize);

    this._isRenderBackground = originalSettingBackground;
    
    Image image = await recorder.endRecording().toImage(resolutionSize.width.toInt(), resolutionSize.height.toInt());
    var pngBytes = await image.toByteData(format: ImageByteFormat.png);
    if(!await Directory("$directory").exists()) {
      print("createDirectory");
      await Directory("$directory").create();
    }
    print(Directory.current.toString());
    await File('${Directory.current.path}\\$directory\\$snapshot.png').writeAsBytes(pngBytes.buffer.asInt8List());
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    bool isNeedUpdated = _update;
    _update = false;
    return isNeedUpdated;
  }
}