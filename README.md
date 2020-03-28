<img src="./icon.png" width="170" align="right">

# Subtitle Wand - An image-based subtitle generator that can be easily and rapidly integrated with any video editing program.

[![codecov](https://codecov.io/gh/Tokenyet/SubtitleWand/branch/master/graph/badge.svg?token=DUE41G13YN)](https://codecov.io/gh/Tokenyet/SubtitleWand)

[![build](https://github.com/SubtitleWand/SubtitleWand/workflows/build/badge.svg)](https://github.com/SubtitleWand/SubtitleWand/actions)


[![downloads](https://img.shields.io/github/downloads/SubtitleWand/SubtitleWand/latest/total)](https://github.com/SubtitleWand/SubtitleWand/releases)


## About SubtitleWand

This is a universal solution for subtitle to video maker, such as Windows Movie Maker/Sony vegas/ Hitfilm. The motivation is that [Hitfilm](https://fxhome.com/hitfilm-express) do not have a proper way to add subtitle as fast as possible, and the workarounds, Multiple Compisite Shot, One Shot with line moving/masking, Subtitle plugin are fairly tricky and tired for me.

Subtitle Wand is to target on embedding one subtitle per frame to optimize perfomance, and user could slow the duration to get fully controll on each subtitle.

## How to use
1. Select a ttf to your subtitle.
2. Enter subtitles in **text**, one line per frame. (configue any property you want)
3. Save images and wait to complete. (generate a sequence of image, you could import It with any maker that supported **Image Sequence**)
4. Download the [AutoHotKey](https://www.autohotkey.com/) script in this repository's **macro_scripts** folder.
5. Import Image sequence in **Hitfilm**, and make slow the full shot to 0.5% duration (1 frame to 200 frame per subtitle), and drag It to timeline, you might move the position first before next step.
6. Lock all other layers excpet subtitle layer, Execute **200frameHitfilm.ahk** to slice automatically (**F3** to start, **Esc** to stop), If you are not using hitfilm, you should write It by hand, and If you think It's useful, welcome to feedback the script, issue or pull-request is welcome.
7. Enjoy your consistent and pre-generated subtitles, the last work is move It to correct timeline, no more.

## Compile
Before you can compile Subtitle Wand, you must have following prerequisite:
1. [flutter](https://flutter.dev/docs/get-started/install) - Best cross-platform framework
2. [go-flutter](https://github.com/go-flutter-desktop/go-flutter) embeddeder for desktop powered by golang 

All prepared, you could use `hover run` to run the project.

## Contribute
Fork the project, and follow the [CONTRIBUTING.md](CONTRIBUTING.md).

## Support
If you want to support this project feel free to go [here](https://subtitlewand.github.io/donation).

## Maintainers
- [Tokenyet](https://github.com/Tokenyet)

## Special Thanks
- [TzuyuLiu](https://github.com/TzuyuLiu) - Friend, for mac production testing
- [s19096](https://github.com/s19096) - Friend, for mac production testing and readme review.