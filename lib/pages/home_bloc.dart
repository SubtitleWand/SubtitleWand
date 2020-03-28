import 'dart:async';
import 'dart:io';
import 'dart:math' as Math;
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:subtitle_wand/design/color_palette.dart';
import 'package:subtitle_wand/pages/_components/subtitle_panel.dart';
import 'package:subtitle_wand/utilities/font_manager.dart';


abstract class HomePageEvent extends Equatable {
}

class SaveImageEvent extends HomePageEvent {
  final SubtitlePainter painter;
  final String folder;
  SaveImageEvent({
    @required this.painter,
    this.folder // not yet supported to select folder
  });
  @override
  List<Object> get props => [DateTime.now(), this.folder];
}

class NextFrameEvent extends HomePageEvent {
  @override
  List<Object> get props => [DateTime.now()];
}

class PreviousFrameEvent extends HomePageEvent {
  @override
  List<Object> get props => [DateTime.now()];
}

class PropertyPaddingLeftEvent extends HomePageEvent {
  final int value;
  PropertyPaddingLeftEvent(this.value);
  @override
  List<Object> get props => [value];
}

class PropertyPaddingRightEvent extends HomePageEvent {
  final int value;
  PropertyPaddingRightEvent(this.value);
  @override
  List<Object> get props => [value];
}

class PropertyPaddingTopEvent extends HomePageEvent {
  final int value;
  PropertyPaddingTopEvent(this.value);
  @override
  List<Object> get props => [value];
}

class PropertyPaddingBottomEvent extends HomePageEvent {
  final int value;
  PropertyPaddingBottomEvent(this.value);
  @override
  List<Object> get props => [value];
}

class PropertyFontSizeEvent extends HomePageEvent {
  final int value;
  PropertyFontSizeEvent(this.value);
  @override
  List<Object> get props => [value];
}

class PropertyFontColorEvent extends HomePageEvent {
  final Color color;
  PropertyFontColorEvent(this.color);
  @override
  List<Object> get props => [color.value];
}

class PropertyFontTtfEvent extends HomePageEvent {
  final String fontPath;
  PropertyFontTtfEvent(this.fontPath);
  @override
  List<Object> get props => [fontPath];
}

class PropertyBorderSizeEvent extends HomePageEvent {
  final int value;
  PropertyBorderSizeEvent(this.value);
  @override
  List<Object> get props => [value];
}

class PropertyBorderColorEvent extends HomePageEvent {
  final Color color;
  PropertyBorderColorEvent(this.color);
  @override
  List<Object> get props => [color.value];
}

class PropertyShadowOffsetXEvent extends HomePageEvent {
  final int value;
  PropertyShadowOffsetXEvent(this.value);
  @override
  List<Object> get props => [value];
}


class PropertyShadowOffsetYEvent extends HomePageEvent {
  final int value;
  PropertyShadowOffsetYEvent(this.value);
  @override
  List<Object> get props => [value];
}


class PropertyShadowSpreadEvent extends HomePageEvent {
  final int value;
  PropertyShadowSpreadEvent(this.value);
  @override
  List<Object> get props => [value];
}


class PropertyShadowBlurEvent extends HomePageEvent {
  final int value;
  PropertyShadowBlurEvent(this.value);
  @override
  List<Object> get props => [value];
}

class PropertyShadowColorEvent extends HomePageEvent {
  final Color color;
  PropertyShadowColorEvent(this.color);
  @override
  List<Object> get props => [color.value];
}

class PropertyAlignmentHorizontalEvent extends HomePageEvent {
  final SubtitleHorizontalAlignment alignment;
  PropertyAlignmentHorizontalEvent(this.alignment);
  @override
  List<Object> get props => [alignment];
}

class PropertyAlignmentVerticalEvent extends HomePageEvent {
  final SubtitleVerticalAlignment alignment;
  PropertyAlignmentVerticalEvent(this.alignment);
  @override
  List<Object> get props => [alignment];
}

class PropertyCanvasResolutionXEvent extends HomePageEvent {
  final int value;
  PropertyCanvasResolutionXEvent(this.value);
  @override
  List<Object> get props => [value];
}

class PropertyCanvasResolutionYEvent extends HomePageEvent {
  final int value;
  PropertyCanvasResolutionYEvent(this.value);
  @override
  List<Object> get props => [value];
}

class PropertyCanvasColorEvent extends HomePageEvent {
  final Color color;
  PropertyCanvasColorEvent(this.color);
  @override
  List<Object> get props => [color.value];
}

class PropertySubtitleTextEvent extends HomePageEvent {
  final String text;
  PropertySubtitleTextEvent(this.text);
  @override
  List<Object> get props => [text];
}

