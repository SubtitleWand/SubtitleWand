// Copyright (C) 2020 Tokenyet
// 
// This file is part of subtitle-wand.
// 
// subtitle-wand is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// subtitle-wand is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with subtitle-wand.  If not, see <http://www.gnu.org/licenses/>.

import 'dart:io';
import 'dart:ui';

import 'package:configurable_expansion_tile/configurable_expansion_tile.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart'
    show describeEnum;
import 'package:flutter/material.dart' hide Image;
import 'package:flutter/services.dart' show LogicalKeyboardKey, RawKeyDownEvent, RawKeyUpEvent, RawKeyboard;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subtitle_wand/components/project/attribute_form_field.dart';
import 'package:subtitle_wand/components/project/color_picker_dialog.dart';
import 'package:subtitle_wand/design/color_palette.dart';
import 'package:subtitle_wand/pages/_components/subtitle_panel.dart';
import 'package:subtitle_wand/pages/main_page_bloc.dart' as MPB;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Subtitle Wand',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // See https://github.com/flutter/flutter/wiki/Desktop-shells#fonts
        fontFamily: 'Roboto',
        textTheme: TextTheme(
          title: TextStyle(
            color: ColorPalette.fontColor
          ),
          subtitle: TextStyle(
            color: ColorPalette.fontColor
          ),
          subhead: TextStyle(
            color: ColorPalette.fontColor
          ),
          caption: TextStyle(
            color: ColorPalette.fontColor
          ),
        )
      ),
      home: HomePage()// HomePage(),//MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

// enum SubtitleVerticleAlignment {
//   Top,
//   Center,
//   Bottom
// }

enum SubtitleHorizontalAlignment {
  Left,
  Center,
  Right
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  // Bloc
  MPB.MainPageBloc _bloc;
  // Core tool
  SubtitlePainter _painter;

  // FrameControlWidget f1 f2 keybinding UX
  Color defaultKey = Colors.white54;
  Color focusKey = Colors.white;
  Color f2Color;
  Color f1Color;

  // FrameControlWidget minimal and expand
  bool isMinimizeFrameControl = false;
  AnimationController _frameButtonController;

  // Properties
  // Properties - padding
  TextEditingController _paddingLeftTextCon;
  TextEditingController _paddingRightTextCon;
  TextEditingController _paddingTopTextCon;
  TextEditingController _paddingBottomTextCon;
  // Properties - font
  TextEditingController _fontSizeTextCon;
  // Properties - border
  TextEditingController _borderWidthTextCon;
  // Properties - shadow
  TextEditingController _offsetXTextCon;
  TextEditingController _offsetYTextCon;
  TextEditingController _spreadTextCon;
  TextEditingController _blurTextCon;
  // Properties - Aligment
  //ignore: unused_field
  SubtitleVerticleAlignment _verticleAlignment = SubtitleVerticleAlignment.Bottom;
  //ignore: unused_field
  SubtitleHorizontalAlignment _horizontalAlignment = SubtitleHorizontalAlignment.Center;
  // Properties - Canvas
  TextEditingController _canvasResolutionXTextCon;
  TextEditingController _canvasResolutionYTextCon;
  // Properties - Text
  TextEditingController _subtilteTextController;

