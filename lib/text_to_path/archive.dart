
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:subtitle_wand/model/font_manager.dart';
import 'package:subtitle_wand/model/subtitle_panel.dart';
import 'package:subtitle_wand/text_to_path/src/pm_animation_utils.dart';
import 'package:subtitle_wand/text_to_path/src/pm_font.dart';
import 'package:subtitle_wand/text_to_path/src/pm_font_reader.dart';
import 'package:subtitle_wand/text_to_path/src/pm_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:utf/utf.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  TextEditingController _controller;
  SubtitlePainter _painter;
  FontManager _fontManager;

  double _leftPadding = 8;
  double _rightPadding = 8;
  double _topPadding = 16;
  double _bottomPadding = 16;

  int _fontSize = 28;
  Color _fontColor = Colors.black;
  int _borderSize = 0;
  Color _borderColor = Colors.white;
  int _shadowThickness = 0;

  Map<int, List<TextSpan>> _spans;
  @override
  void initState() {
    super.initState();
    _controller = new TextEditingController();
    _painter = new SubtitlePainter();
    _fontManager = new FontManager();
    _fontManager.addFont("myfont", "resources\\TW\\GenSenMaruGothicTW-Regular.ttf").then((_) {
      setState((){});
    });
    _spans = new Map<int, List<TextSpan>>();
    _controller.addListener((){
      setState((){});
      print(_controller.text);
      print("length: ${_controller.text.split("\n").length}");
    });
  }

  EdgeInsets getPadding({
    double left,
    double right,
    double top,
    double bottom,
  }) {
    _leftPadding = left ?? _leftPadding;
    _rightPadding = right ?? _rightPadding;
    _topPadding = top ?? _topPadding;
    _bottomPadding = bottom ?? _bottomPadding;
    return EdgeInsets.only(
      left: _leftPadding,
      right: _rightPadding,
      top: _topPadding,
      bottom: _bottomPadding,
    );
  }

  // FontLoader font;
  // MyCustomPainter _painter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                color: Colors.green,
                // child: CustomPaint(
                //   painter: _painter,
                //   size: Size.infinite,
                // ),
                child: Align(
                  alignment: Alignment.center,
                  child: SubtitlePanel(
                    painter: _painter,
                    span: TextSpan(
                      text: "${_controller.text}",
                        // TextSpan(
                        //   text: ".....三國............?${_controller.text}"
                        // ),
                        // TextSpan(
                        //   text: "南去經三國s，s東來過五湖",
                        // )
                      style: TextStyle(
                        fontFamily: "myfont",
                        color: _fontColor,
                        fontSize: _fontSize.toDouble(),
                        // background: Paint()
                        //   ..style = PaintingStyle.stroke
                        //   ..strokeWidth = _borderSize.toDouble()
                        //   ..color = _borderColor,
                      )
                    ),
                    canvasResolution: Size(1920, 1080),
                  ),
                )
              )
            ),
            Container(
              width: 200,
              color: Colors.orange,
              child: ListView(
                //mainAxisSize: MainAxisSize.min,
                children: [
                  // Text(_controller.text ?? "", style: TextStyle(fontFamily: font != null ? "myfont" : null),),
                  // SizedBox(
                  //   width: 100,
                  //   child: TextFormField(controller: _controller,),
                  // ),
                  FlatButton(
                    child: Text("Save image"),
                    onPressed: () async {
                      await _painter.saveImage(context.size, Size(1920, 1080), "results", "snapshot_v2");
                    },
                  ),
                  SizedBox.fromSize(
                    size: Size(160, 160),
                    child: ListView(
                      shrinkWrap: true,
                      children:<Widget>[
                        IconButton(iconSize: 8, icon: Icon(Icons.brightness_1), onPressed: (){
                          setState(() {
                            _painter.update(
                              subtitleAlignment: SubtitleVerticleAlignment.Top
                            );
                          });
                        },),
                        IconButton(iconSize: 8, icon: Icon(Icons.brightness_1), onPressed: (){
                          setState(() {
                            _painter.update(
                              subtitleAlignment: SubtitleVerticleAlignment.Center
                            );
                          });
                        },),
                        IconButton(iconSize: 8, icon: Icon(Icons.brightness_1), onPressed: (){
                          setState(() {
                            _painter.update(
                              subtitleAlignment: SubtitleVerticleAlignment.Bottom
                            );
                          });
                        },),
                        // IconButton(iconSize: 8, icon: Icon(Icons.brightness_1), onPressed: (){},),
                        // IconButton(iconSize: 8, icon: Icon(Icons.brightness_1), onPressed: (){},),
                        // IconButton(iconSize: 8, icon: Icon(Icons.brightness_1), onPressed: (){},),
                        // IconButton(iconSize: 8, icon: Icon(Icons.brightness_1), onPressed: (){},),
                        // IconButton(iconSize: 8, icon: Icon(Icons.brightness_1), onPressed: (){},),
                        // IconButton(iconSize: 8, icon: Icon(Icons.brightness_1), onPressed: (){},),
                      ]
                    )
                  ),
                  ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      ListTile(
                        title: Text("Left"),
                        trailing: SizedBox(
                          width: 80,
                          child: TextFormField(
                            inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                            initialValue: _leftPadding.toString(),
                            onFieldSubmitted: (text){
                              setState(() {
                                _painter.update(padding: getPadding(left: double.parse(text)));
                              });
                            },
                          ),
                        )
                      ),
                      ListTile(
                        title: Text("Right"),
                        trailing: SizedBox(
                          width: 80,
                          child: TextFormField(
                            inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                            initialValue: _rightPadding.toString(),
                            onFieldSubmitted: (text){
                              setState(() {
                                _painter.update(padding: getPadding(right: double.parse(text)));
                              }); 
                            },
                          ),
                        )
                      ),
                      ListTile(
                        title: Text("Top"),
                        trailing: SizedBox(
                          width: 80,
                          child: TextFormField(
                            inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                            initialValue: _topPadding.toString(),
                            onFieldSubmitted: (text){
                              setState(() {
                                _painter.update(padding: getPadding(top: double.parse(text)));
                              });
                            },
                          ),
                        )
                      ),
                      ListTile(
                        title: Text("Bottom"),
                        trailing: SizedBox(
                          width: 80,
                          child: TextFormField(
                            inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                            initialValue: _bottomPadding.toString(),
                            onFieldSubmitted: (text){
                              setState(() {
                                _painter.update(padding: getPadding(bottom: double.parse(text)));
                              });
                            },
                          ),
                        )
                      ),
                      ListTile(
                        title: Text("FontSize"),
                        trailing: SizedBox(
                          width: 80,
                          child: TextFormField(
                            inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                            initialValue: _fontSize.toString(),
                            onFieldSubmitted: (text){
                              setState(() {
                                _fontSize = int.parse(text);
                              });
                            },
                          ),
                        )
                      ),
                      ListTile(
                        title: Text("FontColor"),
                        trailing: SizedBox(
                          width: 80,
                          child: TextFormField(
                            maxLength: 8,
                            initialValue: _fontColor.value.toRadixString(16),
                            onFieldSubmitted: (text){
                              setState(() {
                                _fontColor = Color(int.parse(text, radix: 16));
                              });
                            },
                          ),
                        )
                      ),
                      ListTile(
                        title: Text("BorderSize"),
                        trailing: SizedBox(
                          width: 80,
                          child: TextFormField(
                            inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                            initialValue: _borderSize.toString(),
                            onFieldSubmitted: (text){
                              setState(() {
                                _borderSize = int.parse(text);
                                _painter.update(
                                  borderPaint: Paint()
                                    ..style = PaintingStyle.stroke
                                    ..strokeWidth = _borderSize.toDouble()
                                    ..color = _borderColor,
                                  );
                              });
                            },
                          ),
                        )
                      ),
                      ListTile(
                        title: Text("BorderColor"),
                        trailing: SizedBox(
                          width: 80,
                          child: TextFormField(
                            maxLength: 8,
                            initialValue: _borderColor.value.toRadixString(16),
                            onFieldSubmitted: (text){
                              setState(() {
                                _borderColor = Color(int.parse(text, radix: 16));
                                _painter.update(
                                  borderPaint: Paint()
                                    ..style = PaintingStyle.stroke
                                    ..strokeWidth = _borderSize.toDouble()
                                    ..color = _borderColor,
                                  );
                              });
                            },
                          ),
                        )
                      ),
                      ListTile(
                        title: Text("ShadowThickness"),
                        trailing: SizedBox(
                          width: 80,
                          child: TextFormField(
                            inputFormatters: [WhitelistingTextInputFormatter(RegExp(r'[\d-]+'))],
                            initialValue: _shadowThickness.toString(),
                            onFieldSubmitted: (text){
                              setState(() {
                                _shadowThickness = int.parse(text);
                                double shadow = _shadowThickness.toDouble();
                                _painter.update(
                                  shadows: [
                                    BoxShadow( // bottomLeft
                                      offset: Offset(-shadow, -shadow),
                                      color: Colors.blue,
                                      spreadRadius: 16,
                                      blurRadius: 4,
                                    ),
                                  ]
                                );
                              });
                            },
                          ),
                        )
                      ),
                    ],
                  ),
                  ButtonBar(
                    buttonMinWidth: 48,
                    children: <Widget>[
                      FlatButton(
                        child: Text("Left"),
                        onPressed: (){
                          setState(() {
                            _painter.update(align: TextAlign.left);
                          });
                        },
                      ),
                      FlatButton(
                        child: Text("Center"),
                        onPressed: (){
                          setState(() {
                            _painter.update(align: TextAlign.center);
                          });
                        },
                      ),
                      FlatButton(
                        child: Text("Right"),
                        onPressed: (){
                          setState(() {
                            _painter.update(align: TextAlign.right);
                          });
                        },
                      )
                    ],
                  ),
                  Text("Texts"),
                  SizedBox(
                    height: 240,
                    child: SingleChildScrollView(
                      child: TextField(
                        maxLines: null,
                        controller: _controller,
                      ),
                    ),
                  )
                  // FlatButton(
                  //   child: Text("Update painter"),
                  //   onPressed: () async {
                  //     _painter = MyCustomPainter(
                  //       TextPainter(
                  //         textDirection: TextDirection.ltr,
                  //         text: TextSpan(
                  //           text: "南去經三國，東來過五湖",
                  //           style: TextStyle(fontFamily: "myfont", color: Colors.black, fontSize: 28)
                  //         )
                  //       )
                  //     );
                  //     setState(() {
                  //     });
                  //   },
                  // ),
                  // FlatButton(
                  //   child: Text("Save image"),
                  //   onPressed: () async {
                  //     PictureRecorder recorder = PictureRecorder();
                  //     Canvas canvas = Canvas(recorder);
                  //     var size = context.size;
                  //     _painter.paint(canvas, size);
                  //     Image image = await recorder.endRecording().toImage(1024, 768);
                  //     var pngBytes = await image.toByteData(format: ImageByteFormat.png);
                  //     if(!await Directory("results").exists())
                  //       await Directory("results").create();
                  //     // print(Directory.current.toString());
                  //     await File('${Directory.current.path}\\results\\snapshot_v2.png').writeAsBytes(pngBytes.buffer.asInt8List());
                  //   },
                  // )
                ],
              )
            )
          ],
        )
      ),
      appBar: AppBar(title: Text("Example")),
      // floatingActionButton: FloatingActionButton(onPressed: () async {
      //   if(font == null) {
      //     font = FontLoader("myfont");
      //     File file = new File("resources\\TW\\GenSenMaruGothicTW-Regular.ttf");
      //     Uint8List list = await file.readAsBytes();
      //     font.addFont(Future.sync(() {
      //       return ByteData.view(list.buffer);
      //     }));
      //     await font.load();
      //   }
      // },),
    );
  }
}