abstract class HomePageState extends Equatable {
  final int propertyPaddingLeft;
  final int propertyPaddingRight;
  final int propertyPaddingTop;
  final int propertyPaddingBottom;
  final int propertyFontSize;
  final Color propertyFontColor;
  final String propertyFontFamily; // nullable to default font
  final int propertyBorderWidth;
  final Color propertyBorderColor;
  final int propertyShadowX;
  final int propertyShadowY;
  final int propertyShadowSpread;
  final int propertyShadowBlur;
  final Color propertyShadowColor;
  final SubtitleVerticalAlignment verticalAlignment;
  final SubtitleHorizontalAlignment horizontalAlignment;
  final int propertyCanvasResolutionX;
  final int propertyCanvasResolutionY;
  final Color propertyCanvasBackgroundColor;
  final List<String> propertySubtitleTexts;
  final int currentFrame;

  HomePageState({
    @required this.propertyPaddingLeft,
    @required this.propertyPaddingRight,
    @required this.propertyPaddingTop,
    @required this.propertyPaddingBottom,
    @required this.propertyFontSize,
    @required this.propertyFontColor,
    @required this.propertyFontFamily, // nullable to default font
    @required this.propertyBorderWidth,
    @required this.propertyBorderColor,
    @required this.propertyShadowX,
    @required this.propertyShadowY,
    @required this.propertyShadowSpread,
    @required this.propertyShadowBlur,
    @required this.propertyShadowColor,
    @required this.verticalAlignment,
    @required this.horizontalAlignment,
    @required this.propertyCanvasResolutionX,
    @required this.propertyCanvasResolutionY,
    @required this.propertyCanvasBackgroundColor,
    @required this.propertySubtitleTexts,
    @required this.currentFrame,
  });

  copyWith({
    int propertyPaddingLeft,
    int propertyPaddingRight,
    int propertyPaddingTop,
    int propertyPaddingBottom,
    int propertyFontSize,
    Color propertyFontColor,
    String propertyFontFamily, // nullable to default font
    int propertyBorderWidth,
    Color propertyBorderColor,
    int propertyShadowX,
    int propertyShadowY,
    int propertyShadowSpread,
    int propertyShadowBlur,
    Color propertyShadowColor,
    SubtitleVerticalAlignment verticalAlignment,
    SubtitleHorizontalAlignment horizontalAlignment,
    int propertyCanvasResolutionX,
    int propertyCanvasResolutionY,
    Color propertyCanvasBackgroundColor,
    List<String> propertySubtitleTexts,
    int currentFrame,
  });

  @override
  List<Object> get props => [
    propertyPaddingLeft,
    propertyPaddingRight,
    propertyPaddingTop,
    propertyPaddingBottom,
    propertyFontSize,
    propertyFontColor,
    propertyFontFamily, // nullable to default font
    propertyBorderWidth,
    propertyBorderColor,
    propertyShadowX,
    propertyShadowY,
    propertyShadowSpread,
    propertyShadowBlur,
    propertyShadowColor,
    verticalAlignment,
    horizontalAlignment,
    propertyCanvasResolutionX,
    propertyCanvasResolutionY,
    propertyCanvasBackgroundColor,
    propertySubtitleTexts,
    currentFrame,
  ];

  SavingState toSavingState() {
    return SavingState(
      propertyPaddingLeft: this.propertyPaddingLeft,
      propertyPaddingRight: this.propertyPaddingRight,
      propertyPaddingTop: this.propertyPaddingTop,
      propertyPaddingBottom: this.propertyPaddingBottom,
      propertyFontSize: this.propertyFontSize,
      propertyFontColor: this.propertyFontColor,
      propertyFontFamily: this.propertyFontFamily,
      propertyBorderWidth: this.propertyBorderWidth,
      propertyBorderColor: this.propertyBorderColor,
      propertyShadowX: this.propertyShadowX,
      propertyShadowY: this.propertyShadowY,
      propertyShadowSpread: this.propertyShadowSpread,
      propertyShadowBlur: this.propertyShadowBlur,
      propertyShadowColor: this.propertyShadowColor,
      verticalAlignment: this.verticalAlignment,
      horizontalAlignment: this.horizontalAlignment,
      propertyCanvasResolutionX: this.propertyCanvasResolutionX,
      propertyCanvasResolutionY: this.propertyCanvasResolutionY,
      propertyCanvasBackgroundColor: this.propertyCanvasBackgroundColor,
      propertySubtitleTexts: this.propertySubtitleTexts,
      currentFrame: this.currentFrame,
    );
  }

