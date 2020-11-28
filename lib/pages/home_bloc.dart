import 'dart:async';
import 'dart:io';
import 'dart:math' as Math;
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pedantic/pedantic.dart';

import 'package:subtitle_wand/design/color_palette.dart';
import 'package:subtitle_wand/pages/_components/subtitle_panel.dart';
import 'package:subtitle_wand/utilities/font_manager.dart';
import 'package:subtitle_wand/utilities/logger_util.dart';

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
  List<Object> get props => [DateTime.now(), folder];
}

class SaveVideoEvent extends HomePageEvent {
  final SubtitlePainter painter;
  final String folder;
  SaveVideoEvent({
    @required this.painter,
    this.folder // not yet supported to select folder
  });
  @override
  List<Object> get props => [DateTime.now(), folder];
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

class PropertySrtEvent extends HomePageEvent {
  final String srtPath;
  PropertySrtEvent(this.srtPath);
  @override
  List<Object> get props => [srtPath];
}


enum PropertyTextType {
  plain,
  srt,
}

class PropertyText extends Equatable {
  final PropertyTextType type;
  final List<TimeText> texts;
  
  PropertyText({
    this.type,
    this.texts,
  });

  @override
  List<Object> get props => [type, texts];

  PropertyText copyWith({
    PropertyTextType type,
    List<TimeText> texts,
  }) {
    return PropertyText(
      type: type ?? this.type,
      texts: texts ?? this.texts,
    );
  }
}

class TimeText extends Equatable{
  final String text;
  final DateTime startTimestamp;
  final DateTime endTimeStamp;

  TimeText({
    this.text,
    this.startTimestamp,
    this.endTimeStamp,
  });

  @override
  List<Object> get props => [text, startTimestamp, endTimeStamp];
}

class NoException implements Exception {}

class NotDetectFFmpegException implements Exception {}

class SrtFormatErrorException implements Exception {}

class HomePageState extends Equatable {
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
  final PropertyText propertyText;
  final int currentFrame;

  final FormzStatus status;
  final String openDir;
  final Exception exception;

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
    @required this.propertyText,
    @required this.currentFrame,
    @required this.status,
    @required this.openDir,
    @required this.exception
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
    propertyText,
    currentFrame,
    status,
    openDir,
    exception
  ];

  

