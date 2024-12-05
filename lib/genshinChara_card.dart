import 'package:digimon/genshinChara_model.dart';
import 'genshinChara_detail_page.dart';
import 'package:flutter/material.dart';

// degradados:
// 5S - da9814 50, 955d2c 100
// 4S - 9370b0 50, 514a75 100

class GenshinCharaCard extends StatefulWidget {
  final GenshinChara genshinChara;

  const GenshinCharaCard(this.genshinChara, {super.key});

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
    renderGenshinCharaPic();
  }

  Widget get genshinCharaImage {
    var genshinCharaAvatar = Hero(
      tag: genshinChara,
      child: Container(
        width: 100.0,
        height: 100.0,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
                fit: BoxFit.cover, image: NetworkImage(renderUrl ?? ''))),
      ),
    );

    var placeholder = Container(
      width: 100.0,
      height: 100.0,
      decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.black54,
                Colors.black,
                Color.fromARGB(255, 84, 110, 122)
              ])),
      alignment: Alignment.center,
      child: const Text(
        'Loading',
        textAlign: TextAlign.center,
      ),
    );

    var crossFade = AnimatedCrossFade(
      firstChild: placeholder,
      secondChild: genshinCharaAvatar,
      // ignore: unnecessary_null_comparison
      crossFadeState: renderUrl == null
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
      duration: const Duration(milliseconds: 1000),
    );

    return crossFade;
  }

  void renderGenshinCharaPic() async {
    await genshinChara.findData();
    if (mounted) {
      setState(() {
        renderUrl = genshinChara.iconURL;
      });
    }
  }

  showGenshinCharaDetailPage() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return GenshinCharaDetailPage(genshinChara);
    }));
  }

  String getRegionImageLink(String? region) {
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

  LinearGradient? getRarityGradient() {
    Color color1;
    Color color2;

    switch (genshinChara.rarity) {
      case ("5"):
        color1 = Color(0xFFDA9814);
        color2 = Color(0xFF955d2c);
        break;
      case("4"):
        color1 = Color(0xFF9370b0);
        color2 = Color(0xFF514a75);
        break;
      default:
        color1 = Color.fromARGB(255, 84, 110, 122);
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
    return InkWell(
        onTap: () => showGenshinCharaDetailPage(),
        child: Column(
          children: [
            SizedBox(
                height: 120,
                child: Stack(
                  children: [
                    Opacity(
                      opacity: 0.075,
                      child: Image(
                        image: NetworkImage(
                            getRegionImageLink(genshinChara.region)),
                        alignment: const Alignment(-1, 0),
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.none,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center ,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10),
                          child:
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration:
                                  BoxDecoration(gradient: getRarityGradient()),
                              //child: ,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ))
          ],
        ));
  }
}
