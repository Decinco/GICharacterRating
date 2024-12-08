import 'package:digimon/a_v_icons_icons.dart';
import 'package:digimon/genshinChara_model.dart';
import 'package:digimon/genshinChara_portrait.dart';
import 'genshinChara_detail_page.dart';
import 'package:flutter/material.dart';

// degradados:
// 5S - da9814 50, 955d2c 100
// 4S - 9370b0 50, 514a75 100

enum GICardStyles { list, large }

class GenshinCharaCard extends StatefulWidget {
  final GenshinChara genshinChara;
  final GICardStyles styleType;

  const GenshinCharaCard(this.genshinChara, this.styleType, {super.key});

  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _GenshinCharaCardState createState() => _GenshinCharaCardState(genshinChara);
}

class _GenshinCharaCardState extends State<GenshinCharaCard> {
  GenshinChara genshinChara;
  String? renderUrl;

  _GenshinCharaCardState(this.genshinChara);

  @override
  void initState() {
    super.initState();
  }

  void reload() async {
    await genshinChara.findData();
    if (mounted) {
      setState(() {});
    }
  }

  showGenshinCharaDetailPage() {
    if (widget.styleType == GICardStyles.list){
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return GenshinCharaDetailPage(genshinChara);
    }));}
  }

  String _regionImageLink(String? region) {
    String regionCode;

    switch (region) {
      case "Mondstadt":
        regionCode = "1";
        break;
      case "Liyue":
        regionCode = "2";
        break;
      case "Inazuma":
        regionCode = "3";
        break;
      case "Sumeru":
        regionCode = "4";
        break;
      case "Fontaine":
        regionCode = "5";
        break;
      case "Natlan":
        regionCode = "6";
        break;
      default:
        regionCode = "-1";
        break;
    }

    if (regionCode != "-1") {
      return "https://homdgcat.wiki/images/Cities/$regionCode.png";
    } else {
      return "https://gi.yatta.moe/assets/UI/chapter/UI_ChapterIcon_Common.png?vh=2024111801";
    }
  }

  Widget _characterName() {
    Color color1;
    Color color2;
    Color? textColor;

    switch (genshinChara.element) {
      case ("Anemo"):
        color1 = const Color.fromARGB(255, 26, 201, 148);
        color2 = const Color.fromARGB(255, 16, 88, 88);
        textColor = Colors.black;
        break;
      case ("Geo"):
        color1 = const Color.fromARGB(255, 235, 201, 12);
        color2 = const Color.fromARGB(255, 83, 60, 16);
        textColor = Colors.black;
        break;
      case ("Electro"):
        color1 = const Color.fromARGB(255, 181, 44, 223);
        color2 = const Color.fromARGB(255, 29, 19, 78);
        textColor = Colors.black;
        break;
      case ("Dendro"):
        color1 = const Color.fromARGB(255, 58, 201, 54);
        color2 = const Color.fromARGB(255, 17, 71, 22);
        textColor = Colors.black;
        break;
      case ("Hydro"):
        color1 = const Color.fromARGB(255, 23, 153, 204);
        color2 = const Color.fromARGB(255, 11, 10, 71);
        textColor = Colors.black;
        break;
      case ("Pyro"):
        color1 = const Color.fromARGB(255, 219, 84, 21);
        color2 = const Color.fromARGB(255, 63, 14, 8);
        textColor = Colors.black;
        break;
      case ("Cryo"):
        color1 = const Color.fromARGB(255, 12, 228, 228);
        color2 = const Color.fromARGB(255, 23, 57, 80);
        textColor = Colors.black;
        break;
      default:
        color1 = const Color.fromARGB(255, 84, 110, 122);
        color2 = Colors.black54;
        break;
    }

    return Container(
        width: double.infinity,
        height: 25,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [color1, color2],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          child: Text(
            genshinChara.name,
            style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
          ),
        ));
  }

  Widget _additionalDetail() {
    Widget returnedWidget;

    if (widget.styleType == GICardStyles.list) {
      returnedWidget = Align(
        alignment: const AlignmentDirectional(1, 0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "${genshinChara.rating}/10",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const Icon(AVIcons.fourStar)
          ],
        ),
      );
    } else {
      returnedWidget = const Align(
        alignment: AlignmentDirectional(1, 0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(right: 5),
              child: Text(
                "Brand New!",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      );
    }

    return returnedWidget;
  }

  @override
  Widget build(BuildContext context) {
    reload();

    double lineVisibility;
    double imageHeight;
    Alignment imageAlignment;

    if (widget.styleType == GICardStyles.list) {
      imageHeight = 120;
      lineVisibility = 0.2;
      imageAlignment = const Alignment(-1, 0);
    } else {
      imageHeight = 240;
      lineVisibility = 0;
      imageAlignment = const Alignment(0, 0);
    }

    return InkWell(
        onTap: () => showGenshinCharaDetailPage(),
        child: Column(
          children: [
            SizedBox(
                height: imageHeight,
                width: double.infinity,
                child: Stack(
                  alignment: imageAlignment,
                  children: [
                    Opacity(
                      opacity: 0.075,
                      child: Image(
                        image:
                            NetworkImage(_regionImageLink(genshinChara.region)),
                        alignment: imageAlignment,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.none,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                            padding: const EdgeInsets.all(10),
                            child: GenshinCharaPortrait(genshinChara: genshinChara,)), // Classe que dibuja el icono frontal del personaje
                        Flexible(
                            child: Align(
                          alignment: const AlignmentDirectional(-1, 0),
                          child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(children: [
                                    _characterName(),
                                    _additionalDetail(),
                                  ]),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child:
                                        Text(genshinChara.weapon ?? "No Info"),
                                  )
                                ],
                              )),
                        ))
                      ],
                    )
                  ],
                )),
            Opacity(
              opacity: lineVisibility,
              child: const Divider(
                thickness: 2,
                height: 2,
              ),
            )
          ],
        ));
  }
}
