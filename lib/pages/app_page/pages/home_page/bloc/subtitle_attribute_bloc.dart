import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/rendering.dart';
import 'package:subtitle_wand/pages/app_page/pages/home_page/widgets/subtitle_painter/subtitle_painter.dart';
import 'package:wand_api/wand_api.dart';

abstract class SubtitleAttributeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// class SubtitleAttributeReset extends SubtitleAttributeEvent {
//   SubtitleAttributeReset();
// }

class SubtitlePropertyPaddingLeftChanged extends SubtitleAttributeEvent {
  final int propertyPaddingLeft;
  SubtitlePropertyPaddingLeftChanged({required this.propertyPaddingLeft});

  @override
  List<Object?> get props => [propertyPaddingLeft];
}

class SubtitlePropertyPaddingRightChanged extends SubtitleAttributeEvent {
  final int propertyPaddingRight;
  SubtitlePropertyPaddingRightChanged({required this.propertyPaddingRight});

  @override
  List<Object?> get props => [propertyPaddingRight];
}

class SubtitlePropertyPaddingTopChanged extends SubtitleAttributeEvent {
  final int propertyPaddingTop;
  SubtitlePropertyPaddingTopChanged({required this.propertyPaddingTop});

  @override
  List<Object?> get props => [propertyPaddingTop];
}

class SubtitlePropertyPaddingBottomChanged extends SubtitleAttributeEvent {
  final int propertyPaddingBottom;
  SubtitlePropertyPaddingBottomChanged({required this.propertyPaddingBottom});

  @override
  List<Object?> get props => [propertyPaddingBottom];
}

class SubtitlePropertyFontSizeChanged extends SubtitleAttributeEvent {
  final int propertyFontSize;
  SubtitlePropertyFontSizeChanged({required this.propertyFontSize});

  @override
  List<Object?> get props => [propertyFontSize];
}

class SubtitlePropertyFontColorChanged extends SubtitleAttributeEvent {
  final Color propertyFontColor;
  SubtitlePropertyFontColorChanged({required this.propertyFontColor});

  @override
  List<Object?> get props => [propertyFontColor];
}

class SubtitlePropertyFontFamilyChanged extends SubtitleAttributeEvent {
  final String? propertyFontFamily;
  SubtitlePropertyFontFamilyChanged({required this.propertyFontFamily});

  @override
  List<Object?> get props => [propertyFontFamily];
}

class SubtitlePropertyBorderWidthChanged extends SubtitleAttributeEvent {
  final int propertyBorderWidth;
  SubtitlePropertyBorderWidthChanged({required this.propertyBorderWidth});

  @override
  List<Object?> get props => [propertyBorderWidth];
}

class SubtitlePropertyBorderColorChanged extends SubtitleAttributeEvent {
  final Color propertyBorderColor;
  SubtitlePropertyBorderColorChanged({required this.propertyBorderColor});

  @override
  List<Object?> get props => [propertyBorderColor];
}

class SubtitlePropertyShadowXChanged extends SubtitleAttributeEvent {
  final int propertyShadowX;
  SubtitlePropertyShadowXChanged({required this.propertyShadowX});

  @override
  List<Object?> get props => [propertyShadowX];
}

class SubtitlePropertyShadowYChanged extends SubtitleAttributeEvent {
  final int propertyShadowY;
  SubtitlePropertyShadowYChanged({required this.propertyShadowY});

  @override
  List<Object?> get props => [propertyShadowY];
}

class SubtitlePropertyShadowSpreadChanged extends SubtitleAttributeEvent {
  final int propertyShadowSpread;
  SubtitlePropertyShadowSpreadChanged({required this.propertyShadowSpread});

  @override
  List<Object?> get props => [propertyShadowSpread];
}

class SubtitlePropertyShadowBlurChanged extends SubtitleAttributeEvent {
  final int propertyShadowBlur;
  SubtitlePropertyShadowBlurChanged({required this.propertyShadowBlur});

