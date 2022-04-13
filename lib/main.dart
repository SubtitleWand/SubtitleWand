import 'package:desktop_window/desktop_window.dart';
import 'package:ffmpeg_repository/ffmpeg_repository.dart';
import 'package:file/local.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:font_repository/font_repository.dart';
import 'package:image_repository/image_repository.dart';
import 'package:launcher_repository/launcher_repository.dart';
import 'package:process/process.dart';
import 'package:srt_repository/srt_repository.dart';
// import 'package:flutter/rendering.dart';
import 'package:subtitle_wand/pages/app_page/app_page.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

void main() async {
  // debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  // debugPaintSizeEnabled = true;
  // await LoggerUtil.getInstance().configure(
  //   level: kReleaseMode ? LoggerLevel.production : LoggerLevel.debug,
  // );

  const fileSystem = LocalFileSystem();
  const processManager = LocalProcessManager();
  final picker = FilePicker.platform;

  final ffmpegRepo =
      FFmpegRepository(fileSystem: fileSystem, processManager: processManager);
  final fontRepo = FontRepository(fileSystem: fileSystem, picker: picker);
  const launcherRepo = LauncherRepository(launcher.canLaunch, launcher.launch);
  final srtRepo = SrtRepository(fileSystem: fileSystem, picker: picker);
  final imageRepo = ImageRepository(fileSystem: fileSystem);

  runApp(
    SubtitleWandApp(
      ffmpegRepo: ffmpegRepo,
      fontRepo: fontRepo,
      launcherRepo: launcherRepo,
      srtRepo: srtRepo,
      imageRepo: imageRepo,
    ),
  );

  await DesktopWindow.setWindowSize(const Size(1400, 900));
  await DesktopWindow.setMinWindowSize(const Size(1280, 720));
  await DesktopWindow.setMaxWindowSize(const Size(1920, 1080));
}