  HomePageState copyWith({
    int propertyPaddingLeft,
    int propertyPaddingRight,
    int propertyPaddingTop,
    int propertyPaddingBottom,
    int propertyFontSize,
    Color propertyFontColor,
    String propertyFontFamily,
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
    PropertyText propertyText,
    int currentFrame,
    FormzStatus status,
    String openDir,
    Exception exception,
  }) {
    return HomePageState(
      propertyPaddingLeft: propertyPaddingLeft ?? this.propertyPaddingLeft,
      propertyPaddingRight: propertyPaddingRight ?? this.propertyPaddingRight,
      propertyPaddingTop: propertyPaddingTop ?? this.propertyPaddingTop,
      propertyPaddingBottom: propertyPaddingBottom ?? this.propertyPaddingBottom,
      propertyFontSize: propertyFontSize ?? this.propertyFontSize,
      propertyFontColor: propertyFontColor ?? this.propertyFontColor,
      propertyFontFamily: propertyFontFamily ?? this.propertyFontFamily,
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
      propertyText: propertyText ?? this.propertyText,
      currentFrame: currentFrame ?? this.currentFrame,
      status: status ?? this.status,
      openDir: openDir ?? this.openDir,
      exception: exception ?? this.exception
    );
  }
}

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  final FontManager _fontManager;
  HomePageBloc()
    : 
      _fontManager = FontManager(),
      super(
        HomePageState(
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
          propertyText: PropertyText(texts: [], type: PropertyTextType.plain),
          currentFrame: 0,
          status: FormzStatus.pure,
          openDir: '',
          exception: NoException()
        )
      );

  @override
  Stream<HomePageState> mapEventToState(HomePageEvent event) async* {
    if(event is SaveImageEvent) {
      yield* _mapSaveImageEventToState(event);
    } else if(event is SaveVideoEvent) {
      yield* _mapSaveVideoEventToState(event);
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
    } else if(event is PropertySrtEvent) {
      yield* _mapPropertySrtEventToState(event);
    }
  }

  Stream<HomePageState> _mapSaveImageEventToState(SaveImageEvent event, {bool isOpenDir = true, bool isRenderTransparent = false}) async* {
    final currentState = state;
    Size resolution = Size(currentState.propertyCanvasResolutionX.toDouble(), currentState.propertyCanvasResolutionY.toDouble());

    if(isRenderTransparent) {
      event.painter.update(
        span: TextSpan(
          text: '',
          style: TextStyle(
            fontFamily: state.propertyFontFamily,
            color: state.propertyFontColor,
            fontSize: state.propertyFontSize.toDouble(),
          ),
        ),
      );
      await event.painter.saveImage(resolution, resolution, event.folder ?? 'results', 'transparent');
    }

    for(int i = 0; i < currentState.propertyText.texts.length; i++) {
      yield currentState.copyWith(
        currentFrame: i,
        status: FormzStatus.submissionInProgress
      );
      event.painter.update(
        span: TextSpan(
          text: '${state.propertyText.texts[i].text}',
          style: TextStyle(
            fontFamily: state.propertyFontFamily,
            color: state.propertyFontColor,
            fontSize: state.propertyFontSize.toDouble(),
          ),
        ),
      );
      await event.painter.saveImage(resolution, resolution, event.folder ?? 'results', 'image_$i');
    }

    if(isOpenDir) {
      if(Platform.isMacOS) {
        Directory appDocDir = await getApplicationDocumentsDirectory();
        String path = p.join(appDocDir.path, 'results');
        yield state.copyWith(
          status: FormzStatus.submissionSuccess,
          openDir: path
        );
      } else {
        yield state.copyWith(
          status: FormzStatus.submissionSuccess,
          openDir: event.folder ?? 'results'
        );
      }
      yield state.copyWith(openDir: '', status: FormzStatus.pure);
    }
  }

  Stream<HomePageState> _mapSaveVideoEventToState(SaveVideoEvent event) async* {
    final currentState = state;
    yield* _mapSaveImageEventToState(SaveImageEvent(painter: event.painter, folder: event.folder), isOpenDir: false, isRenderTransparent: true);

    if(currentState.propertyText.texts[0].startTimestamp == null || currentState.propertyText.texts[0].endTimeStamp == null) return;

    // generate video.ffconcat
    String path = '';
    if(Platform.isMacOS) {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      path = p.join(appDocDir.path, event.folder ?? 'results');
    } else {
      path = p.join(event.folder ?? 'results');
    }
    File ffmpegFile = File(p.join(path, 'video.ffconcat'));

    await ffmpegFile.create();

    String result = 'ffconcat version 1.0\n';
    double different = 0.5;
    for(int i = 0; i < currentState.propertyText.texts.length; i++) {
      if(i == 0) {
        result += 'file transparent.png\n';
        result += 'duration ${(currentState.propertyText.texts[i].startTimestamp.millisecond)/1000}\n';
      }
      result += 'file image_${i}.png\n';
      if(i + 1 < currentState.propertyText.texts.length) {
        if((currentState.propertyText.texts[i + 1].startTimestamp.difference(currentState.propertyText.texts[i].endTimeStamp).inMilliseconds / 1000.0) < different) {
          result += 'duration ${(currentState.propertyText.texts[i + 1].startTimestamp.difference(currentState.propertyText.texts[i].startTimestamp)).inMilliseconds / 1000.0}\n';
        } else {
          result += 'duration ${(currentState.propertyText.texts[i].endTimeStamp.difference(currentState.propertyText.texts[i].startTimestamp).inMilliseconds /1000.0)}\n';
          result += 'file transparent.png\n';
          result += 'duration ${(currentState.propertyText.texts[i + 1].startTimestamp.difference(currentState.propertyText.texts[i].endTimeStamp)).inMilliseconds / 1000.0}\n';
        }
      } else {
        result += 'duration ${(currentState.propertyText.texts[i].endTimeStamp.difference(currentState.propertyText.texts[i].startTimestamp).inMilliseconds /1000.0)}\n';
      }

      if(i == currentState.propertyText.texts.length - 1) {
        result += 'duration ${(currentState.propertyText.texts[i].endTimeStamp.difference(currentState.propertyText.texts[i].startTimestamp).inMilliseconds /1000.0)}\n';
        result += 'file transparent.png\n';
        result += 'duration 4\n';
      }
    }

    await ffmpegFile.writeAsString(result);

    //ffmpeg -i video.ffconcat -crf 25 -vf fps=60 out.mp4
    ProcessResult ffmpegResult = await Process.run(
      'ffmpeg', 
      ['-y', '-i','video.ffconcat', '-crf', '25', '-vf', 'fps=60', 'out.mp4'], 
      runInShell: true,
      workingDirectory: path
    );

    if(ffmpegResult.stderr) unawaited(LoggerUtil.getInstance().logError(ffmpegResult.stderr, isWriteToJournal: true));
    if(ffmpegResult.stdout) unawaited(LoggerUtil.getInstance().log(ffmpegResult.stdout));

    if(Platform.isMacOS) {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String path = p.join(appDocDir.path, 'results');
      yield currentState.copyWith(
        status: FormzStatus.submissionSuccess,
        openDir: path
      );
    } else {
      yield currentState.copyWith(
        status: FormzStatus.submissionSuccess,
        openDir: event.folder ?? 'results'
      );
    }
    yield currentState.copyWith(openDir: '', status: FormzStatus.pure);
  }
  
  Stream<HomePageState> _mapNextFrameEventToState(NextFrameEvent event) async* {
    final currentState = state;
    int maxLength = currentState.propertyText.texts.length;
    yield state.copyWith(
      status: FormzStatus.pure,
      currentFrame: Math.max(0, Math.min(currentState.currentFrame + 1, maxLength - 1))
    );
  }
  Stream<HomePageState> _mapPreviousFrameEventToState(PreviousFrameEvent event) async* {
    final currentState = state;
    yield currentState.copyWith(
      status: FormzStatus.pure,
      currentFrame: Math.max(currentState.currentFrame - 1, 0)
    );
  }
  Stream<HomePageState> _mapPropertyPaddingLeftEventToState(PropertyPaddingLeftEvent event) async* {
    final currentState = state;
    yield currentState.copyWith(
      status: FormzStatus.pure,
      propertyPaddingLeft: event.value
    );
  }
  Stream<HomePageState> _mapPropertyPaddingRightEventToState(PropertyPaddingRightEvent event) async* {
    final currentState = state;
    yield currentState.copyWith(
      propertyPaddingRight: event.value
    );
  }
  Stream<HomePageState> _mapPropertyPaddingTopEventToState(PropertyPaddingTopEvent event) async* {
    final currentState = state;
    yield currentState.copyWith(
      status: FormzStatus.pure,
     propertyPaddingTop: event.value
    );
  }
  Stream<HomePageState> _mapPropertyPaddingBottomEventToState(PropertyPaddingBottomEvent event) async* {
    final currentState = state;
    yield currentState.copyWith(
      status: FormzStatus.pure,
      propertyPaddingBottom: event.value
    );
  }
  Stream<HomePageState> _mapPropertyFontSizeEventToState(PropertyFontSizeEvent event) async* {
    final currentState = state;
    yield currentState.copyWith(
      status: FormzStatus.pure,
      propertyFontSize: event.value
    );
  }
  Stream<HomePageState> _mapPropertyFontColorEventToState(PropertyFontColorEvent event) async* {
    final currentState = state;
    yield currentState.copyWith(
      status: FormzStatus.pure,
      propertyFontColor: event.color
    );
  }
  Stream<HomePageState> _mapPropertyFontTtfEventToState(PropertyFontTtfEvent event) async* {
    final currentState = state;
    try {
      if(_fontManager.contains(event.fontPath)) return;
      await _fontManager.addFont(event.fontPath.toLowerCase(), event.fontPath);
      yield currentState.copyWith(
        status: FormzStatus.pure,
        propertyFontFamily: event.fontPath
      );
    } catch(err) {
      unawaited(LoggerUtil.getInstance().logError(err.toString(), isWriteToJournal: true));
    }
  }
  Stream<HomePageState> _mapPropertyBorderSizeEventToState(PropertyBorderSizeEvent event) async* {
    final currentState = state;
    yield currentState.copyWith(
      status: FormzStatus.pure,
      propertyBorderWidth: event.value
    );
  }
  Stream<HomePageState> _mapPropertyBorderColorEventToState(PropertyBorderColorEvent event) async* {
    final currentState = state;
    yield currentState.copyWith(
      status: FormzStatus.pure,
      propertyBorderColor: event.color
    );
  }
  Stream<HomePageState> _mapPropertyShadowOffsetXEventToState(PropertyShadowOffsetXEvent event) async* {
    final currentState = state;
    yield currentState.copyWith(
      status: FormzStatus.pure,
      propertyShadowX: event.value
    );
  }
  Stream<HomePageState> _mapPropertyShadowOffsetYEventToState(PropertyShadowOffsetYEvent event) async* {
    final currentState = state;
    yield currentState.copyWith(
      status: FormzStatus.pure,
      propertyShadowY: event.value
    );
  }
  Stream<HomePageState> _mapPropertyShadowSpreadEventToState(PropertyShadowSpreadEvent event) async* {
    final currentState = state;
    yield currentState.copyWith(
      status: FormzStatus.pure,
      propertyShadowSpread: event.value
    );
  }
  Stream<HomePageState> _mapPropertyShadowBlurEventToState(PropertyShadowBlurEvent event) async* {
    final currentState = state;
    yield currentState.copyWith(
      status: FormzStatus.pure,
      propertyShadowBlur: event.value
    );
  }
  Stream<HomePageState> _mapPropertyShadowColorEventToState(PropertyShadowColorEvent event) async* {
    final currentState = state;
    yield currentState.copyWith(
      status: FormzStatus.pure,
      propertyShadowColor: event.color
    );
  }
  Stream<HomePageState> _mapPropertyAlignmentHorizontalEventToState(PropertyAlignmentHorizontalEvent event) async* {
    final currentState = state;
    yield currentState.copyWith(
      status: FormzStatus.pure,
      horizontalAlignment: event.alignment
    );
  }
  Stream<HomePageState> _mapPropertyAlignmentVerticalEventToState(PropertyAlignmentVerticalEvent event) async* {
    final currentState = state;
    yield currentState.copyWith(
      status: FormzStatus.pure,
      verticalAlignment: event.alignment
    );
  }
  Stream<HomePageState> _mapPropertyCanvasResolutionXEventToState(PropertyCanvasResolutionXEvent event) async* {
    final currentState = state;
    yield currentState.copyWith(
      status: FormzStatus.pure,
      propertyCanvasResolutionX: event.value
    );
  }
  Stream<HomePageState> _mapPropertyCanvasResolutionYEventToState(PropertyCanvasResolutionYEvent event) async* {
    final currentState = state;
    yield currentState.copyWith(
      status: FormzStatus.pure,
      propertyCanvasResolutionY: event.value
    );
  }
  Stream<HomePageState> _mapPropertyCanvasColorEventToState(PropertyCanvasColorEvent event) async* {
    final currentState = state;
    yield currentState.copyWith(
      status: FormzStatus.pure,
      propertyCanvasBackgroundColor: event.color
    );
  }

  Stream<HomePageState> _mapPropertySubtitleTextEventToState(PropertySubtitleTextEvent event) async* {
    final currentState = state;
    if(event.text.isEmpty)  {
      yield currentState.copyWith(
        status: FormzStatus.pure,
        propertyText: currentState.propertyText.copyWith(type: PropertyTextType.plain, texts: [])
      );
      return;
    }
    yield currentState.copyWith(
      status: FormzStatus.pure,
      propertyText: currentState.propertyText.copyWith(
        type: PropertyTextType.plain,
        texts: event.text.split('\n').map(
          (e) => TimeText(
            text: e,
            startTimestamp: null,
            endTimeStamp: null,
          )
        ).toList()
      )
    );
  }

  Stream<HomePageState> _mapPropertySrtEventToState(PropertySrtEvent event) async* {
    final currentState = state;

    DateTime Function(String text) transformToDate = (text) {
      List<String> srtTimeRaw = text.split(',');
      List<int> srtTimeTimeRaw = srtTimeRaw[0].split(':').map((e) => int.parse(e)).toList();
      int srtTimeMillesRaw = int.parse(srtTimeRaw[1]);
      int srtTimestamp = (srtTimeTimeRaw[0] * 3600 + srtTimeTimeRaw[1] * 60 + srtTimeTimeRaw[2]) * 1000 + srtTimeMillesRaw;
      return DateTime.fromMillisecondsSinceEpoch(srtTimestamp);
    };
    List<TimeText> texts = [];

    try {
      File file = File(event.srtPath);

      if(await file.exists()) {
        final String srtContent = await file.readAsString();
        final RegExp reg = RegExp(r'(?<order>\d+)\n(?<start>[\d:,]+)\s+-{2}\>\s+(?<end>[\d:,]+)\n(?<text>[\s\S]*?(?=\n{2}|$))', caseSensitive: false, multiLine: true);
        final matches = reg.allMatches(srtContent.replaceAll('\r', ''));
        for(final match in matches) {
          final _ = int.parse(match.namedGroup('order'));
          final startTime = transformToDate(match.namedGroup('start'));
          final endTime = transformToDate(match.namedGroup('end'));
          final text = match.namedGroup('text');

          texts.add(
            TimeText(
              text: text,
              startTimestamp: startTime,
              endTimeStamp: endTime
            )
          );
        }
      }
    } catch(err) {
      yield currentState.copyWith(
        status: FormzStatus.submissionFailure,
        exception: SrtFormatErrorException()
      );
    }

    yield currentState.copyWith(
      status: FormzStatus.pure,
      propertyText: currentState.propertyText.copyWith(
        type: PropertyTextType.srt,
        texts: texts
      )
    );
  }
}