  Widget frameControlButton(BuildContext context, {
    bool isMinimize,
    Color dynamicButtonColor,
    String title = "Untitled",
    void Function() onTap,
    IconData iconData,
  }){
    TextStyle btnTextStyle = Theme.of(context).textTheme.subtitle;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(
            //color: dynamicButtonColor,
            gradient: LinearGradient(
              stops: [0,0.15,0.85,1],
              colors: [
                ColorPalette.secondaryColor.withOpacity(dynamicButtonColor.alpha / 255),
                ColorPalette.accentColor.withOpacity(dynamicButtonColor.alpha / 255),
                ColorPalette.accentColor.withOpacity(dynamicButtonColor.alpha / 255),
                ColorPalette.secondaryColor.withOpacity(dynamicButtonColor.alpha / 255),
              ]
            ),
            border: Border.all(color: ColorPalette.secondaryColor),
            borderRadius: BorderRadius.circular(8),
          ),
          constraints: BoxConstraints(minWidth: isMinimize ? 48 : 160, minHeight: 48),
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: isMinimize ? [
              Icon(iconData, color: btnTextStyle.color,),
            ] :
            <Widget>[
              Icon(iconData, color: btnTextStyle.color,),
              SizedBox(height: 8,),
              Text("$title", textAlign: TextAlign.center, style: btnTextStyle, overflow: TextOverflow.ellipsis,),
            ],
          )
        ),
        onTap:onTap,
      )
    );
  }

  @override
  void initState() { 
    super.initState();
    _bloc = MPB.MainPageBloc();
    _painter = SubtitlePainter();

    // Controll Frame Button (Animation/Minimization)
    _frameButtonController = AnimationController(
      vsync: this, // the SingleTickerProviderStateMixin
      duration: const Duration(milliseconds: 500),
    );
    f1Color = f2Color = defaultKey;
    RawKeyboard.instance.addListener((e){
      final bool isKeyDown = e is RawKeyDownEvent;
      final bool isKeyUp = e is RawKeyUpEvent;

      bool isF2 = e.data.logicalKey == LogicalKeyboardKey.f2;
      bool isF1 = e.data.logicalKey == LogicalKeyboardKey.f1;

      if(isKeyDown) {
        if(isF1) {
          f1Color = focusKey;
          _bloc.add(MPB.PreviousFrameEvent());
        }
        if(isF2) {
          f2Color = focusKey;
          _bloc.add(MPB.NextFrameEvent());
        }
        if(isF1 || isF2) setState(() {});
      }

      if(isKeyUp) {
        if(isF1) f1Color = defaultKey;
        if(isF2) f2Color = defaultKey;
        if(isF1 || isF2) setState(() {});
      }
    });

    // Properties
    _paddingLeftTextCon = TextEditingController(text: _bloc.state.propertyPaddingLeft.toString())..addListener((){
      _bloc.add(MPB.PropertyPaddingLeftEvent(int.tryParse(_paddingLeftTextCon.text) ?? 0));
    });
    _paddingRightTextCon = TextEditingController(text: _bloc.state.propertyPaddingRight.toString())..addListener((){
      _bloc.add(MPB.PropertyPaddingRightEvent(int.tryParse(_paddingRightTextCon.text) ?? 0));
    });
    _paddingTopTextCon = TextEditingController(text: _bloc.state.propertyPaddingTop.toString())..addListener((){
      _bloc.add(MPB.PropertyPaddingBottomEvent(int.tryParse(_paddingTopTextCon.text) ?? 0));
    });
    _paddingBottomTextCon = TextEditingController(text: _bloc.state.propertyPaddingBottom.toString())..addListener((){
      _bloc.add(MPB.PropertyPaddingBottomEvent(int.tryParse(_paddingBottomTextCon.text) ?? 0));
    });
    // Properties - font
    _fontSizeTextCon = TextEditingController(text: _bloc.state.propertyFontSize.toString())..addListener((){
      _bloc.add(MPB.PropertyFontSizeEvent(int.tryParse(_fontSizeTextCon.text) ?? 0));
    });
    // Properties - border
    _borderWidthTextCon = TextEditingController(text: _bloc.state.propertyBorderWidth.toString())..addListener((){
      _bloc.add(MPB.PropertyBorderSizeEvent(int.tryParse(_borderWidthTextCon.text) ?? 0));
    });
    // Properties - shadow
    _offsetXTextCon = TextEditingController(text: _bloc.state.propertyShadowX.toString())..addListener((){
      _bloc.add(MPB.PropertyShadowOffsetXEvent(int.tryParse(_offsetXTextCon.text) ?? 0));
    });
    _offsetYTextCon = TextEditingController(text: _bloc.state.propertyShadowY.toString())..addListener((){
      _bloc.add(MPB.PropertyShadowOffsetYEvent(int.tryParse(_offsetYTextCon.text) ?? 0));
    });
    _spreadTextCon = TextEditingController(text: _bloc.state.propertyShadowSpread.toString())..addListener((){
      _bloc.add(MPB.PropertyShadowSpreadEvent(int.tryParse(_spreadTextCon.text) ?? 0));
    });
    _blurTextCon = TextEditingController(text: _bloc.state.propertyShadowBlur.toString())..addListener((){
      _bloc.add(MPB.PropertyShadowBlurEvent(int.tryParse(_blurTextCon.text) ?? 0));
    });
    // Properties - Aligment
    // SubtitleVerticleAligmnet _verticleAlignment = SubtitleVerticleAligmnet.Bottom;
    // SubtitleHorizontalAligmnet _horizontalAlignment = SubtitleHorizontalAligmnet.Center;
    // Properties - Canvas
    _canvasResolutionXTextCon = TextEditingController(text: _bloc.state.propertyCanvasResolutionX.toString())..addListener((){
      _bloc.add(MPB.PropertyCanvasResolutionXEvent(int.tryParse(_canvasResolutionXTextCon.text) ?? 0));
    });
    _canvasResolutionYTextCon = TextEditingController(text: _bloc.state.propertyCanvasResolutionY.toString())..addListener((){
      _bloc.add(MPB.PropertyCanvasResolutionYEvent(int.tryParse(_canvasResolutionYTextCon.text) ?? 0));
    });
    // Properties - Text
    _subtilteTextController = TextEditingController(text: "")..addListener((){
      _bloc.add(MPB.PropertySubtitleTextEvent(_subtilteTextController.text ?? ""));
    });
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTextStyle(
        style: TextStyle(color: ColorPalette.fontColor),
        child: Container(
          child: BlocListener<MPB.MainPageBloc, MPB.MainPageState>(
            bloc: _bloc,
            listener: (context, state) {
              TextAlign align = TextAlign.center;
              if(state.horizontalAlignment == SubtitleHorizontalAlignment.Left) align = TextAlign.left;
              if(state.horizontalAlignment == SubtitleHorizontalAlignment.Right) align = TextAlign.right;
              // print("spreadRadius: ${state.propertyShadowSpread}");
              _painter.update(
                shadows: [
                  BoxShadow( // bottomLeft
                    offset: Offset(state.propertyShadowX.toDouble(), state.propertyShadowY.toDouble()),
                    color: state.propertyShadowColor,
                    spreadRadius: state.propertyShadowSpread.toDouble(),
                    blurRadius: state.propertyShadowBlur.toDouble(),
                  ),
                ],
                padding: EdgeInsets.only(
                  left: state.propertyPaddingLeft.toDouble(),
                  right: state.propertyPaddingRight.toDouble(),
                  top: state.propertyPaddingTop.toDouble(),
                  bottom: state.propertyPaddingBottom.toDouble()
                ),
                canvasResolution: Size(state.propertyCanvasResolutionX.toDouble(), state.propertyCanvasResolutionY.toDouble()),
                borderPaint: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = state.propertyBorderWidth.toDouble()
                  ..color = state.propertyBorderColor,
                align: align,
                subtitleAlignment: state.verticalAlignment,
                canvasBackgroundColor: state.propertyCanvasBackgroundColor,
              );
              print(state.propertyCanvasBackgroundColor);
              setState(() {});
            },
            child: BlocBuilder<MPB.MainPageBloc, MPB.MainPageState>(
              bloc: _bloc,
              builder: (context, state) {
                return Column(
                  children: <Widget>[
                    Container(
                      color: ColorPalette.primaryColor,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      height: 64,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Subtitle wand", style: Theme.of(context).textTheme.title,),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              FlatButton.icon(
                                color: ColorPalette.secondaryColor,
                                textColor: ColorPalette.fontColor,
                                icon: Icon(Icons.save_alt),
                                label: Text("Save Image"),
                                onPressed: (){
                                  _bloc.add(MPB.SaveImageEvent(painter: _painter));
                                },
                              )
                            ],
                          )
                        ]
                      ),
                    ),
                    Divider(height: 1, thickness: 1, color: ColorPalette.primaryColor.withGreen(80),),
                    Expanded(
                      child: Row(
                        children: [
                          // SubtitleFrame Section
                          Expanded(
                            child: Container(
                              color: Colors.green,
                              child: ClipRect(
                                child: Stack(
                                  children: <Widget>[
                                    // Subtitle Panel
                                    Container(
                                      color: Colors.black,
                                      width: double.maxFinite,
                                      height: double.maxFinite,
                                      child: Container(
                                        color: Colors.black,
                                        child: MouseRegion(
                                          onEnter: (m) {
                                            print("enter");
                                            _frameButtonController.forward();
                                            setState(() {
                                              isMinimizeFrameControl = true;
                                            });
                                          },
                                          onExit: (m) {
                                            _frameButtonController.reverse();
                                            print("exit");
                                            setState(() {
                                              isMinimizeFrameControl = false;
                                            });
                                          },
                                          child: SubtitlePanel(
                                            painter: _painter, 
                                            canvasResolution: Size(state.propertyCanvasResolutionX.toDouble(), state.propertyCanvasResolutionY.toDouble()),
                                            span: TextSpan(
                                              text: "${state.propertySubtitleTexts.isNotEmpty ? state.propertySubtitleTexts[state.currentFrame] : ""}",
                                              style: TextStyle(
                                                fontFamily: state.propertyFontFamily,
                                                color: state.propertyFontColor,
                                                fontSize: state.propertyFontSize.toDouble(),
                                              ),
                                            ),
                                          ),
                                        )
                                      ),
                                    ),
                                    // Frame Panel
                                    Positioned(
                                      //textDirection: TextDirection.ltr,
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: Container(
                                        //duration: const Duration(milliseconds: 500),
                                        height: isMinimizeFrameControl ? 64 : 128,
                                        //width: double.maxFinite,
                                        padding: isMinimizeFrameControl ? EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0): EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
                                        decoration: BoxDecoration(
                                          color: ColorPalette.accentColor.withOpacity(0.4),
                                          borderRadius: BorderRadius.circular(4)
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            frameControlButton(
                                              context,
                                              isMinimize: isMinimizeFrameControl,
                                              dynamicButtonColor: f1Color,
                                              title: "(F1)\nPrevious Frame",
                                              iconData: Icons.keyboard_arrow_left,
                                              onTap: (){ _bloc.add(MPB.PreviousFrameEvent()); }
                                            ),
                                            frameControlButton(
                                              context,
                                              isMinimize: isMinimizeFrameControl,
                                              dynamicButtonColor: f2Color,
                                              iconData: Icons.keyboard_arrow_right,
                                              title: "(F2)\nNext Frame",
                                              onTap: (){ _bloc.add(MPB.NextFrameEvent()); }
                                            )
                                          ],
                                        ),
                                      )
                                    )
                                  ],
                                ),
                              )
                            ),
                          ),
                          VerticalDivider(
                            width: 1,
                            thickness: 1,
                            color: ColorPalette.primaryColor,
                          ),
                          // Properties Section
                          Container(
                            width: 240,
                            color: ColorPalette.primaryColor,
                            child: Theme(
                              data: Theme.of(context).copyWith(accentColor: ColorPalette.fontColor, unselectedWidgetColor:  ColorPalette.fontColor..withOpacity(0.8)),
                              child: ListView(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                children: <Widget>[
                                  SizedBox(height: 16,),
                                  Text("Properites:", style: Theme.of(context).textTheme.title,),
                                  SizedBox(height: 8,),
                                  _PageComponent.attributePanel(context,
                                    title: "Padding",
                                    children: <Widget>[
                                      _PageComponent.minimalAttribute(context, title: "Left", controller: _paddingLeftTextCon),
                                      SizedBox(height: 4,),
                                      _PageComponent.minimalAttribute(context, title: "Right", controller: _paddingRightTextCon),
                                      SizedBox(height: 4,),
                                      _PageComponent.minimalAttribute(context, title: "Top", controller: _paddingTopTextCon),
                                      SizedBox(height: 4,),
                                      _PageComponent.minimalAttribute(context, title: "Bottom", controller: _paddingBottomTextCon),
                                    ],
                                  ),
                                  SizedBox(height: 8,),
                                  _PageComponent.attributePanel(context,
                                    title: "Font",
                                    children: <Widget>[
                                      _PageComponent.minimalAttribute(context, title: "Size", controller: _fontSizeTextCon),
                                      SizedBox(height: 8,),
                                      _PageComponent.colorAttribute(context, title: "Color", onSelected: (color) => _bloc.add(MPB.PropertyFontColorEvent(color)), color: state.propertyFontColor),
                                      SizedBox(height: 12,),
                                      _PageComponent.buttonAttribute(context, title: "TTF", btnName: "Choose a file", onPressed: () async {
                                        File file = await FilePicker.getFile(type: FileType.CUSTOM, fileExtension: "ttf");
                                        if(file == null) return;
                                        _bloc.add(MPB.PropertyFontTtfEvent(file.path));
                                      }),
                                    ],
                                  ),
                                  SizedBox(height: 8,),
                                  _PageComponent.attributePanel(context,
                                    title: "Border",
                                    children: <Widget>[
                                      _PageComponent.minimalAttribute(context, title: "Width", controller: _borderWidthTextCon),
                                      SizedBox(height: 12),
                                      _PageComponent.colorAttribute(context, title: "Color", onSelected: (color) => _bloc.add(MPB.PropertyBorderColorEvent(color)), color: state.propertyBorderColor),
                                    ],
                                  ),
                                  SizedBox(height: 8,),
                                  _PageComponent.attributePanel(context,
                                    title: "Shadow",
                                    children: <Widget>[
                                      _PageComponent.minimalAttribute(context, isMinusable: true, title: "OffsetX", titleWidth: 64, controller: _offsetXTextCon),
                                      SizedBox(height: 4,),
                                      _PageComponent.minimalAttribute(context, isMinusable: true, title: "OffsetY", titleWidth: 64, controller: _offsetYTextCon),
                                      // SizedBox(height: 4,),
                                      // _PageComponent.minimalAttribute(context, title: "Spread", titleWidth: 64, controller: _spreadTextCon),
                                      SizedBox(height: 4,),
                                      _PageComponent.minimalAttribute(context, title: "Blur", titleWidth: 64, controller: _blurTextCon),
                                      SizedBox(height: 8,),
                                      _PageComponent.colorAttribute(context, title: "Color", titleWidth: 64, onSelected: (color) => _bloc.add(MPB.PropertyShadowColorEvent(color)), color: state.propertyShadowColor),
                                      SizedBox(height: 8,),
                                    ],
                                  ),
                                  SizedBox(height: 8,),
                                  _PageComponent.attributePanel(context,
                                    title: "Alignment",
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(left: 24),
                                        child: Text("Horizontal Alignment"),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 16),
                                        child: _PageComponent.selectorAttribute(
                                          context,
                                          selectionA: "Left",
                                          selectionB: "Center",
                                          selectionC: "Right",
                                          selected: describeEnum(state.horizontalAlignment),
                                          onSelected: (selected) {
                                            //print(selected);
                                            SubtitleHorizontalAlignment.values.forEach(
                                              (alignment){
                                                if(selected.toLowerCase() == describeEnum(alignment).toLowerCase()) {
                                                  _bloc.add(MPB.PropertyAlignmentHorizontalEvent(alignment));
                                                }
                                              }
                                            );
                                            return;
                                          }
                                        )
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 24),
                                        child: Text("Vertical Alignment"),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 16),
                                        child: _PageComponent.selectorAttribute(
                                          context,
                                          selectionA: "Top",
                                          selectionB: "Center",
                                          selectionC: "Bottom",
                                          selected: describeEnum(state.verticalAlignment),
                                          onSelected: (selected) {
                                            SubtitleVerticleAlignment.values.forEach(
                                              (alignment){
                                                if(selected.toLowerCase() == describeEnum(alignment).toLowerCase()) {
                                                  _bloc.add(MPB.PropertyAlignmentVerticalEvent(alignment));
                                                }
                                              }
                                            );
                                            return;
                                          }
                                        )
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8,),
                                  _PageComponent.attributePanel(context,
                                    title: "Canvas",
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(left: 24),
                                        child: Text("Resolution"),
                                      ),
                                      SizedBox(height: 8,),
                                      Padding(
                                        padding: EdgeInsets.only(left: 16),
                                        child: _PageComponent.minimalAttribute(context, title: "X", controller: _canvasResolutionXTextCon),
                                      ),
                                      SizedBox(height: 4,),
                                      Padding(
                                        padding: EdgeInsets.only(left: 16),
                                        child: _PageComponent.minimalAttribute(context, title: "Y", controller: _canvasResolutionYTextCon),
                                      ),
                                      SizedBox(height: 16,),
                                      Padding(
                                        padding: EdgeInsets.only(left: 24),
                                        child: Text("Background"),
                                      ),
                                      SizedBox(height: 8,),
                                      Padding(
                                        padding: EdgeInsets.only(left: 16),
                                        child: _PageComponent.colorAttribute(context, title: "Color", onSelected: (color) => _bloc.add(MPB.PropertyCanvasColorEvent(color)), color: state.propertyCanvasBackgroundColor),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8,),
                                  _PageComponent.attributePanel(context,
                                    title: "Text",
                                    children: <Widget>[
                                      Container(
                                        constraints: BoxConstraints(
                                          minHeight: 120,
                                          maxHeight: 480,
                                        ),
                                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: ColorPalette.fontColor
                                        ),
                                        child: Scrollbar(
                                          child: TextFormField(
                                            controller: _subtilteTextController,
                                            keyboardType: TextInputType.multiline,
                                            decoration: InputDecoration.collapsed(hintText: null),
                                            style: TextStyle(color: ColorPalette.primaryColor),
                                            maxLines: null,
                                          )
                                        )
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            )
                          )
                        ]
                      ),
                    ),
                    Divider(height: 1, thickness: 1, color:  ColorPalette.secondaryColor),
                    Container(
                      height: 48,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      color: ColorPalette.primaryColor,
                      child: Row(
                        children: <Widget>[
                          Text("Version: 0.0.1",)
                        ],
                      ),
                    )
                  ],
                );
              },
            ),
          )
        ),
      )
    );
  }
}

