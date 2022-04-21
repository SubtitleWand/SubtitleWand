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

import 'package:app_updater_repository/app_updater_repository.dart';
import 'package:ffmpeg_repository/ffmpeg_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_repository/font_repository.dart';
import 'package:image_repository/image_repository.dart';
import 'package:launcher_repository/launcher_repository.dart';
import 'package:srt_repository/srt_repository.dart';
import 'package:subtitle_wand/design/color_palette.dart';
import 'package:subtitle_wand/pages/app_page/pages/home_page/home_page.dart';
import 'package:window_size/window_size.dart' as appWindow;

class SubtitleWandApp extends StatelessWidget {
  const SubtitleWandApp({
    Key? key,
    required this.ffmpegRepo,
    required this.fontRepo,
    required this.launcherRepo,
    required this.srtRepo,
    required this.imageRepo,
    required this.appUpdaterRepo,
  }) : super(key: key);
  final FFmpegRepository ffmpegRepo;
  final FontRepository fontRepo;
  final LauncherRepository launcherRepo;
  final SrtRepository srtRepo;
  final ImageRepository imageRepo;
  final AppUpdaterRepository appUpdaterRepo;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: ffmpegRepo),
        RepositoryProvider.value(value: fontRepo),
        RepositoryProvider.value(value: launcherRepo),
        RepositoryProvider.value(value: srtRepo),
        RepositoryProvider.value(value: imageRepo),
        RepositoryProvider.value(value: appUpdaterRepo),
      ],
      child: const SubtitleWandAppView(),
    );
  }
}

class SubtitleWandAppView extends StatefulWidget {
  const SubtitleWandAppView({Key? key}) : super(key: key);

  @override
  State<SubtitleWandAppView> createState() => _SubtitleWandAppViewState();
}

class _SubtitleWandAppViewState extends State<SubtitleWandAppView> {
  @override
  void initState() {
    appWindow.setWindowTitle('SubtitleWand');
    super.initState();
  }

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
          headline6: TextStyle(
            color: ColorPalette.fontColor,
          ),
          subtitle2: TextStyle(
            color: ColorPalette.fontColor,
          ),
          subtitle1: TextStyle(
            color: ColorPalette.fontColor,
          ),
          caption: TextStyle(
            color: ColorPalette.fontColor,
          ),
        ),
      ),
      home:
          const HomePage(), // HomePage(),//MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
