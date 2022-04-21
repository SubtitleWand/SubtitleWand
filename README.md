<img src="./resources/icon.png" width="170" align="right">

# Subtitle Wand - An image-based subtitle generator that can be easily and rapidly integrated with any video editing program.

[![codecov](https://codecov.io/gh/SubtitleWand/SubtitleWand/branch/master/graph/badge.svg?token=DUE41G13YN)](https://codecov.io/gh/SubtitleWand/SubtitleWand)

[![build](https://img.shields.io/github/workflow/status/SubtitleWand/SubtitleWand/Main/master)](https://github.com/SubtitleWand/SubtitleWand/actions)

[![downloads](https://img.shields.io/github/downloads/SubtitleWand/SubtitleWand/total)](https://github.com/SubtitleWand/SubtitleWand/releases)


## About SubtitleWand

This is a universal solution for subtitle to video maker, such as Windows Movie Maker/Sony vegas/ Hitfilm. The motivation is that [Hitfilm](https://fxhome.com/hitfilm-express) do not have a proper way to add subtitle as fast as possible, and the workarounds, Multiple Compisite Shot, One Shot with line moving/masking, Subtitle plugin are fairly tricky and tired for me.

Subtitle Wand has two methods, one is to target on embedding whole subtitles splited by frame to optimize perfomance, and user could slow the duration to get fully controll on each subtitle. Another is to export video with SRT, required ffmpeg installed, tho.

## How to use

#### Image squence
[DEMO](https://www.youtube.com/watch?v=BeSdYeeK4QU)
1. Select a ttf to your subtitle.
2. Enter subtitles in **text**, one line per frame. (configue any property you want)
3. Save images and wait to complete. (generate a sequence of image, you could import It with any maker that supported **Image Sequence**)
4. Download the [AutoHotKey](https://www.autohotkey.com/) script in this repository's **macro_scripts** folder.
5. Import Image sequence in **Hitfilm**, and make slow the full shot to 0.5% duration (1 frame to 200 frame per subtitle), and drag It to timeline, you might move the position first before next step.
6. Lock all other layers excpet subtitle layer, Execute **200frameHitfilm.ahk** to slice automatically (**F3** to start, **Esc** to stop), If you are not using hitfilm, you should write It by hand, and If you think It's useful, welcome to feedback the script, issue or pull-request is welcome.
7. Enjoy your consistent and pre-generated subtitles, the last work is move It to correct timeline, no more.

#### SRT & Video export
[DEMO](https://youtu.be/HVXg0PPOl3Y)
1. Select a ttf.
2. Select a SRT.
3. Check If there is ffmpeg in enviroment variable, and export.
4. Enjoy life.

## How to open releases

### Windows

No need any extra knowledge.

### Linux (x64/Amd)

#### Option 1. Use `dpkg`

```
sudo dpkg -i linux_the_file.deb
/usr/local/lib/subtitle_wand/subtitle_wand
```

> Note: The Path you currently used in terminal will be the root directory for the app, please decide the directory, and use `cd`, then execute the last command above.

#### Option 2. Use `dpkg-deb`

`dpkg-deb -x $DEBFILE $TARGET_DIRECTORY`, then open _subtitle_wand_ in the target directory.
Don't forget to `chmod -R 755` the direcotry or use open mineraft_cube_desktop as `sudo`.

### Macos

```
chmod -R 755 subtitle_wand.app
```

and `open ./subtitle_wand


## Compile
Before you can compile Subtitle Wand, you must have following prerequisite:
1. [flutter](https://flutter.dev/docs/get-started/install) - Best cross-platform framework
~ 2. [go-flutter](https://github.com/go-flutter-desktop/go-flutter) embeddeder for desktop powered by golang ~

~ All prepared, you could use `hover run` to run the project. ~

## Contribute
Fork the project, and follow the [CONTRIBUTING.md](CONTRIBUTING.md).

## Support
If you like the project, leave ⭐️ for supporting the project ☺️

## Maintainers
- [Tokenyet](https://github.com/Tokenyet)

## Special Thanks
- [TzuyuLiu](https://github.com/TzuyuLiu) - Friend, for mac production testing
- [s19096](https://github.com/s19096) - Friend, for mac production testing and readme review.
