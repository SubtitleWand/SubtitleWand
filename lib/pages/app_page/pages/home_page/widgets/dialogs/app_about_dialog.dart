import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launcher_repository/launcher_repository.dart';
import 'package:subtitle_wand/_gen/version.gen.dart';
import 'package:subtitle_wand/design/color_palette.dart';

class AppAboutDialog extends StatelessWidget {
  const AppAboutDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextStyle? style = Theme.of(context)
        .textTheme
        .bodyText2
        ?.copyWith(color: ColorPalette.fontColor);
    final TextStyle? endStyle = Theme.of(context)
        .textTheme
        .bodyText2
        ?.copyWith(color: ColorPalette.accentColor);
    final TextStyle? contentStyle = Theme.of(context)
        .textTheme
        .headline6
        ?.copyWith(color: ColorPalette.fontColor);
    return Dialog(
      backgroundColor: ColorPalette.secondaryColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Image.asset(
              'resources/icon.png',
              width: 48,
              height: 48,
            ),
          ),
          RichText(
            text: TextSpan(
              style: style,
              children: [
                TextSpan(
                  text: 'Subtitle Wand',
                  style: style?.copyWith(decoration: TextDecoration.underline),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      const url =
                          'https://github.com/SubtitleWand/SubtitleWand';
                      context.read<LauncherRepository>().launch(path: url);
                    },
                ),
                TextSpan(text: '  v$packageVersion', style: style),
              ],
            ),
          ),
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width / 2,
            ),
            padding: const EdgeInsets.all(16),
            child: RichText(
              text: TextSpan(
                style: contentStyle,
                children: [
                  const TextSpan(
                    text:
                        'The project is inspired by my favorite video editor, ',
                  ),
                  TextSpan(
                    text: 'Hitfilm',
                    style: const TextStyle(
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        const url = 'https://fxhome.com/hitfilm-express';
                        context.read<LauncherRepository>().launch(path: url);
                      },
                  ),
                  const TextSpan(text: '.\n'),
                  // TextSpan(text: 'The lack of Subtitle & Srt made this project progress.'),
                  const TextSpan(
                    text: 'File any issue or idea, please make an issue on ',
                  ),
                  TextSpan(
                    text: 'github',
                    style: const TextStyle(
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        const url =
                            'https://github.com/SubtitleWand/SubtitleWand/issues/new/choose';
                        context.read<LauncherRepository>().launch(path: url);
                      },
                  ),
                  const TextSpan(text: '. '),
                ],
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SelectableText(
                'Developer. Chinyun',
                style: endStyle,
              ),
              SelectableText('Contact. tokenyete@gmail.com', style: endStyle),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