  IdleState toIdleState() {
    return IdleState(
      propertyPaddingLeft: this.propertyPaddingLeft,
      propertyPaddingRight: this.propertyPaddingRight,
      propertyPaddingTop: this.propertyPaddingTop,
      propertyPaddingBottom: this.propertyPaddingBottom,
      propertyFontSize: this.propertyFontSize,
      propertyFontColor: this.propertyFontColor,
      propertyFontFamily: this.propertyFontFamily,
      propertyBorderWidth: this.propertyBorderWidth,
      propertyBorderColor: this.propertyBorderColor,
      propertyShadowX: this.propertyShadowX,
      propertyShadowY: this.propertyShadowY,
      propertyShadowSpread: this.propertyShadowSpread,
      propertyShadowBlur: this.propertyShadowBlur,
      propertyShadowColor: this.propertyShadowColor,
      verticalAlignment: this.verticalAlignment,
      horizontalAlignment: this.horizontalAlignment,
      propertyCanvasResolutionX: this.propertyCanvasResolutionX,
      propertyCanvasResolutionY: this.propertyCanvasResolutionY,
      propertyCanvasBackgroundColor: this.propertyCanvasBackgroundColor,
      propertySubtitleTexts: this.propertySubtitleTexts,
      currentFrame: this.currentFrame,
    );
  }

  OpenFolderState toOpenFolderState(String folder) {
    return OpenFolderState(
      propertyPaddingLeft: this.propertyPaddingLeft,
      propertyPaddingRight: this.propertyPaddingRight,
      propertyPaddingTop: this.propertyPaddingTop,
      propertyPaddingBottom: this.propertyPaddingBottom,
      propertyFontSize: this.propertyFontSize,
      propertyFontColor: this.propertyFontColor,
      propertyFontFamily: this.propertyFontFamily,
      propertyBorderWidth: this.propertyBorderWidth,
      propertyBorderColor: this.propertyBorderColor,
      propertyShadowX: this.propertyShadowX,
      propertyShadowY: this.propertyShadowY,
      propertyShadowSpread: this.propertyShadowSpread,
      propertyShadowBlur: this.propertyShadowBlur,
      propertyShadowColor: this.propertyShadowColor,
      verticalAlignment: this.verticalAlignment,
      horizontalAlignment: this.horizontalAlignment,
      propertyCanvasResolutionX: this.propertyCanvasResolutionX,
      propertyCanvasResolutionY: this.propertyCanvasResolutionY,
      propertyCanvasBackgroundColor: this.propertyCanvasBackgroundColor,
      propertySubtitleTexts: this.propertySubtitleTexts,
      currentFrame: this.currentFrame,
      folder: folder
    );
  }
}


class IdleState extends HomePageState {
  IdleState({
    int propertyPaddingLeft,
    int propertyPaddingRight,
    int propertyPaddingTop,
    int propertyPaddingBottom,
    int propertyFontSize,
    Color propertyFontColor,
    String propertyFontFamily, // nullable to default font
    int propertyBorderWidth,
    Color propertyBorderColor,
    int propertyShadowX,
    int propertyShadowY,
    int propertyShadowSpread,
    int propertyShadowBlur,
    Color propertyShadowColor,
    SubtitleVerticalAlignment verticalAlignment,
    SubtitleHorizontalAlignment horizontalAlignment,
    int propertyCanvasResolutionX,
    int propertyCanvasResolutionY,
    Color propertyCanvasBackgroundColor,
    List<String> propertySubtitleTexts,
    int currentFrame,
  }) : super(
      propertyPaddingLeft: propertyPaddingLeft,
      propertyPaddingRight: propertyPaddingRight,
      propertyPaddingTop: propertyPaddingTop,
      propertyPaddingBottom: propertyPaddingBottom,
      propertyFontSize: propertyFontSize,
      propertyFontColor: propertyFontColor,
      propertyFontFamily:  propertyFontFamily,
      propertyBorderWidth: propertyBorderWidth,
      propertyBorderColor: propertyBorderColor,
      propertyShadowX: propertyShadowX,
      propertyShadowY: propertyShadowY,
      propertyShadowSpread: propertyShadowSpread,
      propertyShadowBlur: propertyShadowBlur,
      propertyShadowColor: propertyShadowColor,
      verticalAlignment: verticalAlignment,
      horizontalAlignment: horizontalAlignment,
      propertyCanvasResolutionX: propertyCanvasResolutionX,
      propertyCanvasResolutionY: propertyCanvasResolutionY,
      propertyCanvasBackgroundColor: propertyCanvasBackgroundColor,
      propertySubtitleTexts: propertySubtitleTexts,
      currentFrame: currentFrame,
  );

