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

import 'dart:convert';

import 'package:ffmpeg_repository/ffmpeg_repository.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_repository/font_repository.dart';
import 'package:image_repository/image_repository.dart';
import 'package:launcher_repository/launcher_repository.dart';
import 'package:srt_repository/srt_repository.dart';
import 'package:subtitle_wand/design/color_palette.dart';
import 'package:subtitle_wand/pages/app_page/pages/home_page/bloc/font_picker_cubit.dart';
import 'package:subtitle_wand/pages/app_page/pages/home_page/bloc/subtitle_attribute_bloc.dart';
import 'package:subtitle_wand/pages/app_page/pages/home_page/bloc/subtitle_generator_bloc.dart';
import 'package:subtitle_wand/pages/app_page/pages/home_page/bloc/subtitle_picker_cubit.dart';
import 'package:subtitle_wand/pages/app_page/pages/home_page/widgets/footer.dart';
import 'package:subtitle_wand/pages/app_page/pages/home_page/widgets/header.dart';
import 'package:subtitle_wand/pages/app_page/pages/home_page/widgets/subtitle_attribute_panel.dart';
import 'package:subtitle_wand/pages/app_page/pages/home_page/widgets/subtitle_canvas/subtitle_canvas.dart';
import 'package:wand_api/wand_api.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              FontPickerCubit(fontRepository: context.read<FontRepository>()),
        ),
        BlocProvider(
          create: (context) => SubtitlePickerCubit(
            srtRepository: context.read<SrtRepository>(),
          ),
        ),
        BlocProvider(
          create: (context) => SubtitleAttributeBloc(),
        ),
        BlocProvider(
          create: (context) => SubtitleGeneratorBloc(
            ffmpegRepository: context.read<FFmpegRepository>(),
            imageRepository: context.read<ImageRepository>(),
            launcherRepository: context.read<LauncherRepository>(),
          ),
          child: Container(),
        )
      ],
      child: const HomePageView(),
    );
  }
}

class HomePageView extends StatefulWidget {
  const HomePageView({Key? key}) : super(key: key);

