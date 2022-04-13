import 'package:flutter/material.dart';
import 'package:subtitle_wand/design/color_palette.dart';

class Header extends StatelessWidget {
  const Header({Key? key, this.onSaveImage, this.onSaveVideo})
      : super(key: key);
  final VoidCallback? onSaveImage;
  final VoidCallback? onSaveVideo;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorPalette.primaryColor,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 64,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Subtitle wand',
            style: Theme.of(context).textTheme.headline6,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              MaterialButton(
                color: ColorPalette.secondaryColor,
                textColor: ColorPalette.fontColor,
                disabledColor: ColorPalette.accentColor,
                child: Row(
                  children: const [
                    Icon(Icons.save_alt),
                    Text('Save Video'),
                  ],
                ),
                onPressed: onSaveVideo,
              ),
              const SizedBox(
                width: 8,
              ),
              MaterialButton(
                color: ColorPalette.secondaryColor,
                textColor: ColorPalette.fontColor,
                disabledColor: ColorPalette.accentColor,
                child: Row(
                  children: const [
                    Icon(Icons.save_alt),
                    Text('Save Image'),
                  ],
                ),
                onPressed: onSaveImage,
              )
            ],
          )
        ],
      ),
    );
  }
}
