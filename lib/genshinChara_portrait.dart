import 'package:digimon/genshinChara_model.dart';
import 'package:flutter/material.dart';

class GenshinCharaPortrait extends StatefulWidget {
  final GenshinChara genshinChara;

  const GenshinCharaPortrait({super.key, required this.genshinChara});

  @override
  State<GenshinCharaPortrait> createState() => _GenshinCharaPortraitState();
}

class _GenshinCharaPortraitState extends State<GenshinCharaPortrait> {
  late GenshinChara genshinChara;

  @override
  void initState() {
    super.initState();
  }

  LinearGradient? _rarityGradient() {
    Color color1;
    Color color2;

    switch (genshinChara.rarity) {
      case ("5"):
        color1 = const Color(0xFFDA9814);
        color2 = const Color(0xFF955d2c);
        break;
      case ("4"):
        color1 = const Color(0xFF9370b0);
        color2 = const Color(0xFF514a75);
        break;
      default:
        color1 = const Color.fromARGB(255, 84, 110, 122);
        color2 = Colors.black54;
        break;
    }

    return LinearGradient(
        colors: [color1, color2],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter);
  }

  @override
  Widget build(BuildContext context) {
    genshinChara = widget.genshinChara;

    return Hero(
        tag: genshinChara,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(gradient: _rarityGradient()),
              child: Image(
                  image: NetworkImage(genshinChara.iconURL ??
                      "https://gi.yatta.moe/assets/UI/chapter/UI_ChapterIcon_Common.png?vh=2024111801"))),
        ));
  }
}