  copyWith({
    int propertyPaddingLeft,
    int propertyPaddingRight,
    int propertyPaddingTop,
    int propertyPaddingBottom,
    int propertyFontSize,
    Color propertyFontColor,
    String propertyFontFamily, // nullable to default font
    int propertyBorderWidth,
    Color propertyBorderColor,
    int propertyShadowX,
    int propertyShadowY,
    int propertyShadowSpread,
    int propertyShadowBlur,
    Color propertyShadowColor,
    SubtitleVerticalAlignment verticalAlignment,
    SubtitleHorizontalAlignment horizontalAlignment,
    int propertyCanvasResolutionX,
    int propertyCanvasResolutionY,
    Color propertyCanvasBackgroundColor,
    List<String> propertySubtitleTexts,
    int currentFrame,
  }) {
    return IdleState(
      propertyPaddingLeft: propertyPaddingLeft ?? this.propertyPaddingLeft,
      propertyPaddingRight: propertyPaddingRight ?? this.propertyPaddingRight,
      propertyPaddingTop: propertyPaddingTop ?? this.propertyPaddingTop,
      propertyPaddingBottom: propertyPaddingBottom ?? this.propertyPaddingBottom,
      propertyFontSize: propertyFontSize ?? this.propertyFontSize,
      propertyFontColor: propertyFontColor ?? this.propertyFontColor,
      propertyFontFamily:  propertyFontFamily ?? this.propertyFontFamily,
      propertyBorderWidth: propertyBorderWidth ?? this.propertyBorderWidth,
      propertyBorderColor: propertyBorderColor ?? this.propertyBorderColor,
      propertyShadowX: propertyShadowX ?? this.propertyShadowX,
      propertyShadowY: propertyShadowY ?? this.propertyShadowY,
      propertyShadowSpread: propertyShadowSpread ?? this.propertyShadowSpread,
      propertyShadowBlur: propertyShadowBlur ?? this.propertyShadowBlur,
      propertyShadowColor: propertyShadowColor ?? this.propertyShadowColor,
      verticalAlignment: verticalAlignment ?? this.verticalAlignment,
      horizontalAlignment: horizontalAlignment ?? this.horizontalAlignment,
      propertyCanvasResolutionX: propertyCanvasResolutionX ?? this.propertyCanvasResolutionX,
      propertyCanvasResolutionY: propertyCanvasResolutionY ?? this.propertyCanvasResolutionY,
      propertyCanvasBackgroundColor: propertyCanvasBackgroundColor ?? this.propertyCanvasBackgroundColor,
      propertySubtitleTexts: propertySubtitleTexts ?? this.propertySubtitleTexts,
      currentFrame: currentFrame ?? this.currentFrame,
    );
  }
}

class SavingState extends HomePageState {
  SavingState({
    int propertyPaddingLeft,
    int propertyPaddingRight,
    int propertyPaddingTop,
    int propertyPaddingBottom,
    int propertyFontSize,
    Color propertyFontColor,
    String propertyFontFamily, // nullable to default font
    int propertyBorderWidth,
    Color propertyBorderColor,
    int propertyShadowX,
    int propertyShadowY,
    int propertyShadowSpread,
    int propertyShadowBlur,
    Color propertyShadowColor,
    SubtitleVerticalAlignment verticalAlignment,
    SubtitleHorizontalAlignment horizontalAlignment,
    int propertyCanvasResolutionX,
    int propertyCanvasResolutionY,
    Color propertyCanvasBackgroundColor,
    List<String> propertySubtitleTexts,
    int currentFrame,
  }) : super(
      propertyPaddingLeft: propertyPaddingLeft,
      propertyPaddingRight: propertyPaddingRight,
      propertyPaddingTop: propertyPaddingTop,
      propertyPaddingBottom: propertyPaddingBottom,
      propertyFontSize: propertyFontSize,
      propertyFontColor: propertyFontColor,
      propertyFontFamily:  propertyFontFamily,
      propertyBorderWidth: propertyBorderWidth,
      propertyBorderColor: propertyBorderColor,
      propertyShadowX: propertyShadowX,
      propertyShadowY: propertyShadowY,
      propertyShadowSpread: propertyShadowSpread,
      propertyShadowBlur: propertyShadowBlur,
      propertyShadowColor: propertyShadowColor,
      verticalAlignment: verticalAlignment,
      horizontalAlignment: horizontalAlignment,
      propertyCanvasResolutionX: propertyCanvasResolutionX,
      propertyCanvasResolutionY: propertyCanvasResolutionY,
      propertyCanvasBackgroundColor: propertyCanvasBackgroundColor,
      propertySubtitleTexts: propertySubtitleTexts,
      currentFrame: currentFrame,
  );

