import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:subtitle_wand/design/color_palette.dart';

class FramePanel extends StatefulWidget {
  final bool enabled;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final VoidCallback onResetPos;
  final VoidCallback onResetScale;
  const FramePanel({
    Key? key,
    this.enabled = true,
    required this.onPrev,
    required this.onNext,
    required this.onResetPos,
    required this.onResetScale,
  }) : super(key: key);

  @override
  State<FramePanel> createState() => _FramePanelState();
}

class _FramePanelState extends State<FramePanel> {
  // FrameControlWidget f1 f2 keybinding UX
  final Color defaultColor = Colors.white54;
  final Color focusColor = Colors.white;
  late ValueNotifier<Color> f2Color;
  late ValueNotifier<Color> f1Color;

  @override
  void initState() {
    f1Color = ValueNotifier(defaultColor);
    f2Color = ValueNotifier(defaultColor);
    RawKeyboard.instance.addListener((e) {
      final bool isKeyDown = e is RawKeyDownEvent;
      final bool isKeyUp = e is RawKeyUpEvent;

      bool isF2 = e.data.logicalKey == LogicalKeyboardKey.f2;
      bool isF1 = e.data.logicalKey == LogicalKeyboardKey.f1;

      if (isKeyDown) {
        if (isF1) {
          f1Color.value = focusColor;
          widget.onPrev();
        }
        if (isF2) {
          f2Color.value = focusColor;
          widget.onNext();
        }
      }

      if (isKeyUp) {
        if (isF1) f1Color.value = defaultColor;
        if (isF2) f2Color.value = defaultColor;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
      decoration: BoxDecoration(
        color: ColorPalette.accentColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Tooltip(
            message: 'Previous Frame(F1)',
            child: ValueListenableBuilder(
              valueListenable: f1Color,
              builder: (BuildContext context, Color color, Widget? child) {
                return IconButton(
                  onPressed: widget.onPrev,
                  color: color,
                  icon: const Icon(
                    Icons.skip_previous_outlined,
                  ),
                );
              },
            ),
          ),
          Tooltip(
            message: 'Next Frame(F2)',
            child: ValueListenableBuilder(
              valueListenable: f2Color,
              builder: (BuildContext context, Color color, Widget? child) {
                return IconButton(
                  onPressed: widget.onNext,
                  color: color,
                  icon: const Icon(
                    Icons.skip_next_outlined,
                  ),
                );
              },
            ),
          ),
          Tooltip(
            message: 'Reset Position',
            child: IconButton(
              onPressed: widget.onResetPos,
              icon: const Icon(Icons.control_camera_outlined),
            ),
          ),
          Tooltip(
            message: 'Reset Scale',
            child: IconButton(
              onPressed: widget.onResetScale,
              icon: const Icon(Icons.aspect_ratio_outlined),
            ),
          )
        ],
      ),
    );
  }
}
