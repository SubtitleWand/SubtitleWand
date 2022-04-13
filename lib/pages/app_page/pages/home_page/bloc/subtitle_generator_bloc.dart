import 'dart:convert';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ffmpeg_repository/ffmpeg_repository.dart';
import 'package:image_repository/image_repository.dart';
import 'package:launcher_repository/launcher_repository.dart';
import 'package:wand_api/wand_api.dart';

import 'package:subtitle_wand/pages/app_page/pages/home_page/widgets/subtitle_panel/subtitle_panel.dart';

class NoException implements Exception {
  const NoException();
}

class NotDetectFFmpegException implements Exception {
  const NotDetectFFmpegException();
}

abstract class SubtitleGeneratorEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

enum SubtitleGeneratorOutputType {
  image,
  video,
}

class SubtitleGeneratorOutputSaved extends SubtitleGeneratorEvent {
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
  final SubtitleGeneratorOutputType type;

  SubtitleGeneratorOutputSaved({
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
    required this.propertySrtPlain,
    required this.propertySrtDatas,
    this.type = SubtitleGeneratorOutputType.image,
  });

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
    ];
  }
}

class SubtitleGeneratorState extends Equatable {
  final NetworkStatus status;
  final double progress;
  final Exception? exception;
  const SubtitleGeneratorState({
    this.status = NetworkStatus.uninit,
    this.progress = 0,
    this.exception,
  });

  @override
  List<Object?> get props => [status, progress, exception];

  SubtitleGeneratorState copyWith({
    NetworkStatus? status,
    double? progress,
    Exception? exception,
  }) {
    return SubtitleGeneratorState(
      status: status ?? this.status,
      progress: progress ?? this.progress,
      exception: exception ?? this.exception,
    );
  }
}