  copyWith({
    int propertyPaddingLeft,
    int propertyPaddingRight,
    int propertyPaddingTop,
    int propertyPaddingBottom,
    int propertyFontSize,
    Color propertyFontColor,
    String propertyFontFamily, // nullable to default font
    int propertyBorderWidth,
    Color propertyBorderColor,
    int propertyShadowX,
    int propertyShadowY,
    int propertyShadowSpread,
    int propertyShadowBlur,
    Color propertyShadowColor,
    SubtitleVerticalAlignment verticalAlignment,
    SubtitleHorizontalAlignment horizontalAlignment,
    int propertyCanvasResolutionX,
    int propertyCanvasResolutionY,
    Color propertyCanvasBackgroundColor,
    List<String> propertySubtitleTexts,
    int currentFrame,
  }) {
    return SavingState(
      propertyPaddingLeft: propertyPaddingLeft ?? this.propertyPaddingLeft,
      propertyPaddingRight: propertyPaddingRight ?? this.propertyPaddingRight,
      propertyPaddingTop: propertyPaddingTop ?? this.propertyPaddingTop,
      propertyPaddingBottom: propertyPaddingBottom ?? this.propertyPaddingBottom,
      propertyFontSize: propertyFontSize ?? this.propertyFontSize,
      propertyFontColor: propertyFontColor ?? this.propertyFontColor,
      propertyFontFamily:  propertyFontFamily ?? this.propertyFontFamily,
      propertyBorderWidth: propertyBorderWidth ?? this.propertyBorderWidth,
      propertyBorderColor: propertyBorderColor ?? this.propertyBorderColor,
      propertyShadowX: propertyShadowX ?? this.propertyShadowX,
      propertyShadowY: propertyShadowY ?? this.propertyShadowY,
      propertyShadowSpread: propertyShadowSpread ?? this.propertyShadowSpread,
      propertyShadowBlur: propertyShadowBlur ?? this.propertyShadowBlur,
      propertyShadowColor: propertyShadowColor ?? this.propertyShadowColor,
      verticalAlignment: verticalAlignment ?? this.verticalAlignment,
      horizontalAlignment: horizontalAlignment ?? this.horizontalAlignment,
      propertyCanvasResolutionX: propertyCanvasResolutionX ?? this.propertyCanvasResolutionX,
      propertyCanvasResolutionY: propertyCanvasResolutionY ?? this.propertyCanvasResolutionY,
      propertyCanvasBackgroundColor: propertyCanvasBackgroundColor ?? this.propertyCanvasBackgroundColor,
      propertySubtitleTexts: propertySubtitleTexts ?? this.propertySubtitleTexts,
      currentFrame: currentFrame ?? this.currentFrame,
    );
  }
}

class OpenFolderState extends HomePageState {
  final String folder;
  OpenFolderState({
    int propertyPaddingLeft,
    int propertyPaddingRight,
    int propertyPaddingTop,
    int propertyPaddingBottom,
    int propertyFontSize,
    Color propertyFontColor,
    String propertyFontFamily, // nullable to default font
    int propertyBorderWidth,
    Color propertyBorderColor,
    int propertyShadowX,
    int propertyShadowY,
    int propertyShadowSpread,
    int propertyShadowBlur,
    Color propertyShadowColor,
    SubtitleVerticalAlignment verticalAlignment,
    SubtitleHorizontalAlignment horizontalAlignment,
    int propertyCanvasResolutionX,
    int propertyCanvasResolutionY,
    Color propertyCanvasBackgroundColor,
    List<String> propertySubtitleTexts,
    int currentFrame,
    this.folder,
  }) : super(
      propertyPaddingLeft: propertyPaddingLeft,
      propertyPaddingRight: propertyPaddingRight,
      propertyPaddingTop: propertyPaddingTop,
      propertyPaddingBottom: propertyPaddingBottom,
      propertyFontSize: propertyFontSize,
      propertyFontColor: propertyFontColor,
      propertyFontFamily:  propertyFontFamily,
      propertyBorderWidth: propertyBorderWidth,
      propertyBorderColor: propertyBorderColor,
      propertyShadowX: propertyShadowX,
      propertyShadowY: propertyShadowY,
      propertyShadowSpread: propertyShadowSpread,
      propertyShadowBlur: propertyShadowBlur,
      propertyShadowColor: propertyShadowColor,
      verticalAlignment: verticalAlignment,
      horizontalAlignment: horizontalAlignment,
      propertyCanvasResolutionX: propertyCanvasResolutionX,
      propertyCanvasResolutionY: propertyCanvasResolutionY,
      propertyCanvasBackgroundColor: propertyCanvasBackgroundColor,
      propertySubtitleTexts: propertySubtitleTexts,
      currentFrame: currentFrame,
  );

