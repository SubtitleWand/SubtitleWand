import 'package:flutter/material.dart';
import 'package:subtitle_wand/_gen/version.gen.dart';
import 'package:subtitle_wand/design/color_palette.dart';
import 'package:subtitle_wand/pages/app_page/pages/home_page/widgets/dialogs/app_about_dialog.dart';
import 'package:subtitle_wand/pages/app_page/pages/home_page/widgets/dialogs/coffee_dialog.dart';

class Footer extends StatelessWidget {
  const Footer({Key? key, this.progress = 0}) : super(key: key);
  final double progress;

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
              const Text(
                'Version: $packageVersion',
              ),
            ],
          ),
          if (progress != 0)
            SizedBox(
              width: 160,
              child: LinearProgressIndicator(
                backgroundColor: ColorPalette.secondaryColor,
                valueColor: AlwaysStoppedAnimation<Color>(
                  ColorPalette.accentColor,
                ),
                value: progress,
              ),
            )
        ],
      ),
    );
  }
}
