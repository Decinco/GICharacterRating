import 'package:digimon/genshinChara_model.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'genshinChara_list.dart';
import 'new_character_form.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Genshin Impact Characters',
      theme: ThemeData(brightness: Brightness.dark),
      home: const MyHomePage(
        title: 'Genshin Impact Characters',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({super.key, required this.title});

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();


}

class _MyHomePageState extends State<MyHomePage> {
  List<GenshinChara> initialCharacters = [
    GenshinChara('Eula'),
    GenshinChara('Baizhu'),
    GenshinChara('Yoimiya'),
    GenshinChara('Cyno'),
    GenshinChara('Navia'),
    GenshinChara('Kinich')
  ];

  Future _showNewCharacterForm() async {
    GenshinChara newCharacter = await Navigator.of(context).push(
        MaterialPageRoute(
            builder: (BuildContext context) =>
                AddCharacterFormPage(initialCharacters: initialCharacters)));
    //print(newDigimon);
    initialCharacters.add(newCharacter);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var key = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: key,
      appBar: AppBar(
        leading: IconButton(
            onPressed: _showNewCharacterForm,
            icon: const Icon(
              Icons.add,
              color: Color.fromARGB(255, 255, 255, 255),
              size: 30,
            )),
        title: const Text(
          "Genshin Impact Characters",
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Color(0xFF114A8C), Color(0xFF072E5D)], stops: [0, 0.75])
          ),
        ),

      ),
      body: Container(
          color: Colors.black,
          child: Center(
            child: GenshinCharaList(initialCharacters),
          )),
    );
  }
}