  copyWith({
    int propertyPaddingLeft,
    int propertyPaddingRight,
    int propertyPaddingTop,
    int propertyPaddingBottom,
    int propertyFontSize,
    Color propertyFontColor,
    String propertyFontFamily, // nullable to default font
    int propertyBorderWidth,
    Color propertyBorderColor,
    int propertyShadowX,
    int propertyShadowY,
    int propertyShadowSpread,
    int propertyShadowBlur,
    Color propertyShadowColor,
    SubtitleVerticalAlignment verticalAlignment,
    SubtitleHorizontalAlignment horizontalAlignment,
    int propertyCanvasResolutionX,
    int propertyCanvasResolutionY,
    Color propertyCanvasBackgroundColor,
    List<String> propertySubtitleTexts,
    int currentFrame,
    String folder,
  }) {
    return OpenFolderState(
      propertyPaddingLeft: propertyPaddingLeft ?? this.propertyPaddingLeft,
      propertyPaddingRight: propertyPaddingRight ?? this.propertyPaddingRight,
      propertyPaddingTop: propertyPaddingTop ?? this.propertyPaddingTop,
      propertyPaddingBottom: propertyPaddingBottom ?? this.propertyPaddingBottom,
      propertyFontSize: propertyFontSize ?? this.propertyFontSize,
      propertyFontColor: propertyFontColor ?? this.propertyFontColor,
      propertyFontFamily:  propertyFontFamily ?? this.propertyFontFamily,
      propertyBorderWidth: propertyBorderWidth ?? this.propertyBorderWidth,
      propertyBorderColor: propertyBorderColor ?? this.propertyBorderColor,
      propertyShadowX: propertyShadowX ?? this.propertyShadowX,
      propertyShadowY: propertyShadowY ?? this.propertyShadowY,
      propertyShadowSpread: propertyShadowSpread ?? this.propertyShadowSpread,
      propertyShadowBlur: propertyShadowBlur ?? this.propertyShadowBlur,
      propertyShadowColor: propertyShadowColor ?? this.propertyShadowColor,
      verticalAlignment: verticalAlignment ?? this.verticalAlignment,
      horizontalAlignment: horizontalAlignment ?? this.horizontalAlignment,
      propertyCanvasResolutionX: propertyCanvasResolutionX ?? this.propertyCanvasResolutionX,
      propertyCanvasResolutionY: propertyCanvasResolutionY ?? this.propertyCanvasResolutionY,
      propertyCanvasBackgroundColor: propertyCanvasBackgroundColor ?? this.propertyCanvasBackgroundColor,
      propertySubtitleTexts: propertySubtitleTexts ?? this.propertySubtitleTexts,
      currentFrame: currentFrame ?? this.currentFrame,
      folder: folder ?? this.folder
    );
  }
}

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  final FontManager _fontManager;
  HomePageBloc()
    : _fontManager = FontManager();

  @override
  HomePageState get initialState => IdleState(
    propertyPaddingLeft: 0,
    propertyPaddingRight: 0,
    propertyPaddingTop: 0,
    propertyPaddingBottom: 0,
    propertyFontSize: 28,
    propertyFontColor: Colors.white,
    propertyFontFamily: null,
    propertyBorderWidth: 0,
    propertyBorderColor: ColorPalette.accentColor,
    propertyShadowX: 0,
    propertyShadowY: 0,
    propertyShadowSpread: 0,
    propertyShadowBlur: 0,
    propertyShadowColor: Colors.black,
    verticalAlignment: SubtitleVerticalAlignment.Center,
    horizontalAlignment: SubtitleHorizontalAlignment.Center,
    propertyCanvasResolutionX: 1920,
    propertyCanvasResolutionY: 1080,
    // propertyCanvasBackgroundColor: ColorPalette.secondaryColor,
    propertyCanvasBackgroundColor: Color(0xff253643),
    propertySubtitleTexts: List<String>(),
    currentFrame: 0,
  );

  @override
  Stream<HomePageState> mapEventToState(HomePageEvent event) async* {
    if(event is SaveImageEvent) {
      yield* _mapSaveImageEventToState(event);
    } else if(event is NextFrameEvent) {
      yield* _mapNextFrameEventToState(event);
    } else if(event is PreviousFrameEvent) {
      yield* _mapPreviousFrameEventToState(event);
    } else if(event is PropertyPaddingLeftEvent) {
      yield* _mapPropertyPaddingLeftEventToState(event);
    } else if(event is PropertyPaddingRightEvent) {
      yield* _mapPropertyPaddingRightEventToState(event);
    } else if(event is PropertyPaddingTopEvent) {
      yield* _mapPropertyPaddingTopEventToState(event);
    } else if(event is PropertyPaddingBottomEvent) {
      yield* _mapPropertyPaddingBottomEventToState(event);
    } else if(event is PropertyFontSizeEvent) {
      yield* _mapPropertyFontSizeEventToState(event);
    } else if(event is PropertyFontColorEvent) {
      yield* _mapPropertyFontColorEventToState(event);
    } else if(event is PropertyFontTtfEvent) {
      yield* _mapPropertyFontTtfEventToState(event);
    } else if(event is PropertyBorderSizeEvent) {
      yield* _mapPropertyBorderSizeEventToState(event);
    } else if(event is PropertyBorderColorEvent) {
      yield* _mapPropertyBorderColorEventToState(event);
    } else if(event is PropertyShadowOffsetXEvent) {
      yield* _mapPropertyShadowOffsetXEventToState(event);
    } else if(event is PropertyShadowOffsetYEvent) {
      yield* _mapPropertyShadowOffsetYEventToState(event);
    } else if(event is PropertyShadowSpreadEvent) {
      yield* _mapPropertyShadowSpreadEventToState(event);
    } else if(event is PropertyShadowBlurEvent) {
      yield* _mapPropertyShadowBlurEventToState(event);
    } else if(event is PropertyShadowColorEvent) {
      yield* _mapPropertyShadowColorEventToState(event);
    } else if(event is PropertyAlignmentHorizontalEvent) {
      yield* _mapPropertyAlignmentHorizontalEventToState(event);
    } else if(event is PropertyAlignmentVerticalEvent) {
      yield* _mapPropertyAlignmentVerticalEventToState(event);
    } else if(event is PropertyCanvasResolutionXEvent) {
      yield* _mapPropertyCanvasResolutionXEventToState(event);
    } else if(event is PropertyCanvasResolutionYEvent) {
      yield* _mapPropertyCanvasResolutionYEventToState(event);
    } else if(event is PropertyCanvasColorEvent) {
      yield* _mapPropertyCanvasColorEventToState(event);
    } else if(event is PropertySubtitleTextEvent) {
      yield* _mapPropertySubtitleTextEventToState(event);
    }
  }

  Stream<HomePageState> _mapSaveImageEventToState(SaveImageEvent event) async* {
    // print("SaveImageEventStart");
    // print(Platform.isMacOS ? "I'm a fking mac" : "I'm not a mac");
    Size resolution = Size(this.state.propertyCanvasResolutionX.toDouble(), this.state.propertyCanvasResolutionY.toDouble());
    for(int i = 0; i < this.state.propertySubtitleTexts.length; i++) {
      // print("render: $i");
      yield state.toSavingState().copyWith(
        currentFrame: i
      );
      event.painter.update(
        span: TextSpan(
          text: "${state.propertySubtitleTexts[i]}",
          style: TextStyle(
            fontFamily: state.propertyFontFamily,
            color: state.propertyFontColor,
            fontSize: state.propertyFontSize.toDouble(),
          ),
        ),
      );
      // print("pre save image");
      await event.painter.saveImage(resolution, resolution, event.folder ?? "results", "image_$i");
    }

    if(Platform.isMacOS) {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String path = p.join(appDocDir.path, "results");
      yield state.toOpenFolderState(path);
    } else {
      yield state.toOpenFolderState(event.folder ?? "results");
    }
    // print("SaveImageEventEnd");
    yield state.toIdleState();
  }
  
  Stream<HomePageState> _mapNextFrameEventToState(NextFrameEvent event) async* {
    int maxLength = this.state.propertySubtitleTexts.length;
    yield state.toIdleState().copyWith(
      currentFrame: Math.max(0, Math.min(this.state.currentFrame + 1, maxLength - 1))
    );
  }
  Stream<HomePageState> _mapPreviousFrameEventToState(PreviousFrameEvent event) async* {
    yield state.toIdleState().copyWith(
      currentFrame: Math.max(this.state.currentFrame - 1, 0)
    );
  }
  Stream<HomePageState> _mapPropertyPaddingLeftEventToState(PropertyPaddingLeftEvent event) async* {
    yield state.toIdleState().copyWith(
      propertyPaddingLeft: event.value
    );
  }
  Stream<HomePageState> _mapPropertyPaddingRightEventToState(PropertyPaddingRightEvent event) async* {
    yield state.toIdleState().copyWith(
      propertyPaddingRight: event.value
    );
  }
  Stream<HomePageState> _mapPropertyPaddingTopEventToState(PropertyPaddingTopEvent event) async* {
    yield state.toIdleState().copyWith(
     propertyPaddingTop: event.value
    );
  }
  Stream<HomePageState> _mapPropertyPaddingBottomEventToState(PropertyPaddingBottomEvent event) async* {
    yield state.toIdleState().copyWith(
      propertyPaddingBottom: event.value
    );
  }
  Stream<HomePageState> _mapPropertyFontSizeEventToState(PropertyFontSizeEvent event) async* {
    yield state.toIdleState().copyWith(
      propertyFontSize: event.value
    );
  }
  Stream<HomePageState> _mapPropertyFontColorEventToState(PropertyFontColorEvent event) async* {
    yield state.toIdleState().copyWith(
      propertyFontColor: event.color
    );
  }
  Stream<HomePageState> _mapPropertyFontTtfEventToState(PropertyFontTtfEvent event) async* {
    try {
      if(_fontManager.contains(event.fontPath)) return;
      await _fontManager.addFont(event.fontPath.toLowerCase(), event.fontPath);
      yield state.toIdleState().copyWith(
        propertyFontFamily: event.fontPath
      );
    } catch(err) {
      print(err);
    }
  }
  Stream<HomePageState> _mapPropertyBorderSizeEventToState(PropertyBorderSizeEvent event) async* {
    yield state.toIdleState().copyWith(
      propertyBorderWidth: event.value
    );
  }
  Stream<HomePageState> _mapPropertyBorderColorEventToState(PropertyBorderColorEvent event) async* {
    yield state.toIdleState().copyWith(
      propertyBorderColor: event.color
    );
  }
  Stream<HomePageState> _mapPropertyShadowOffsetXEventToState(PropertyShadowOffsetXEvent event) async* {
    yield state.toIdleState().copyWith(
      propertyShadowX: event.value
    );
  }
  Stream<HomePageState> _mapPropertyShadowOffsetYEventToState(PropertyShadowOffsetYEvent event) async* {
    yield state.toIdleState().copyWith(
      propertyShadowY: event.value
    );
  }
  Stream<HomePageState> _mapPropertyShadowSpreadEventToState(PropertyShadowSpreadEvent event) async* {
    yield state.toIdleState().copyWith(
      propertyShadowSpread: event.value
    );
  }
  Stream<HomePageState> _mapPropertyShadowBlurEventToState(PropertyShadowBlurEvent event) async* {
    yield state.toIdleState().copyWith(
      propertyShadowBlur: event.value
    );
  }
  Stream<HomePageState> _mapPropertyShadowColorEventToState(PropertyShadowColorEvent event) async* {
    yield state.toIdleState().copyWith(
      propertyShadowColor: event.color
    );
  }
  Stream<HomePageState> _mapPropertyAlignmentHorizontalEventToState(PropertyAlignmentHorizontalEvent event) async* {
    yield state.toIdleState().copyWith(
      horizontalAlignment: event.alignment
    );
  }
  Stream<HomePageState> _mapPropertyAlignmentVerticalEventToState(PropertyAlignmentVerticalEvent event) async* {
    yield state.toIdleState().copyWith(
      verticalAlignment: event.alignment
    );
  }
  Stream<HomePageState> _mapPropertyCanvasResolutionXEventToState(PropertyCanvasResolutionXEvent event) async* {
    yield state.toIdleState().copyWith(
      propertyCanvasResolutionX: event.value
    );
  }
  Stream<HomePageState> _mapPropertyCanvasResolutionYEventToState(PropertyCanvasResolutionYEvent event) async* {
    yield state.toIdleState().copyWith(
      propertyCanvasResolutionY: event.value
    );
  }
  Stream<HomePageState> _mapPropertyCanvasColorEventToState(PropertyCanvasColorEvent event) async* {
    yield state.toIdleState().copyWith(
      propertyCanvasBackgroundColor: event.color
    );
  }
  Stream<HomePageState> _mapPropertySubtitleTextEventToState(PropertySubtitleTextEvent event) async* {
    if(event.text.isEmpty)  {
      yield state.toIdleState().copyWith(
        propertySubtitleTexts: []
      );
      return;
    }
    yield state.toIdleState().copyWith(
      propertySubtitleTexts: event.text.split("\n")
    );
  }

}