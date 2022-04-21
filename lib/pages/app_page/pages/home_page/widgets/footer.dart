import 'package:app_updater_repository/app_updater_repository.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launcher_repository/launcher_repository.dart';
import 'package:subtitle_wand/_gen/version.gen.dart';
import 'package:subtitle_wand/design/color_palette.dart';
import 'package:subtitle_wand/pages/app_page/pages/home_page/bloc/app_updater_bloc.dart';
import 'package:subtitle_wand/pages/app_page/pages/home_page/widgets/dialogs/app_about_dialog.dart';
import 'package:subtitle_wand/pages/app_page/pages/home_page/widgets/dialogs/coffee_dialog.dart';

class Footer extends StatelessWidget {
  const Footer({Key? key, this.progress = 0}) : super(key: key);
  final double progress;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppUpdaterBloc(
        appUpdaterRepository: context.read<AppUpdaterRepository>(),
      ),
      child: FooterView(
        progress: progress,
      ),
    );
  }
}

class FooterView extends StatefulWidget {
  const FooterView({Key? key, this.progress = 0}) : super(key: key);
  final double progress;

  @override
  State<FooterView> createState() => _FooterViewState();
}

class _FooterViewState extends State<FooterView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: ColorPalette.primaryColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return GestureDetector(
                        child: Image.asset('resources/icon.png'),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return const AppAboutDialog();
                            },
                          );
                        },
                      );
                    }
                    if (index == 1) {
                      return GestureDetector(
                        child: const Icon(Icons.star, color: Colors.yellow),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return const CoffeeDialog();
                            },
                          );
                        },
                      );
                    }
                    return Container();
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      width: 8,
                    );
                  },
                  itemCount: 2,
                  scrollDirection: Axis.horizontal,
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              BlocBuilder<AppUpdaterBloc, AppUpdaterState>(
                builder: (context, state) {
                  return Badge(
                    alignment: Alignment.topLeft,
                    badgeContent: const Text(
                      'new',
                      style: TextStyle(color: Colors.redAccent),
                    ),
                    elevation: 0,
                    badgeColor: Colors.transparent,
                    padding: EdgeInsets.zero,
                    position: BadgePosition.topEnd(end: -5, top: -15),
                    shape: BadgeShape.square,
                    borderRadius: BorderRadius.circular(8),
                    showBadge: state.hasGreaterVersion,
                    child: InkWell(
                      child: const Text(
                        'Version: $packageVersion',
                      ),
                      onTap: () {
                        context.read<LauncherRepository>().launch(
                              path:
                                  'https://github.com/SubtitleWand/SubtitleWand',
                            );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
          if (widget.progress != 0)
            SizedBox(
              width: 160,
              child: LinearProgressIndicator(
                backgroundColor: ColorPalette.secondaryColor,
                valueColor: AlwaysStoppedAnimation<Color>(
                  ColorPalette.accentColor,
                ),
                value: widget.progress,
              ),
            )
        ],
      ),
    );
  }
}