class TextPage extends StatefulWidget {
  TextPage({Key key}) : super(key: key);

  @override
  _TextPageState createState() => _TextPageState();
}

class _TextPageState extends State<TextPage> with TickerProviderStateMixin {
  PMFont myFont;
  Path myPath1;
  Path myPath2;

  PMPieces path1Pieces;

  FontManager fontManager;

  Animation<int> animation;
  AnimationController controller;

  var z = 0;
  var ready = false;

  @override
  void initState() { 
    super.initState();
    fontManager = new FontManager();
    getFontByte("resources\\TW\\GenSenMaruGothicTW-Regular.ttf").then((ByteData data) {
      // Create a font reader
      var reader = PMFontReader();

      // Parse the font
      myFont = reader.parseTTFAsset(data);

      // Generate the complete path for a specific character
      myPath1 = myFont.generatePathForCharacter(101);

      // Move it and scale it. This is necessary because the character
      // might be too large or upside down.
      myPath1 = PMTransform.moveAndScale(myPath1, -130.0, 180.0, 0.1, 0.1);

      // Break the path into small pieces for the animation
      path1Pieces = PMPieces.breakIntoPieces(myPath1, 0.01);

      // Create an animation controller as usual
      controller =
          AnimationController(vsync: this, duration: new Duration(seconds: 2));

      // Create a tween to move through all the path pieces.
      animation = IntTween(begin: 0, end: path1Pieces.paths.length - 1)
          .animate(controller);

      animation.addListener(() {
        setState(() {
          z = animation.value;
        });
      });

      setState(() {
        ready = true;
      });
    });    
  }

