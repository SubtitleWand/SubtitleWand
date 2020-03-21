import 'dart:async';
import 'dart:math' as Math;
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:subtitle_wand/color_palette.dart';
import 'package:subtitle_wand/main_desktop.dart';
import 'package:subtitle_wand/model/font_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'model/subtitle_panel.dart';

abstract class MainPageEvent extends Equatable {
}

class SaveImageEvent extends MainPageEvent {
  final SubtitlePainter painter;
  SaveImageEvent({
    @required this.painter
  });
  @override
  List<Object> get props => [DateTime.now()];
}

class NextFrameEvent extends MainPageEvent {
  @override
  List<Object> get props => [DateTime.now()];
}

class PreviousFrameEvent extends MainPageEvent {
  @override
  List<Object> get props => [DateTime.now()];
}

class PropertyPaddingLeftEvent extends MainPageEvent {
  final int value;
  PropertyPaddingLeftEvent(this.value);
  @override
  List<Object> get props => [value];
}

class PropertyPaddingRightEvent extends MainPageEvent {
  final int value;
  PropertyPaddingRightEvent(this.value);
  @override
  List<Object> get props => [value];
}

class PropertyPaddingTopEvent extends MainPageEvent {
  final int value;
  PropertyPaddingTopEvent(this.value);
  @override
  List<Object> get props => [value];
}

class PropertyPaddingBottomEvent extends MainPageEvent {
  final int value;
  PropertyPaddingBottomEvent(this.value);
  @override
  List<Object> get props => [value];
}

class PropertyFontSizeEvent extends MainPageEvent {
  final int value;
  PropertyFontSizeEvent(this.value);
  @override
  List<Object> get props => [value];
}

class PropertyFontColorEvent extends MainPageEvent {
  final Color color;
  PropertyFontColorEvent(this.color);
  @override
  List<Object> get props => [color.value];
}

class PropertyFontTtfEvent extends MainPageEvent {
  final String fontPath;
  PropertyFontTtfEvent(this.fontPath);
  @override
  List<Object> get props => [fontPath];
}

class PropertyBorderSizeEvent extends MainPageEvent {
  final int value;
  PropertyBorderSizeEvent(this.value);
  @override
  List<Object> get props => [value];
}

class PropertyBorderColorEvent extends MainPageEvent {
  final Color color;
  PropertyBorderColorEvent(this.color);
  @override
  List<Object> get props => [color.value];
}

class PropertyShadowOffsetXEvent extends MainPageEvent {
  final int value;
  PropertyShadowOffsetXEvent(this.value);
  @override
  List<Object> get props => [value];
}


class PropertyShadowOffsetYEvent extends MainPageEvent {
  final int value;
  PropertyShadowOffsetYEvent(this.value);
  @override
  List<Object> get props => [value];
}


class PropertyShadowSpreadEvent extends MainPageEvent {
  final int value;
  PropertyShadowSpreadEvent(this.value);
  @override
  List<Object> get props => [value];
}


class PropertyShadowBlurEvent extends MainPageEvent {
  final int value;
  PropertyShadowBlurEvent(this.value);
  @override
  List<Object> get props => [value];
}

class PropertyShadowColorEvent extends MainPageEvent {
  final Color color;
  PropertyShadowColorEvent(this.color);
  @override
  List<Object> get props => [color.value];
}

class PropertyAlignmentHorizontalEvent extends MainPageEvent {
  final SubtitleHorizontalAlignment alignment;
  PropertyAlignmentHorizontalEvent(this.alignment);
  @override
  List<Object> get props => [alignment];
}

class PropertyAlignmentVerticalEvent extends MainPageEvent {
  final SubtitleVerticleAlignment alignment;
  PropertyAlignmentVerticalEvent(this.alignment);
  @override
  List<Object> get props => [alignment];
}

class PropertyCanvasResolutionXEvent extends MainPageEvent {
  final int value;
  PropertyCanvasResolutionXEvent(this.value);
  @override
  List<Object> get props => [value];
}