  @override
  List<Object?> get props => [propertyShadowBlur];
}

class SubtitlePropertyShadowColorChanged extends SubtitleAttributeEvent {
  final Color propertyShadowColor;
  SubtitlePropertyShadowColorChanged({required this.propertyShadowColor});

  @override
  List<Object?> get props => [propertyShadowColor];
}

class SubtitleVerticalAlignmentChanged extends SubtitleAttributeEvent {
  final SubtitleVerticalAlignment verticalAlignment;
  SubtitleVerticalAlignmentChanged({required this.verticalAlignment});

  @override
  List<Object?> get props => [verticalAlignment];
}

class SubtitleHorizontalAlignmentChanged extends SubtitleAttributeEvent {
  final SubtitleHorizontalAlignment horizontalAlignment;
  SubtitleHorizontalAlignmentChanged({required this.horizontalAlignment});

  @override
  List<Object?> get props => [horizontalAlignment];
}

class SubtitlePropertyCanvasResolutionXChanged extends SubtitleAttributeEvent {
  final int propertyCanvasResolutionX;
  SubtitlePropertyCanvasResolutionXChanged({
    required this.propertyCanvasResolutionX,
  });

  @override
  List<Object?> get props => [propertyCanvasResolutionX];
}

class SubtitlePropertyCanvasResolutionYChanged extends SubtitleAttributeEvent {
  final int propertyCanvasResolutionY;
  SubtitlePropertyCanvasResolutionYChanged({
    required this.propertyCanvasResolutionY,
  });

  @override
  List<Object?> get props => [propertyCanvasResolutionY];
}

class SubtitlePropertyCanvasBackgroundColorChanged
    extends SubtitleAttributeEvent {
  final Color propertyCanvasBackgroundColor;
  SubtitlePropertyCanvasBackgroundColorChanged({
    required this.propertyCanvasBackgroundColor,
  });

  @override
  List<Object?> get props => [propertyCanvasBackgroundColor];
}

class SubtitlePropertySrtPlainChanged extends SubtitleAttributeEvent {
  final String propertySrtPlain;
  SubtitlePropertySrtPlainChanged({required this.propertySrtPlain});

  @override
  List<Object?> get props => [propertySrtPlain];
}

class SubtitlePropertySrtDatasChanged extends SubtitleAttributeEvent {
  final List<TimeText> propertySrtDatas;
  SubtitlePropertySrtDatasChanged({required this.propertySrtDatas});

  @override
  List<Object?> get props => [propertySrtDatas];
}

class SubtitleAttributeState extends Equatable {
  final int propertyPaddingLeft;
  final int propertyPaddingRight;
  final int propertyPaddingTop;
  final int propertyPaddingBottom;
  final int propertyFontSize;
  final Color propertyFontColor;
  final String? propertyFontFamily; // nullable to default font
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
  final String propertySrtPlain;
  final List<TimeText> propertySrtDatas;
  final NetworkStatus status;
  const SubtitleAttributeState({
    this.propertyPaddingLeft = 0,
    this.propertyPaddingRight = 0,
    this.propertyPaddingTop = 0,
    this.propertyPaddingBottom = 0,
    this.propertyFontSize = 28,
    this.propertyFontColor = const Color(0xffffffff),
    this.propertyFontFamily,
    this.propertyBorderWidth = 0,
    this.propertyBorderColor = const Color(0xff3282b8),
    this.propertyShadowX = 0,
    this.propertyShadowY = 0,
    this.propertyShadowSpread = 0,
    this.propertyShadowBlur = 0,
    this.propertyShadowColor = const Color(0xff000000),
    this.verticalAlignment = SubtitleVerticalAlignment.center,
    this.horizontalAlignment = SubtitleHorizontalAlignment.center,
    this.propertyCanvasResolutionX = 1920,
    this.propertyCanvasResolutionY = 1080,
    this.propertyCanvasBackgroundColor = const Color(0xff253643),
    this.propertySrtPlain = '',
    this.propertySrtDatas = const [],
    this.status = NetworkStatus.uninit,
  });

