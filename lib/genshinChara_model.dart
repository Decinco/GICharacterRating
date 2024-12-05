import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:json_path/json_path.dart'; // Búsqueda avanzada dentro de un JSON, similar a XPath

enum WeaponType {
  WEAPON_SWORD_ONE_HAND("Sword"),
  WEAPON_POLE("Polearm"),
  WEAPON_CLAYMORE("Claymore"),
  WEAPON_BOW("Bow"),
  WEAPON_CATALYST("Catalyst");

  const WeaponType(this.display);

  final String display;
}

enum Region {
  MONDSTADT("Mondstadt"),
  LIYUE("Liyue"),
  INAZUMA("Inazuma"),
  SUMERU("Sumeru"),
  FONTAINE("Fontaine"),
  NATLAN("Natlan"),
  SNEZHNAYA("Snezhnaya"),
  FATUI("Snezhnaya"),
  MAINACTOR("Outlander"),
  RANGER("Outlander");

  const Region(this.display);

  final String display;
}

enum CharElement {
  Wind("Anemo"),
  Rock("Geo"),
  Electric("Electro"),
  Grass("Dendro"),
  Water("Hydro"),
  Fire("Pyro"),
  Ice("Cryo");

  const CharElement(this.display);

  final String display;
}


class GenshinChara {
  final String name;

  String? weapon;
  String? region;
  String? element;
  String? rarity;

  String? description;

  String? iconURL;
  String? fullArtURL;
  
  var icon;
  var fullArt;

  var internalMediaName;

  int rating = 10;

  GenshinChara(this.name);

  Future findData() async {
    HttpClient http = HttpClient();

    try {
      var id = await findID();

      var uri = Uri.https('gi.yatta.moe', '/api/v2/en/avatar/$id');
      var request = await http.getUrl(uri);
      var response = await request.close();
      var responseBody = await response.transform(utf8.decoder).join();

      RegExp regex = RegExp('UI_AvatarIcon_(.*)');

      Map<String, dynamic> data = json.decode(responseBody);

      print("a");

      weapon = WeaponType.values.byName(data["data"]["weaponType"]).display;
      region = Region.values.byName(data["data"]["region"]).display;
      element = CharElement.values.byName(data["data"]["element"]).display;
      rarity = data["data"]["rank"].toString();

      description = data["data"]["fetter"]["detail"];

      String mediaPath = data["data"]["icon"];
      internalMediaName = mediaPath.replaceFirstMapped(regex, (match) {
          return '${match.group(1)}';
      });

      iconURL = Uri.https('gi.yatta.moe', '/assets/UI/UI_AvatarIcon_$internalMediaName.png').toString();
      fullArtURL = Uri.https('gi.yatta.moe', '/assets/UI/UI_Gacha_AvatarImg_$internalMediaName.png').toString();

      //print(levelDigimon);
    } catch (exception) {
      print(exception);
    }
  }

  Future findID() async {
    HttpClient http = HttpClient();

    // Encuentra la id del personaje
    try {
      var uri = Uri.https('gi.yatta.moe', '/api/v2/en/avatar');
      var request = await http.getUrl(uri);
      var response = await request.close();
      var responseBody = await response.transform(utf8.decoder).join();

      Map<String, dynamic> data = json.decode(responseBody);
      var jPath = r"$.data.items[?@.name=='" + name + r"'].id";
      JsonPath responseProcessor = JsonPath(jPath);
      var charID = responseProcessor.readValues(data).toList()[0];

      return charID;

      //print(levelDigimon);
    } catch (exception) {
      print(exception);
    }
  }
}