class SubtitleGeneratorBloc
    extends Bloc<SubtitleGeneratorEvent, SubtitleGeneratorState> {
  SubtitleGeneratorBloc({
    required LauncherRepository launcherRepository,
    required ImageRepository imageRepository,
    required FFmpegRepository ffmpegRepository,
  })  : _launcherRepository = launcherRepository,
        _imageRepository = imageRepository,
        _ffmpegRepository = ffmpegRepository,
        super(const SubtitleGeneratorState()) {
    on<SubtitleGeneratorOutputSaved>(_onSubtitleGeneratorOutputSaved);
  }

  final LauncherRepository _launcherRepository;
  final ImageRepository _imageRepository;
  final FFmpegRepository _ffmpegRepository;

  Future<void> _onSubtitleGeneratorOutputSaved(
    SubtitleGeneratorOutputSaved event,
    Emitter<SubtitleGeneratorState> emit,
  ) async {
    emit(
      state.copyWith(
        status: NetworkStatus.inProgress,
        exception: const NoException(),
      ),
    );
    try {
      if (event.type == SubtitleGeneratorOutputType.image) {
        final directory = await _imageRepository.createImageDir();
        await __onGenerateImages(event, emit);
        await _launcherRepository.launch(path: 'file:$directory');
        emit(state.copyWith(status: NetworkStatus.success, progress: 0));
      } else {
        final isDetected = await _ffmpegRepository.isFFmpegEnvDetected();
        if (!isDetected) throw const NotDetectFFmpegException();
        final directory = await _imageRepository.createImageDir();
        await __onGenerateImages(event, emit, isRenderTransparent: true);
        await _ffmpegRepository.writeFFmpegContact(
          texts: event.propertySrtDatas,
          directory: directory,
        );

        await _ffmpegRepository.generateVideo(directory: directory);
        await _launcherRepository.launch(path: 'file:$directory');
        emit(state.copyWith(status: NetworkStatus.success, progress: 0));
      }
    } on NotDetectFFmpegException catch (e) {
      emit(
        state.copyWith(
          status: NetworkStatus.failure,
          exception: e,
          progress: 0,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: NetworkStatus.failure,
          exception: const NoException(),
        ),
      );
    }
  }

  Future<void> __onGenerateImages(
    SubtitleGeneratorOutputSaved event,
    Emitter<SubtitleGeneratorState> emit, {
    bool isRenderTransparent = false,
  }) async {
    final currentState = state;
    Size resolution = Size(
      event.propertyCanvasResolutionX.toDouble(),
      event.propertyCanvasResolutionY.toDouble(),
    );
    final subtitleTexts = event.propertySrtDatas.isNotEmpty
        ? event.propertySrtDatas.map((e) => e.text).toList()
        : const LineSplitter().convert(event.propertySrtPlain);

    for (int i = 0; i < subtitleTexts.length; i++) {
      final text = subtitleTexts[i];
      SubtitlePainter painter = SubtitlePainter(
        propertyPaddingLeft: event.propertyPaddingLeft.toDouble(),
        propertyPaddingRight: event.propertyPaddingRight.toDouble(),
        propertyPaddingTop: event.propertyPaddingTop.toDouble(),
        propertyPaddingBottom: event.propertyPaddingBottom.toDouble(),
        propertyFontSize: event.propertyFontSize.toDouble(),
        propertyFontColor: event.propertyFontColor,
        propertyFontFamily: event.propertyFontFamily,
        propertyBorderWidth: event.propertyBorderWidth.toDouble(),
        propertyBorderColor: event.propertyBorderColor,
        propertyShadowX: event.propertyShadowX.toDouble(),
        propertyShadowY: event.propertyShadowY.toDouble(),
        propertyShadowSpread: event.propertyShadowSpread,
        propertyShadowBlur: event.propertyShadowBlur.toDouble(),
        propertyShadowColor: event.propertyShadowColor,
        verticalAlignment: event.verticalAlignment,
        horizontalAlignment: event.horizontalAlignment,
        propertyCanvasResolutionX: event.propertyCanvasResolutionX.toDouble(),
        propertyCanvasResolutionY: event.propertyCanvasResolutionY.toDouble(),
        propertyCanvasBackgroundColor: event.propertyCanvasBackgroundColor,
        isDrawCanvasBg: false,
        subtitleText: text,
      );
      await renderImage(
        painter,
        resolution,
        'frame_$i',
      );
      emit(
        currentState.copyWith(
          progress: i.toDouble() / subtitleTexts.length.toDouble(),
          status: NetworkStatus.inProgress,
        ),
      );
    }

    if (isRenderTransparent) {
      await renderImage(
        SubtitlePainter(
          propertyPaddingLeft: event.propertyPaddingLeft.toDouble(),
          propertyPaddingRight: event.propertyPaddingRight.toDouble(),
          propertyPaddingTop: event.propertyPaddingTop.toDouble(),
          propertyPaddingBottom: event.propertyPaddingBottom.toDouble(),
          propertyFontSize: event.propertyFontSize.toDouble(),
          propertyFontColor: event.propertyFontColor,
          propertyFontFamily: event.propertyFontFamily,
          propertyBorderWidth: event.propertyBorderWidth.toDouble(),
          propertyBorderColor: event.propertyBorderColor,
          propertyShadowX: event.propertyShadowX.toDouble(),
          propertyShadowY: event.propertyShadowY.toDouble(),
          propertyShadowSpread: event.propertyShadowSpread,
          propertyShadowBlur: event.propertyShadowBlur.toDouble(),
          propertyShadowColor: event.propertyShadowColor,
          verticalAlignment: event.verticalAlignment,
          horizontalAlignment: event.horizontalAlignment,
          propertyCanvasResolutionX: event.propertyCanvasResolutionX.toDouble(),
          propertyCanvasResolutionY: event.propertyCanvasResolutionY.toDouble(),
          propertyCanvasBackgroundColor: event.propertyCanvasBackgroundColor,
          isDrawCanvasBg: false,
          subtitleText: '',
        ),
        resolution,
        'transparent',
      );
    }
  }

  Future<void> renderImage(
    SubtitlePainter painter,
    Size size,
    String filename,
  ) async {
    final recorder = _imageRepository.recorder;
    Canvas canvas = Canvas(recorder);
    painter.paint(canvas, size);
    await _imageRepository.saveImage(
      filename: filename,
      width: size.width.toInt(),
      height: size.height.toInt(),
      recorder: recorder,
    );
  }
}