  SubtitleAttributeState copyWith({
    int? propertyPaddingLeft,
    int? propertyPaddingRight,
    int? propertyPaddingTop,
    int? propertyPaddingBottom,
    int? propertyFontSize,
    Color? propertyFontColor,
    String? propertyFontFamily,
    int? propertyBorderWidth,
    Color? propertyBorderColor,
    int? propertyShadowX,
    int? propertyShadowY,
    int? propertyShadowSpread,
    int? propertyShadowBlur,
    Color? propertyShadowColor,
    SubtitleVerticalAlignment? verticalAlignment,
    SubtitleHorizontalAlignment? horizontalAlignment,
    int? propertyCanvasResolutionX,
    int? propertyCanvasResolutionY,
    Color? propertyCanvasBackgroundColor,
    String? propertySrtPlain,
    List<TimeText>? propertySrtDatas,
    NetworkStatus? status,
  }) {
    return SubtitleAttributeState(
      propertyPaddingLeft: propertyPaddingLeft ?? this.propertyPaddingLeft,
      propertyPaddingRight: propertyPaddingRight ?? this.propertyPaddingRight,
      propertyPaddingTop: propertyPaddingTop ?? this.propertyPaddingTop,
      propertyPaddingBottom:
          propertyPaddingBottom ?? this.propertyPaddingBottom,
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
      propertyCanvasResolutionX:
          propertyCanvasResolutionX ?? this.propertyCanvasResolutionX,
      propertyCanvasResolutionY:
          propertyCanvasResolutionY ?? this.propertyCanvasResolutionY,
      propertyCanvasBackgroundColor:
          propertyCanvasBackgroundColor ?? this.propertyCanvasBackgroundColor,
      propertySrtPlain: propertySrtPlain ?? this.propertySrtPlain,
      propertySrtDatas: propertySrtDatas ?? this.propertySrtDatas,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props {
    return [
      propertyPaddingLeft,
      propertyPaddingRight,
      propertyPaddingTop,
      propertyPaddingBottom,
      propertyFontSize,
      propertyFontColor,
      propertyFontFamily,
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
      propertySrtPlain,
      propertySrtDatas,
      status,
    ];
  }
}

class SubtitleAttributeBloc
    extends Bloc<SubtitleAttributeEvent, SubtitleAttributeState> {
  SubtitleAttributeBloc() : super(const SubtitleAttributeState()) {
    // on<SubtitleAttributeReset>(
    //   _onSubtitleAttributeReset,
    // );
    on<SubtitlePropertyPaddingLeftChanged>(
      _onSubtitlePropertyPaddingLeftChanged,
    );
    on<SubtitlePropertyPaddingRightChanged>(
      _onSubtitlePropertyPaddingRightChanged,
    );
    on<SubtitlePropertyPaddingTopChanged>(
      _onSubtitlePropertyPaddingTopChanged,
    );
    on<SubtitlePropertyPaddingBottomChanged>(
      _onSubtitlePropertyPaddingBottomChanged,
    );
    on<SubtitlePropertyFontSizeChanged>(
      _onSubtitlePropertyFontSizeChanged,
    );
    on<SubtitlePropertyFontColorChanged>(
      _onSubtitlePropertyFontColorChanged,
    );
    on<SubtitlePropertyFontFamilyChanged>(
      _onSubtitlePropertyFontFamilyChanged,
    );
    on<SubtitlePropertyBorderWidthChanged>(
      _onSubtitlePropertyBorderWidthChanged,
    );
    on<SubtitlePropertyBorderColorChanged>(
      _onSubtitlePropertyBorderColorChanged,
    );
    on<SubtitlePropertyShadowXChanged>(
      _onSubtitlePropertyShadowXChanged,
    );
    on<SubtitlePropertyShadowYChanged>(
      _onSubtitlePropertyShadowYChanged,
    );
    on<SubtitlePropertyShadowSpreadChanged>(
      _onSubtitlePropertyShadowSpreadChanged,
    );
    on<SubtitlePropertyShadowBlurChanged>(
      _onSubtitlePropertyShadowBlurChanged,
    );
    on<SubtitlePropertyShadowColorChanged>(
      _onSubtitlePropertyShadowColorChanged,
    );
    on<SubtitleVerticalAlignmentChanged>(
      _onSubtitleVerticalAlignmentChanged,
    );
    on<SubtitleHorizontalAlignmentChanged>(
      _onSubtitleHorizontalAlignmentChanged,
    );
    on<SubtitlePropertyCanvasResolutionXChanged>(
      _onSubtitlePropertyCanvasResolutionXChanged,
    );
    on<SubtitlePropertyCanvasResolutionYChanged>(
      _onSubtitlePropertyCanvasResolutionYChanged,
    );
    on<SubtitlePropertyCanvasBackgroundColorChanged>(
      _onSubtitlePropertyCanvasBackgroundColorChanged,
    );
    on<SubtitlePropertySrtPlainChanged>(
      _onSubtitlePropertySrtPlainChanged,
    );
    on<SubtitlePropertySrtDatasChanged>(
      _onSubtitlePropertySrtDatasChanged,
    );
  }

  // Future<void> _onSubtitleAttributeReset(
  //   SubtitleAttributeReset event,
  //   Emitter<SubtitleAttributeState> emit,
  // ) async {
  //   emit(const SubtitleAttributeState());
  // }

  Future<void> _onSubtitlePropertyPaddingLeftChanged(
    SubtitlePropertyPaddingLeftChanged event,
    Emitter<SubtitleAttributeState> emit,
  ) async {
    emit(state.copyWith(propertyPaddingLeft: event.propertyPaddingLeft));
  }

  Future<void> _onSubtitlePropertyPaddingRightChanged(
    SubtitlePropertyPaddingRightChanged event,
    Emitter<SubtitleAttributeState> emit,
  ) async {
    emit(state.copyWith(propertyPaddingRight: event.propertyPaddingRight));
  }

  Future<void> _onSubtitlePropertyPaddingTopChanged(
    SubtitlePropertyPaddingTopChanged event,
    Emitter<SubtitleAttributeState> emit,
  ) async {
    emit(state.copyWith(propertyPaddingTop: event.propertyPaddingTop));
  }

  Future<void> _onSubtitlePropertyPaddingBottomChanged(
    SubtitlePropertyPaddingBottomChanged event,
    Emitter<SubtitleAttributeState> emit,
  ) async {
    emit(state.copyWith(propertyPaddingBottom: event.propertyPaddingBottom));
  }

  Future<void> _onSubtitlePropertyFontSizeChanged(
    SubtitlePropertyFontSizeChanged event,
    Emitter<SubtitleAttributeState> emit,
  ) async {
    emit(state.copyWith(propertyFontSize: event.propertyFontSize));
  }

  Future<void> _onSubtitlePropertyFontColorChanged(
    SubtitlePropertyFontColorChanged event,
    Emitter<SubtitleAttributeState> emit,
  ) async {
    emit(state.copyWith(propertyFontColor: event.propertyFontColor));
  }

  Future<void> _onSubtitlePropertyFontFamilyChanged(
    SubtitlePropertyFontFamilyChanged event,
    Emitter<SubtitleAttributeState> emit,
  ) async {
    final value = event.propertyFontFamily;
    if (value == null || value.isEmpty) {
      return;
    }
    emit(state.copyWith(propertyFontFamily: event.propertyFontFamily));
  }

  Future<void> _onSubtitlePropertyBorderWidthChanged(
    SubtitlePropertyBorderWidthChanged event,
    Emitter<SubtitleAttributeState> emit,
  ) async {
    emit(state.copyWith(propertyBorderWidth: event.propertyBorderWidth));
  }

  Future<void> _onSubtitlePropertyBorderColorChanged(
    SubtitlePropertyBorderColorChanged event,
    Emitter<SubtitleAttributeState> emit,
  ) async {
    emit(state.copyWith(propertyBorderColor: event.propertyBorderColor));
  }

  Future<void> _onSubtitlePropertyShadowXChanged(
    SubtitlePropertyShadowXChanged event,
    Emitter<SubtitleAttributeState> emit,
  ) async {
    emit(state.copyWith(propertyShadowX: event.propertyShadowX));
  }

  Future<void> _onSubtitlePropertyShadowYChanged(
    SubtitlePropertyShadowYChanged event,
    Emitter<SubtitleAttributeState> emit,
  ) async {
    emit(state.copyWith(propertyShadowY: event.propertyShadowY));
  }

  Future<void> _onSubtitlePropertyShadowSpreadChanged(
    SubtitlePropertyShadowSpreadChanged event,
    Emitter<SubtitleAttributeState> emit,
  ) async {
    emit(state.copyWith(propertyShadowSpread: event.propertyShadowSpread));
  }

  Future<void> _onSubtitlePropertyShadowBlurChanged(
    SubtitlePropertyShadowBlurChanged event,
    Emitter<SubtitleAttributeState> emit,
  ) async {
    emit(state.copyWith(propertyShadowBlur: event.propertyShadowBlur));
  }

  Future<void> _onSubtitlePropertyShadowColorChanged(
    SubtitlePropertyShadowColorChanged event,
    Emitter<SubtitleAttributeState> emit,
  ) async {
    emit(state.copyWith(propertyShadowColor: event.propertyShadowColor));
  }

  Future<void> _onSubtitleVerticalAlignmentChanged(
    SubtitleVerticalAlignmentChanged event,
    Emitter<SubtitleAttributeState> emit,
  ) async {
    emit(state.copyWith(verticalAlignment: event.verticalAlignment));
  }

  Future<void> _onSubtitleHorizontalAlignmentChanged(
    SubtitleHorizontalAlignmentChanged event,
    Emitter<SubtitleAttributeState> emit,
  ) async {
    emit(state.copyWith(horizontalAlignment: event.horizontalAlignment));
  }

  Future<void> _onSubtitlePropertyCanvasResolutionXChanged(
    SubtitlePropertyCanvasResolutionXChanged event,
    Emitter<SubtitleAttributeState> emit,
  ) async {
    emit(
      state.copyWith(
        propertyCanvasResolutionX: event.propertyCanvasResolutionX,
      ),
    );
  }

  Future<void> _onSubtitlePropertyCanvasResolutionYChanged(
    SubtitlePropertyCanvasResolutionYChanged event,
    Emitter<SubtitleAttributeState> emit,
  ) async {
    emit(
      state.copyWith(
        propertyCanvasResolutionY: event.propertyCanvasResolutionY,
      ),
    );
  }

  Future<void> _onSubtitlePropertyCanvasBackgroundColorChanged(
    SubtitlePropertyCanvasBackgroundColorChanged event,
    Emitter<SubtitleAttributeState> emit,
  ) async {
    emit(
      state.copyWith(
        propertyCanvasBackgroundColor: event.propertyCanvasBackgroundColor,
      ),
    );
  }

  Future<void> _onSubtitlePropertySrtPlainChanged(
    SubtitlePropertySrtPlainChanged event,
    Emitter<SubtitleAttributeState> emit,
  ) async {
    emit(
      state.copyWith(
        propertySrtPlain: event.propertySrtPlain,
        propertySrtDatas: [],
      ),
    );
  }

  Future<void> _onSubtitlePropertySrtDatasChanged(
    SubtitlePropertySrtDatasChanged event,
    Emitter<SubtitleAttributeState> emit,
  ) async {
    emit(
      state.copyWith(
        propertySrtDatas: event.propertySrtDatas,
        propertySrtPlain: '',
      ),
    );
  }
}
