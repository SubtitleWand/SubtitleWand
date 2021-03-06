import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:subtitle_wand/design/color_palette.dart';
import 'package:url_launcher/url_launcher.dart';

class CoffeeDialog extends StatelessWidget {
  const CoffeeDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextStyle contentStyle = Theme.of(context).textTheme.headline6.copyWith(color: ColorPalette.fontColor,);
    return Dialog(
      backgroundColor: ColorPalette.secondaryColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.only(left: 16, right: 16, top: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star, color: Colors.yellow),
                SizedBox(width: 8),
                Text('Support', style: Theme.of(context).textTheme.headline5.copyWith(color: Colors.yellow),)
              ],
            )
          ),
          Container(
            padding: EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 4),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: contentStyle,
                children: [
                  TextSpan(text: 'Leave a  '),
                  WidgetSpan(child: Icon(Icons.star, color: Colors.yellow),),
                  TextSpan(text: ' '),
                  TextSpan(text: 'here', style: TextStyle(decoration: TextDecoration.underline), recognizer: TapGestureRecognizer()..onTap = () async {
                    final url = 'https://github.com/SubtitleWand/SubtitleWand';
                    if(await canLaunch(url)) {
                      await launch(url);
                    }
                  }),
                  TextSpan(text: ', is a good support for the project '),
                  WidgetSpan(child: Icon(Icons.sentiment_satisfied, color: Colors.yellow,)),
                  TextSpan(text: '.\n\nOr '),
                  TextSpan(text: 'Click '),
                  WidgetSpan(
                    child: GestureDetector(
                      child: FaIcon(FontAwesomeIcons.coffee, color: Colors.brown,),
                      onTap: () async {
                        final url = 'https://subtitlewand.github.io/donation';
                        if(await canLaunch(url)) {
                          await launch(url);
                        }
                      },
                    )
                  ),
                  TextSpan(text: ' to support the project :D\n\n'),
                  TextSpan(text: '(Support paypal, ecpay)', style: TextStyle(fontSize: 12)),
                ]
              )
            )
          )
        ],
      ),
    );
  }
}