class PropertyCanvasResolutionYEvent extends MainPageEvent {
  final int value;
  PropertyCanvasResolutionYEvent(this.value);
  @override
  List<Object> get props => [value];
}

class PropertyCanvasColorEvent extends MainPageEvent {
  final Color color;
  PropertyCanvasColorEvent(this.color);
  @override
  List<Object> get props => [color.value];
}

class PropertySubtitleTextEvent extends MainPageEvent {
  final String text;
  PropertySubtitleTextEvent(this.text);
  @override
  List<Object> get props => [text];
}

class MainPageState extends Equatable {
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
  final SubtitleVerticleAlignment verticalAlignment;
  final SubtitleHorizontalAlignment horizontalAlignment;
  final int propertyCanvasResolutionX;
  final int propertyCanvasResolutionY;
  final Color propertyCanvasBackgroundColor;
  final List<String> propertySubtitleTexts;
  final int currentFrame;

  MainPageState._({
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

  factory MainPageState.empty() {
    return MainPageState._(
      propertyPaddingLeft: 0,
      propertyPaddingRight: 0,
      propertyPaddingTop: 0,
      propertyPaddingBottom: 0,
      propertyFontSize: 28,
      propertyFontColor: Colors.black,
      propertyFontFamily: null,
      propertyBorderWidth: 0,
      propertyBorderColor: Colors.white,
      propertyShadowX: 0,
      propertyShadowY: 0,
      propertyShadowSpread: 0,
      propertyShadowBlur: 0,
      propertyShadowColor: Colors.white,
      verticalAlignment: SubtitleVerticleAlignment.Bottom,
      horizontalAlignment: SubtitleHorizontalAlignment.Center,
      propertyCanvasResolutionX: 1920,
      propertyCanvasResolutionY: 1080,
      propertyCanvasBackgroundColor: ColorPalette.secondaryColor,
      propertySubtitleTexts: new List<String>(),
      currentFrame: 0,
    );
  }

  MainPageState copyWith({
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
    SubtitleVerticleAlignment verticalAlignment,
    SubtitleHorizontalAlignment horizontalAlignment,
    int propertyCanvasResolutionX,
    int propertyCanvasResolutionY,
    Color propertyCanvasBackgroundColor,
    List<String> propertySubtitleTexts,
    int currentFrame,
  }) {
    return new MainPageState._(
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
}

class MainPageBloc extends Bloc<MainPageEvent, MainPageState> {
  final FontManager _fontManager;
  MainPageBloc()
    : _fontManager = FontManager();

  @override
  MainPageState get initialState => MainPageState.empty();

  @override
  Stream<MainPageState> mapEventToState(MainPageEvent event) async* {
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

  Stream<MainPageState> _mapSaveImageEventToState(SaveImageEvent event) async* {
    print("SaveImageEventStart");
    Size resolution = Size(this.state.propertyCanvasResolutionX.toDouble(), this.state.propertyCanvasResolutionY.toDouble());
    for(int i = 0; i < this.state.propertySubtitleTexts.length; i++) {
      print("render: $i");
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
      await event.painter.saveImage(resolution, resolution, "results", "image_$i");
      // yield state.copyWith( // update current state
      // )
    }
    print("SaveImageEventEnd");
  }
  
  Stream<MainPageState> _mapNextFrameEventToState(NextFrameEvent event) async* {
    int maxLength = this.state.propertySubtitleTexts.length;
    yield state.copyWith(
      currentFrame: Math.min(this.state.currentFrame + 1, maxLength)
    );
  }
  Stream<MainPageState> _mapPreviousFrameEventToState(PreviousFrameEvent event) async* {
    yield state.copyWith(
      currentFrame: Math.max(this.state.currentFrame - 1, 0)
    );
  }
  Stream<MainPageState> _mapPropertyPaddingLeftEventToState(PropertyPaddingLeftEvent event) async* {
    yield state.copyWith(
      propertyPaddingLeft: event.value
    );
  }
  Stream<MainPageState> _mapPropertyPaddingRightEventToState(PropertyPaddingRightEvent event) async* {
    yield state.copyWith(
      propertyPaddingRight: event.value
    );
  }
  Stream<MainPageState> _mapPropertyPaddingTopEventToState(PropertyPaddingTopEvent event) async* {
    yield state.copyWith(
     propertyPaddingTop: event.value
    );
  }
  Stream<MainPageState> _mapPropertyPaddingBottomEventToState(PropertyPaddingBottomEvent event) async* {
    yield state.copyWith(
      propertyPaddingBottom: event.value
    );
  }
  Stream<MainPageState> _mapPropertyFontSizeEventToState(PropertyFontSizeEvent event) async* {
    yield state.copyWith(
      propertyFontSize: event.value
    );
  }
  Stream<MainPageState> _mapPropertyFontColorEventToState(PropertyFontColorEvent event) async* {
    yield state.copyWith(
      propertyFontColor: event.color
    );
  }
  Stream<MainPageState> _mapPropertyFontTtfEventToState(PropertyFontTtfEvent event) async* {
    try {
      if(_fontManager.contains(event.fontPath))
        return;
      await _fontManager.addFont(event.fontPath.toLowerCase(), event.fontPath);
      yield state.copyWith(
        propertyFontFamily: event.fontPath
      );
    } catch(err) {
      print(err);
    }
  }
  Stream<MainPageState> _mapPropertyBorderSizeEventToState(PropertyBorderSizeEvent event) async* {
    yield state.copyWith(
      propertyBorderWidth: event.value
    );
  }
  Stream<MainPageState> _mapPropertyBorderColorEventToState(PropertyBorderColorEvent event) async* {
    yield state.copyWith(
      propertyBorderColor: event.color
    );
  }
  Stream<MainPageState> _mapPropertyShadowOffsetXEventToState(PropertyShadowOffsetXEvent event) async* {
    yield state.copyWith(
      propertyShadowX: event.value
    );
  }
  Stream<MainPageState> _mapPropertyShadowOffsetYEventToState(PropertyShadowOffsetYEvent event) async* {
    yield state.copyWith(
      propertyShadowY: event.value
    );
  }
  Stream<MainPageState> _mapPropertyShadowSpreadEventToState(PropertyShadowSpreadEvent event) async* {
    yield state.copyWith(
      propertyShadowSpread: event.value
    );
  }
  Stream<MainPageState> _mapPropertyShadowBlurEventToState(PropertyShadowBlurEvent event) async* {
    yield state.copyWith(
      propertyShadowBlur: event.value
    );
  }
  Stream<MainPageState> _mapPropertyShadowColorEventToState(PropertyShadowColorEvent event) async* {
    yield state.copyWith(
      propertyShadowColor: event.color
    );
  }
  Stream<MainPageState> _mapPropertyAlignmentHorizontalEventToState(PropertyAlignmentHorizontalEvent event) async* {
    yield state.copyWith(
      horizontalAlignment: event.alignment
    );
  }
  Stream<MainPageState> _mapPropertyAlignmentVerticalEventToState(PropertyAlignmentVerticalEvent event) async* {
    yield state.copyWith(
      verticalAlignment: event.alignment
    );
  }
  Stream<MainPageState> _mapPropertyCanvasResolutionXEventToState(PropertyCanvasResolutionXEvent event) async* {
    yield state.copyWith(
      propertyCanvasResolutionX: event.value
    );
  }
  Stream<MainPageState> _mapPropertyCanvasResolutionYEventToState(PropertyCanvasResolutionYEvent event) async* {
    yield state.copyWith(
      propertyCanvasResolutionY: event.value
    );
  }
  Stream<MainPageState> _mapPropertyCanvasColorEventToState(PropertyCanvasColorEvent event) async* {
    yield state.copyWith(
      propertyCanvasBackgroundColor: event.color
    );
  }
  Stream<MainPageState> _mapPropertySubtitleTextEventToState(PropertySubtitleTextEvent event) async* {
    yield state.copyWith(
      propertySubtitleTexts: event.text.split("\n")
    );
  }

}