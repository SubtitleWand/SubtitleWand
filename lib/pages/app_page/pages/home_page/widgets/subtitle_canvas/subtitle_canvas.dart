import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:subtitle_wand/pages/app_page/pages/home_page/widgets/frame_panel.dart';

import 'dart:math' as math;

import 'package:subtitle_wand/pages/app_page/pages/home_page/widgets/subtitle_canvas/subtitle_canvas_controller.dart';
import 'package:subtitle_wand/pages/app_page/pages/home_page/widgets/subtitle_painter/subtitle_painter.dart';

class SubtitleCanvas extends StatefulWidget {
  const SubtitleCanvas({
    Key? key,
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
    required this.subtitles,
  }) : super(key: key);

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
  final List<String> subtitles;

  @override
  State<SubtitleCanvas> createState() => _SubtitleCanvasState();
}

class _SubtitleCanvasState extends State<SubtitleCanvas> {
  late SubtitleCanvasMoveController _subtitleCanvasMoveController;
  late SubtitleCanvasScrollController _subtitleCanvasScrollController;
  bool isTapped = false;
  late ValueNotifier<int> _subtitleIndex;

  @override
  void initState() {
    super.initState();
    _subtitleCanvasMoveController = SubtitleCanvasMoveController(Offset.zero);
    _subtitleCanvasScrollController = SubtitleCanvasScrollController(0);
    _subtitleIndex = ValueNotifier(0);
  }

  @override
  void dispose() {
    _subtitleCanvasMoveController.dispose();
    _subtitleCanvasScrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant SubtitleCanvas oldWidget) {
    if (oldWidget.subtitles.length != widget.subtitles.length) {
      _subtitleIndex.value = math.max(
        0,
        math.min(_subtitleIndex.value, widget.subtitles.length - 1),
      );
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Container(
        color: Colors.black,
        width: double.maxFinite,
        height: double.maxFinite,
        child: Stack(
          children: [
            ValueListenableBuilder(
              valueListenable: _subtitleCanvasMoveController,
              builder: (BuildContext context, dynamic value, Widget? child) {
                return ValueListenableBuilder(
                  valueListenable: _subtitleCanvasScrollController,
                  builder:
                      (BuildContext context, dynamic value, Widget? child) {
                    return ValueListenableBuilder(
                      valueListenable: _subtitleIndex,
                      builder:
                          (BuildContext context, dynamic value, Widget? child) {
                        return CustomPaint(
                          size: const Size(double.maxFinite, double.maxFinite),
                          painter: SubtitlePainter(
                            isDrawCanvasBg: true,
                            propertyPaddingLeft:
                                widget.propertyPaddingLeft.toDouble(),
                            propertyPaddingRight:
                                widget.propertyPaddingRight.toDouble(),
                            propertyPaddingTop:
                                widget.propertyPaddingTop.toDouble(),
                            propertyPaddingBottom:
                                widget.propertyPaddingBottom.toDouble(),
                            propertyFontSize:
                                widget.propertyFontSize.toDouble(),
                            propertyFontColor: widget.propertyFontColor,
                            propertyFontFamily: widget.propertyFontFamily,
                            propertyBorderWidth:
                                widget.propertyBorderWidth.toDouble(),
                            propertyBorderColor: widget.propertyBorderColor,
                            propertyShadowX: widget.propertyShadowX.toDouble(),
                            propertyShadowY: widget.propertyShadowY.toDouble(),
                            propertyShadowSpread: widget.propertyShadowSpread,
                            propertyShadowBlur:
                                widget.propertyShadowBlur.toDouble(),
                            propertyShadowColor: widget.propertyShadowColor,
                            verticalAlignment: widget.verticalAlignment,
                            horizontalAlignment: widget.horizontalAlignment,
                            propertyCanvasResolutionX:
                                widget.propertyCanvasResolutionX.toDouble(),
                            propertyCanvasResolutionY:
                                widget.propertyCanvasResolutionY.toDouble(),
                            propertyCanvasBackgroundColor:
                                widget.propertyCanvasBackgroundColor,
                            translation: _subtitleCanvasMoveController.value,
                            scaleOffset: _subtitleCanvasScrollController.value,
                            subtitleText: widget.subtitles.isEmpty
                                ? ''
                                : widget.subtitles[_subtitleIndex.value],
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
            Listener(
              onPointerDown: (pointer) {
                isTapped = true;
              },
              onPointerMove: (pointer) {
                if (!isTapped) return;
                _subtitleCanvasMoveController.value -= pointer.delta;
              },
              onPointerUp: (pointer) {
                isTapped = false;
              },
              onPointerSignal: (pointer) {
                if (pointer is PointerScrollEvent) {
                  _subtitleCanvasScrollController.value = math.max(
                    0.0,
                    _subtitleCanvasScrollController.value +
                        (pointer.scrollDelta.dy / 1000),
                  );
                }
              },
              child: Container(
                color: Colors.transparent,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: FramePanel(
                onPrev: () {
                  _subtitleIndex.value = math.max(_subtitleIndex.value - 1, 0);
                },
                onNext: () {
                  _subtitleIndex.value = math.min(
                    _subtitleIndex.value + 1,
                    widget.subtitles.length - 1,
                  );
                },
                onResetPos: () {
                  _subtitleCanvasMoveController.value = Offset.zero;
                },
                onResetScale: () {
                  _subtitleCanvasScrollController.value = 0;
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