class _PageComponent {
  static Widget attributePanel(
    BuildContext context,
    {
      @required List<Widget> children,
      String title = "Untitled",
    }
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        //color: ColorPalette.secondaryColor,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            ColorPalette.accentColor,
            ColorPalette.secondaryColor,
          ]
        ),
        border: Border.all(color: ColorPalette.accentColor)
      ),
      child: ConfigurableExpansionTile(
        header: Expanded(
          child: Container(
            height: 36,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text("$title", style: Theme.of(context).textTheme.subhead,),
            )
          )
        ),
        animatedWidgetFollowingHeader: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Icon(Icons.keyboard_arrow_up, color: ColorPalette.fontColor),
        ),
        children: <Widget>[
          Container(
            width: double.maxFinite,
            padding: EdgeInsets.only(bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children
            ),
          )
        ],
      )
    );
  }

  static Widget minimalAttribute(BuildContext context, {
    bool isMinusable = false,
    String title,
    String initialValue,
    TextEditingController controller,
    void Function(String) onFieldSubmitted,
    double titleWidth = 48,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16,),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            width: titleWidth,
            child: Text("$title", style: Theme.of(context).textTheme.subtitle,),
          ),
          SizedBox(width: 4,),
          Container(
            width: 36,
            height: 24,
            //color: Colors.black, //ColorPalette.accentColor,
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(8),
            ),
            child: AttributeFormField(
              controller: controller,
              initialValue: initialValue,
              isMinusable: isMinusable
            )
          )
        ],
      )
    );
  }

  static Widget buttonAttribute(BuildContext context, {
    String title,
    String btnName,
    void Function() onPressed,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16,),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            width: 48,
            child: Text("$title", style: Theme.of(context).textTheme.subtitle,),
          ),
          SizedBox(width: 4,),
          Container(
            //color: Colors.black, //ColorPalette.accentColor,
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onPressed,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Center(
                    child: Text("$btnName", style: Theme.of(context).textTheme.subtitle,),
                  ),
                )
              ),
            )
          )
        ],
      )
    );
  }

  static Widget colorAttribute(BuildContext context, {
    @required String title,
    Color color,
    void Function(Color color) onSelected,
    double titleWidth = 48,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16,),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            width: titleWidth,
            child: Text("$title", style: Theme.of(context).textTheme.subtitle,),
          ),
          SizedBox(width: 4,),
          Container(
            width: 36,
            height: 24,
            //color: Colors.black, //ColorPalette.accentColor,
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Material(
              color: color,
              child: InkWell(
                child: Container(
                  width: 36,
                  height: 24
                ),
                onTap: () async {
                  Color selectedColor = await showDialog(
                    context: context,
                    builder: (context) {
                      return ColorPickerDialog(initColor: color);
                    }
                  );
                  if(selectedColor == null) return;
                  onSelected(selectedColor);
                },
              ),
            )
          )
        ],
      )
    );
  }

  static Widget selectorAttribute(BuildContext context, {
    String selectionA,
    String selectionB,
    String selectionC,
    String selected,
    Null Function(String) onSelected(String selection) 
  }) {
    TextStyle focusSelectionStyle = Theme.of(context).textTheme.body2.copyWith(color: ColorPalette.fontColor);
    TextStyle selectionStyle = Theme.of(context).textTheme.body2.copyWith(color: ColorPalette.primaryColor);
    Color focusButtonColor = ColorPalette.primaryColor;
    Color buttonColor = ColorPalette.fontColor;
    return Row(
      children: <Widget>[
        Expanded(
          child: FlatButton(
            color: selected.toLowerCase() == selectionA.toLowerCase() ? focusButtonColor : buttonColor,
            padding: EdgeInsets.all(0),
            child: Text("$selectionA", style: selected == selectionA ? focusSelectionStyle : selectionStyle),
            onPressed: (){
              onSelected(selectionA);
            },
          ),
        ),
        Expanded(
          child: FlatButton(
            color: selected.toLowerCase() == selectionB.toLowerCase() ? focusButtonColor : buttonColor,
            padding: EdgeInsets.all(0),
            child: Text("$selectionB", style: selected == selectionB ? focusSelectionStyle :  selectionStyle),
            onPressed: (){
              onSelected(selectionB);
            },
          ),
        ),
        Expanded(
          child: FlatButton(
            color: selected.toLowerCase() == selectionC.toLowerCase() ? focusButtonColor : buttonColor,
            padding: EdgeInsets.all(0),
            child: Text("$selectionC", style: selected == selectionC ? focusSelectionStyle :  selectionStyle),
            onPressed: (){
              onSelected(selectionC);
            },
          )
        )
      ],
    );
  }
}