  @override
  _HomePageViewState createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView>
    with SingleTickerProviderStateMixin {
  // Bloc
  // late MPB.HomePageBloc _bloc;
  // Core tool
  // late SubtitlePainter _painter;

  Widget frameControlButton(
    BuildContext context, {
    required bool isMinimize,
    required Color dynamicButtonColor,
    String title = 'Untitled',
    required void Function() onTap,
    required IconData iconData,
  }) {
    TextStyle? btnTextStyle = Theme.of(context).textTheme.subtitle2;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(
            //color: dynamicButtonColor,
            gradient: LinearGradient(
              stops: const [0, 0.15, 0.85, 1],
              colors: [
                ColorPalette.secondaryColor
                    .withOpacity(dynamicButtonColor.alpha / 255),
                ColorPalette.accentColor
                    .withOpacity(dynamicButtonColor.alpha / 255),
                ColorPalette.accentColor
                    .withOpacity(dynamicButtonColor.alpha / 255),
                ColorPalette.secondaryColor
                    .withOpacity(dynamicButtonColor.alpha / 255),
              ],
            ),
            border: Border.all(color: ColorPalette.secondaryColor),
            borderRadius: BorderRadius.circular(8),
          ),
          constraints: BoxConstraints(
            minWidth: isMinimize ? 48 : 160,
            minHeight: 48,
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: isMinimize
                ? [
                    Icon(
                      iconData,
                      color: btnTextStyle?.color,
                    ),
                  ]
                : <Widget>[
                    Icon(
                      iconData,
                      color: btnTextStyle?.color,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: btnTextStyle,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // _bloc = MPB.HomePageBloc();
  }

  @override
  void dispose() {
    // _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTextStyle(
        style: TextStyle(color: ColorPalette.fontColor),
        child: BlocListener<SubtitleGeneratorBloc, SubtitleGeneratorState>(
          listener: (context, state) {
            // if (state.status.isSubmissionSuccess && state.openDir.isNotEmpty) {
            //   final path = state.openDir;
            //   if (Platform.isWindows) {
            //     final result = Process.runSync(
            //       'explorer',
            //       [path],
            //       runInShell: true,
            //       workingDirectory: Directory.current.path,
            //     );
            //     if (!ProcessUtil.isEmpty(result.stderr)) {}
            //   } else if (Platform.isLinux) {
            //     final result = Process.runSync(
            //       'nautilus',
            //       [path],
            //       runInShell: true,
            //       workingDirectory: Directory.current.path,
            //     );
            //     if (!ProcessUtil.isEmpty(result.stderr)) {}
            //   } else if (Platform.isMacOS) {
            //     final result = Process.runSync(
            //       'open',
            //       [path],
            //       runInShell: true,
            //       workingDirectory: Directory.current.path,
            //     );
            //     if (!ProcessUtil.isEmpty(result.stderr)) {}
            //   }
            // }

            if (state.exception is NotDetectFFmpegException) {
              showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: RichText(
                        text: TextSpan(
                          style: Theme.of(context)
                              .textTheme
                              .headline5
                              ?.copyWith(color: Colors.black),
                          children: [
                            const TextSpan(
                              text:
                                  'FFmpeg not detected! You should install from ',
                            ),
                            TextSpan(
                              text: 'here',
                              style: TextStyle(
                                color: ColorPalette.secondaryColor,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  const url =
                                      'https://ffmpeg.org/download.html';
                                  context
                                      .read<LauncherRepository>()
                                      .launch(path: url);
                                },
                            ),
                            const TextSpan(
                              text:
                                  ', and check If ffmpeg is added in enviroment variable.',
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
          child: BlocBuilder<SubtitleGeneratorBloc, SubtitleGeneratorState>(
            buildWhen: (previous, current) => previous.status != current.status,
            builder: (context, state) {
              bool isSavingState = state.status == NetworkStatus.inProgress;
              return AbsorbPointer(
                absorbing: isSavingState,
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    Colors.grey,
                    isSavingState ? BlendMode.saturation : BlendMode.dst,
                  ),
                  child: Column(
                    children: <Widget>[
                      Header(
                        onSaveImage: () {
                          final subtitleAttributeBloc =
                              context.read<SubtitleAttributeBloc>();
                          context.read<SubtitleGeneratorBloc>().add(
                                SubtitleGeneratorOutputSaved(
                                  propertyPaddingLeft: subtitleAttributeBloc
                                      .state.propertyPaddingLeft,
                                  propertyPaddingRight: subtitleAttributeBloc
                                      .state.propertyPaddingRight,
                                  propertyPaddingTop: subtitleAttributeBloc
                                      .state.propertyPaddingTop,
                                  propertyPaddingBottom: subtitleAttributeBloc
                                      .state.propertyPaddingBottom,
                                  propertyFontSize: subtitleAttributeBloc
                                      .state.propertyFontSize,
                                  propertyFontColor: subtitleAttributeBloc
                                      .state.propertyFontColor,
                                  propertyBorderWidth: subtitleAttributeBloc
                                      .state.propertyBorderWidth,
                                  propertyBorderColor: subtitleAttributeBloc
                                      .state.propertyBorderColor,
                                  propertyShadowX: subtitleAttributeBloc
                                      .state.propertyShadowX,
                                  propertyShadowY: subtitleAttributeBloc
                                      .state.propertyShadowY,
                                  propertyShadowSpread: subtitleAttributeBloc
                                      .state.propertyShadowSpread,
                                  propertyShadowBlur: subtitleAttributeBloc
                                      .state.propertyShadowBlur,
                                  propertyShadowColor: subtitleAttributeBloc
                                      .state.propertyShadowColor,
                                  verticalAlignment: subtitleAttributeBloc
                                      .state.verticalAlignment,
                                  horizontalAlignment: subtitleAttributeBloc
                                      .state.horizontalAlignment,
                                  propertyCanvasResolutionX:
                                      subtitleAttributeBloc
                                          .state.propertyCanvasResolutionX,
                                  propertyCanvasResolutionY:
                                      subtitleAttributeBloc
                                          .state.propertyCanvasResolutionY,
                                  propertyCanvasBackgroundColor:
                                      subtitleAttributeBloc
                                          .state.propertyCanvasBackgroundColor,
                                  propertySrtPlain: subtitleAttributeBloc
                                      .state.propertySrtPlain,
                                  propertySrtDatas: subtitleAttributeBloc
                                      .state.propertySrtDatas,
                                  propertyFontFamily: subtitleAttributeBloc
                                      .state.propertyFontFamily,
                                  type: SubtitleGeneratorOutputType.image,
                                ),
                              );
                        },
                        onSaveVideo: () {
                          final subtitleAttributeBloc =
                              context.read<SubtitleAttributeBloc>();
                          context.read<SubtitleGeneratorBloc>().add(
                                SubtitleGeneratorOutputSaved(
                                  propertyPaddingLeft: subtitleAttributeBloc
                                      .state.propertyPaddingLeft,
                                  propertyPaddingRight: subtitleAttributeBloc
                                      .state.propertyPaddingRight,
                                  propertyPaddingTop: subtitleAttributeBloc
                                      .state.propertyPaddingTop,
                                  propertyPaddingBottom: subtitleAttributeBloc
                                      .state.propertyPaddingBottom,
                                  propertyFontSize: subtitleAttributeBloc
                                      .state.propertyFontSize,
                                  propertyFontColor: subtitleAttributeBloc
                                      .state.propertyFontColor,
                                  propertyBorderWidth: subtitleAttributeBloc
                                      .state.propertyBorderWidth,
                                  propertyBorderColor: subtitleAttributeBloc
                                      .state.propertyBorderColor,
                                  propertyShadowX: subtitleAttributeBloc
                                      .state.propertyShadowX,
                                  propertyShadowY: subtitleAttributeBloc
                                      .state.propertyShadowY,
                                  propertyShadowSpread: subtitleAttributeBloc
                                      .state.propertyShadowSpread,
                                  propertyShadowBlur: subtitleAttributeBloc
                                      .state.propertyShadowBlur,
                                  propertyShadowColor: subtitleAttributeBloc
                                      .state.propertyShadowColor,
                                  verticalAlignment: subtitleAttributeBloc
                                      .state.verticalAlignment,
                                  horizontalAlignment: subtitleAttributeBloc
                                      .state.horizontalAlignment,
                                  propertyCanvasResolutionX:
                                      subtitleAttributeBloc
                                          .state.propertyCanvasResolutionX,
                                  propertyCanvasResolutionY:
                                      subtitleAttributeBloc
                                          .state.propertyCanvasResolutionY,
                                  propertyCanvasBackgroundColor:
                                      subtitleAttributeBloc
                                          .state.propertyCanvasBackgroundColor,
                                  propertySrtPlain: subtitleAttributeBloc
                                      .state.propertySrtPlain,
                                  propertySrtDatas: subtitleAttributeBloc
                                      .state.propertySrtDatas,
                                  propertyFontFamily: subtitleAttributeBloc
                                      .state.propertyFontFamily,
                                  type: SubtitleGeneratorOutputType.video,
                                ),
                              );
                        },
                      ),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: ColorPalette.primaryColor.withGreen(80),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            // SubtitleFrame Section
                            Expanded(
                              child: Stack(
                                children: [
                                  BlocBuilder<SubtitleAttributeBloc,
                                      SubtitleAttributeState>(
                                    builder: (context, state) {
                                      final subtitles = <String>[];
                                      if (state.propertySrtDatas.isNotEmpty) {
                                        subtitles.addAll(
                                          state.propertySrtDatas
                                              .map((e) => e.text),
                                        );
                                      } else {
                                        subtitles.addAll(
                                          LineSplitter.split(
                                            state.propertySrtPlain,
                                          ),
                                        );
                                      }
                                      return SubtitleCanvas(
                                        propertyPaddingLeft:
                                            state.propertyPaddingLeft,
                                        propertyPaddingRight:
                                            state.propertyPaddingRight,
                                        propertyPaddingTop:
                                            state.propertyPaddingTop,
                                        propertyPaddingBottom:
                                            state.propertyPaddingBottom,
                                        propertyFontSize:
                                            state.propertyFontSize,
                                        propertyFontColor:
                                            state.propertyFontColor,
                                        propertyFontFamily:
                                            state.propertyFontFamily,
                                        propertyBorderWidth:
                                            state.propertyBorderWidth,
                                        propertyBorderColor:
                                            state.propertyBorderColor,
                                        propertyShadowX: state.propertyShadowX,
                                        propertyShadowY: state.propertyShadowY,
                                        propertyShadowSpread:
                                            state.propertyShadowSpread,
                                        propertyShadowBlur:
                                            state.propertyShadowBlur,
                                        propertyShadowColor:
                                            state.propertyShadowColor,
                                        verticalAlignment:
                                            state.verticalAlignment,
                                        horizontalAlignment:
                                            state.horizontalAlignment,
                                        propertyCanvasResolutionX:
                                            state.propertyCanvasResolutionX,
                                        propertyCanvasResolutionY:
                                            state.propertyCanvasResolutionY,
                                        propertyCanvasBackgroundColor:
                                            state.propertyCanvasBackgroundColor,
                                        subtitles: subtitles,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            VerticalDivider(
                              width: 1,
                              thickness: 1,
                              color: ColorPalette.primaryColor,
                            ),
                            // Properties Section
                            const SubtitleAttributePanel()
                          ],
                        ),
                      ),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: ColorPalette.secondaryColor,
                      ),
                      BlocBuilder<SubtitleGeneratorBloc,
                          SubtitleGeneratorState>(
                        builder: (context, state) {
                          return Footer(
                            progress: state.progress,
                          );
                        },
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // Widget _footer(MPB.HomePageState state) {
  //   bool isSavingState = state.status.isSubmissionInProgress;
  //   return Container(
  //     height: 48,
  //     padding: const EdgeInsets.symmetric(horizontal: 16),
  //     color: ColorPalette.primaryColor,
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: <Widget>[
  //         Row(
  //           children: [
  //             Container(
  //               padding: const EdgeInsets.symmetric(vertical: 8),
  //               child: ListView.separated(
  //                 shrinkWrap: true,
  //                 itemBuilder: (context, index) {
  //                   if (index == 0) {
  //                     return GestureDetector(
  //                       child: Image.asset('resources/icon.png'),
  //                       onTap: () {
  //                         showDialog(
  //                           context: context,
  //                           builder: (context) {
  //                             return const AppAboutDialog();
  //                           },
  //                         );
  //                       },
  //                     );
  //                   }
  //                   if (index == 1) {
  //                     return GestureDetector(
  //                       child: const Icon(Icons.star, color: Colors.yellow),
  //                       onTap: () {
  //                         showDialog(
  //                           context: context,
  //                           builder: (context) {
  //                             return const CoffeeDialog();
  //                           },
  //                         );
  //                       },
  //                     );
  //                   }
  //                   return Container();
  //                 },
  //                 separatorBuilder: (context, index) {
  //                   return const SizedBox(
  //                     width: 8,
  //                   );
  //                 },
  //                 itemCount: 2,
  //                 scrollDirection: Axis.horizontal,
  //               ),
  //             ),
  //             const SizedBox(
  //               width: 8,
  //             ),
  //             Text(
  //               'Version: ${Version.number}',
  //             ),
  //           ],
  //         ),
  //         isSavingState
  //             ? SizedBox(
  //                 width: 160,
  //                 child: BlocBuilder<MPB.HomePageBloc, MPB.HomePageState>(
  //                   bloc: _bloc,
  //                   builder: (context, lpState) {
  //                     return LinearProgressIndicator(
  //                       backgroundColor: ColorPalette.secondaryColor,
  //                       valueColor: AlwaysStoppedAnimation<Color>(
  //                         ColorPalette.accentColor,
  //                       ),
  //                       value: lpState.currentFrame /
  //                           ((lpState.propertyText.texts!.length - 1) <= 0
  //                               ? 1
  //                               : (lpState.propertyText.texts!.length - 1)),
  //                     );
  //                   },
  //                 ),
  //               )
  //             : Container()
  //       ],
  //     ),
  //   );
  // }
  // Widget _canvasPanel(MPB.HomePageState state) {
  //   return Container(
  //     color: Colors.green,
  //     child: ClipRect(
  //       child: Column(
  //         children: <Widget>[
  //           // Subtitle Panel
  //           Expanded(
  //             child: Container(
  //               color: Colors.black,
  //               width: double.maxFinite,
  //               height: double.maxFinite,
  //               child: Container(
  //                 color: Colors.black,
  //                 child: SubtitlePanel(
  //                   painter: _painter,
  //                   pmoveController: _subtitlePanelMoveController,
  //                   pscrollController: _subtitlePanelScrollController,
  //                   canvasResolution: Size(
  //                     state.propertyCanvasResolutionX.toDouble(),
  //                     state.propertyCanvasResolutionY.toDouble(),
  //                   ),
  //                   span: TextSpan(
  //                     text:
  //                         '${state.propertyText.texts!.isNotEmpty ? state.propertyText.texts![state.currentFrame].text : ''}',
  //                     style: TextStyle(
  //                       fontFamily: state.propertyFontFamily,
  //                       color: state.propertyFontColor,
  //                       fontSize: state.propertyFontSize.toDouble(),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //           // Frame Panel
  //           Container(
  //             height: 48,
  //             padding:
  //                 const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
  //             decoration: BoxDecoration(
  //               color: ColorPalette.accentColor,
  //               borderRadius: BorderRadius.circular(4),
  //             ),
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.end,
  //               children: <Widget>[
  //                 Tooltip(
  //                   message: 'Previous Frame(F1)',
  //                   child: IconButton(
  //                     onPressed: () {
  //                       _bloc.add(MPB.PreviousFrameEvent());
  //                     },
  //                     color: f1Color,
  //                     icon: const Icon(
  //                       Icons.skip_previous_outlined,
  //                     ),
  //                   ),
  //                 ),
  //                 Tooltip(
  //                   message: 'Next Frame(F2)',
  //                   child: IconButton(
  //                     onPressed: () {
  //                       _bloc.add(MPB.NextFrameEvent());
  //                     },
  //                     color: f2Color,
  //                     icon: const Icon(
  //                       Icons.skip_next_outlined,
  //                     ),
  //                   ),
  //                 ),
  //                 Tooltip(
  //                   message: 'Reset Position',
  //                   child: IconButton(
  //                     onPressed: () {
  //                       _subtitlePanelMoveController.value = Offset.zero;
  //                     },
  //                     icon: const Icon(Icons.control_camera_outlined),
  //                   ),
  //                 ),
  //                 Tooltip(
  //                   message: 'Reset Scale',
  //                   child: IconButton(
  //                     onPressed: () {
  //                       _subtitlePanelScrollController.value = 0;
  //                     },
  //                     icon: const Icon(Icons.aspect_ratio_outlined),
  //                   ),
  //                 )
  //               ],
  //             ),
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
