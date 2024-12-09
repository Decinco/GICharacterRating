import 'package:digimon/genshinChara_model.dart';
import 'package:flutter/material.dart';

enum GIPortraitStyle { colorful, colorless }

class GenshinCharaPortrait extends StatefulWidget {
  final GenshinChara genshinChara;
  final GIPortraitStyle style;

  const GenshinCharaPortrait(
      {super.key, required this.genshinChara, required this.style});

  @override
  State<GenshinCharaPortrait> createState() => _GenshinCharaPortraitState();
}

class _GenshinCharaPortraitState extends State<GenshinCharaPortrait> {
  late GenshinChara genshinChara;
  late GIPortraitStyle style;

  @override
  void initState() {
    super.initState();
  }

  LinearGradient? _elementGradient(){
    Color element;
    Color element2;

    switch (widget.genshinChara.element) {
      case ("Anemo"):
        element = const Color.fromARGB(255, 26, 201, 148);
        element2 = const Color.fromARGB(200, 26, 201, 148);
        break;
      case ("Geo"):
        element = const Color.fromARGB(255, 235, 201, 12);
        element2 = const Color.fromARGB(200, 235, 201, 12);
        break;
      case ("Electro"):
        element = const Color.fromARGB(255, 181, 44, 223);
        element2 = const Color.fromARGB(200, 181, 44, 223);
        break;
      case ("Dendro"):
        element = const Color.fromARGB(255, 58, 201, 54);
        element2 = const Color.fromARGB(200, 58, 201, 54);
        break;
      case ("Hydro"):
        element = const Color.fromARGB(255, 23, 153, 204);
        element2 = const Color.fromARGB(200, 23, 153, 204);
        break;
      case ("Pyro"):
        element = const Color.fromARGB(255, 219, 84, 21);
        element2 = const Color.fromARGB(200, 219, 84, 21);
        break;
      case ("Cryo"):
        element = const Color.fromARGB(255, 12, 228, 228);
        element2 = const Color.fromARGB(200, 12, 228, 228);
        break;
      default:
        element = const Color.fromARGB(255, 84, 110, 122);
        element2 = const Color.fromARGB(200, 84, 110, 122);
        break;
      }

      return LinearGradient(
        colors: [element, element2],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter);
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

    if (style == GIPortraitStyle.colorless) {
      color1 = Colors.black;
      color2 = Colors.black;
    }

    return LinearGradient(
        colors: [color1, color2],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter);
  }

  @override
  Widget build(BuildContext context) {
    genshinChara = widget.genshinChara;
    style = widget.style;

    double colorlessOpacity;

    if (style == GIPortraitStyle.colorful) {
      colorlessOpacity = 0;
    } else {
      colorlessOpacity = 1;
    }

    return Hero(
        tag: genshinChara,
        child: Stack(
          alignment: const Alignment(0, 0),
          children: [
            Opacity(
                opacity: colorlessOpacity,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 84,
                      height: 84,
                      decoration: BoxDecoration(gradient: _elementGradient()),
                    ))),
            Opacity(
                opacity: 1,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(gradient: _rarityGradient()),
                    ))),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image(
                  width: 80,
                  height: 80,
                  image: NetworkImage(genshinChara.iconURL ??
                      "https://gi.yatta.moe/assets/UI/chapter/UI_ChapterIcon_Common.png?vh=2024111801")),
            )
          ],
        ));
  }
}
