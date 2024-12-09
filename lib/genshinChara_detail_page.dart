import 'package:digimon/a_v_icons_icons.dart';
import 'package:digimon/genshinChara_portrait.dart';
import 'package:flutter/material.dart';
import 'genshinChara_model.dart';
import 'dart:async';

class GenshinCharaDetailPage extends StatefulWidget {
  final GenshinChara genshinChara;
  const GenshinCharaDetailPage(this.genshinChara, {super.key});

  @override
  // ignore: library_private_types_in_public_api
  _GenshinCharaDetailPageState createState() => _GenshinCharaDetailPageState();
}

class _GenshinCharaDetailPageState extends State<GenshinCharaDetailPage> {
  late double _sliderValue;

  @override
  void initState() {
    super.initState();

    _sliderValue = widget.genshinChara.rating.toDouble();
  }

  Widget get addYourRating {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                flex: 1,
                child: Slider(
                  divisions: 10,
                  activeColor: _elementColor,
                  min: 0.0,
                  max: 10.0,
                  value: _sliderValue,
                  onChanged: (newRating) {
                    setState(() {
                      _sliderValue = newRating;
                    });
                  },
                ),
              ),
              Container(
                  width: 50.0,
                  alignment: Alignment.center,
                  child: Text(
                    '${_sliderValue.toInt()}',
                    style: const TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 25.0),
                  )),
            ],
          ),
        ),
        submitRatingButton,
      ],
    );
  }

  void updateRating() {
    if (_sliderValue < 5) {
      _ratingErrorDialog();
    } else {
      setState(() {
        widget.genshinChara.rating = _sliderValue.toInt();
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        duration: Duration(seconds: 1),
        backgroundColor: Color(0xFF114A8C),
        content: Text(
          'Updated!',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ));
    }
  }

  Future<void> _ratingErrorDialog() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Oh no!'),
            content: const Text("You have no taste :("),
            actions: <Widget>[
              TextButton(
                child: Text('Try Again',
                    style: TextStyle(
                      color: _elementColor,
                    )),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        });
  }

  Widget get submitRatingButton {
    return ElevatedButton(
      onPressed: () => updateRating(),
      style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll<Color>(_elementColor),
          foregroundColor: const WidgetStatePropertyAll<Color>(Colors.white)),
      child: const Text('Submit'),
    );
  }

  Widget get rating {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Icon(
          AVIcons.fourStar,
          size: 40.0,
          color: Color.fromARGB(255, 255, 255, 255),
        ),
        Text('${widget.genshinChara.rating}/10',
            style: const TextStyle(
                color: Color.fromARGB(255, 255, 255, 255), fontSize: 30.0))
      ],
    );
  }

  AppBar get _elementalAppBar {
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

    return AppBar(
      title: Text(
        widget.genshinChara.name,
        style: const TextStyle(
          color: Color.fromARGB(255, 255, 255, 255),
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      flexibleSpace: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [element, element2],
                stops: const [0, 1])),
      ),
    );
  }

  Color get _elementColor {
    Color element;

    switch (widget.genshinChara.element) {
      case ("Anemo"):
        element = const Color.fromARGB(255, 26, 201, 148);
        break;
      case ("Geo"):
        element = const Color.fromARGB(255, 235, 201, 12);
        break;
      case ("Electro"):
        element = const Color.fromARGB(255, 181, 44, 223);
        break;
      case ("Dendro"):
        element = const Color.fromARGB(255, 58, 201, 54);
        break;
      case ("Hydro"):
        element = const Color.fromARGB(255, 23, 153, 204);
        break;
      case ("Pyro"):
        element = const Color.fromARGB(255, 219, 84, 21);
        break;
      case ("Cryo"):
        element = const Color.fromARGB(255, 12, 228, 228);
        break;
      default:
        element = const Color.fromARGB(255, 84, 110, 122);
        break;
    }

    return element;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      appBar: _elementalAppBar,
      body: Stack(
        children: [
          Opacity(
              opacity: 0.5,
              child: Image(
                  height: double.infinity,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  image: NetworkImage(widget.genshinChara.fullArtURL ??
                      "https://gi.yatta.moe/assets/UI/chapter/UI_ChapterIcon_Common.png?vh=2024111801"))),
          Opacity(
              opacity: 0.8,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 100, 20, 0),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    color: Colors.black,
                  ),
                ),
              )),
          Padding(
              padding: const EdgeInsets.fromLTRB(20, 100, 20, 0),
              child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                  child: SizedBox(
                      height: double.infinity,
                      width: double.infinity,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 5),
                              child: GenshinCharaPortrait(
                                  genshinChara: widget.genshinChara,
                                  style: GIPortraitStyle.colorless),
                            ),
                            Text(
                              widget.genshinChara.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                color: _elementColor,
                              ),
                            ),
                            Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: Text(
                                  "\"${widget.genshinChara.description}\"",
                                  style: const TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                )),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  child: Icon(Icons.house),
                                ),
                                const Text(
                                  "Region",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  child: Text(
                                    widget.genshinChara.region ?? "No Info",
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  child: Icon(Icons.ac_unit),
                                ),
                                const Text(
                                  "Element",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  child: Text(
                                    widget.genshinChara.element ?? "No Info",
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  child: Icon(Icons.auto_fix_high_sharp),
                                ),
                                const Text(
                                  "Weapon",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  child: Text(
                                    widget.genshinChara.weapon ?? "No Info",
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                            addYourRating
                          ],
                        ),
                      ))))
        ],
      ),
    );
  }
}