  @override
  void dispose() { 
    controller.dispose();
    super.dispose();
  }

  Future<ByteData> getFontByte(String path) async {
    File file;
    try {
      file = new File("$path");
    } catch(err) {
      print(err);
      throw err;
    }
    Uint8List list = await file.readAsBytes();
    return ByteData.view(list.buffer);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Column(children: [
            Row(children: [
              RaisedButton(
                  child: Text("Forward"),
                  onPressed: ready
                      ? () {
                          controller.forward();
                        }
                      : null),
              Spacer(),
              FlatButton(
                child: Text("Test"),
                onPressed: () {
                  getFontByte("resources\\TW\\GenSenMaruGothicTW-Regular.ttf").then((ByteData data) {
                    // Create a font reader
                    var reader = PMFontReader();

                    // Parse the font
                    myFont = reader.parseTTFAsset(data);

                    // Generate the complete path for a specific character
                    List<int> codeIndex = stringToCodepoints("哈");
                    // print(decodeUtf8(codeIndex));
                    // print(codeIndex.first);
                    myPath1 = myFont.generatePathForCharacterP(codeIndex.first);

                    // Move it and scale it. This is necessary because the character
                    // might be too large or upside down.
                    myPath1 = PMTransform.moveAndScale(myPath1, -130.0, 180.0, 0.1, 0.1);

                    // Break the path into small pieces for the animation
                    path1Pieces = PMPieces.breakIntoPieces(myPath1, 0.01);

                    // Create an animation controller as usual
                    controller =
                        AnimationController(vsync: this, duration: new Duration(seconds: 2));

                    // Create a tween to move through all the path pieces.
                    animation = IntTween(begin: 0, end: path1Pieces.paths.length - 1)
                        .animate(controller);

                    animation.addListener(() {
                      setState(() {
                        z = animation.value;
                      });
                    });

                    setState(() {
                      ready = true;
                    });
                  }); 
                },
              ),
              Spacer(),
              RaisedButton(
                  child: Text("Reverse"),
                  onPressed: ready
                      ? () {
                          controller.reverse();
                        }
                      : null),
            ]),
            ready
                ? CustomPaint(
                    painter: PMPainter(path1Pieces.paths[z],
                        indicatorPosition: path1Pieces.points[z]))
                : Text("Loading")
          ]),
          padding: EdgeInsets.all(16)),
      appBar: AppBar(title: Text("Example")),
    );
  }
}