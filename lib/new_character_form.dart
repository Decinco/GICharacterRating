import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:digimon/genshinChara_card.dart';
import 'package:digimon/genshinChara_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
import 'package:json_path/json_path.dart';

class AddCharacterFormPage extends StatefulWidget {
  final initialCharacters;

  const AddCharacterFormPage({super.key, this.initialCharacters});

  @override
  // ignore: library_private_types_in_public_api
  _AddCharacterFormPageState createState() => _AddCharacterFormPageState();
}

class _AddCharacterFormPageState extends State<AddCharacterFormPage> {
  TextEditingController nameController = TextEditingController();
  final _formKey = GlobalKey<FormBuilderState>();
  Future<List<String>>? characters;
  GenshinChara selectedCharacterModel = GenshinChara("N/A");

  @override
  void initState() {
    super.initState();

    characters = findAllUnusedCharacters();
  }

  void submitChar(BuildContext context) {
    if (_formKey.currentState!.saveAndValidate()) {
      Navigator.of(context).pop(selectedCharacterModel);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Color.fromRGBO(209, 32, 32, 1),
        content: Text(
          'That character doesn\'t exist!',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ));
    }
  }

  void selectChar() {
    if (_formKey.currentState!.saveAndValidate()) {
      setState(() {
        selectedCharacterModel.name =
            _formKey.currentState!.value['selectedChar'];
        selectedCharacterModel.findData();
      });
    }
  }

  Future<List<String>> findAllUnusedCharacters() async {
    HttpClient http = HttpClient();

    var uri = Uri.https('gi.yatta.moe', '/api/v2/en/avatar');
    var request = await http.getUrl(uri);
    var response = await request.close();
    var responseBody = await response.transform(utf8.decoder).join();

    Map<String, dynamic> data = json.decode(responseBody);
    var jPath = r"$.data.items.*.name";
    final characterNames = JsonPath(jPath);

    List<String> availableCharacters = [];
    var alreadyAddedCharacters = [];

    for (GenshinChara character in widget.initialCharacters) {
      alreadyAddedCharacters.add(character.name);
    }

    for (Object? name in characterNames.readValues(data)) {
      if (!alreadyAddedCharacters.contains(name) && name != "Traveler") {
        availableCharacters.add(name.toString());
      }
    }

    return availableCharacters;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Add New Character",
            style: TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xFF114A8C), Color(0xFF072E5D)],
                    stops: [0, 0.75])),
          ),
        ),
        body: Container(
          color: const Color.fromARGB(255, 0, 0, 0),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 32.0),
            child: FormBuilder(
              key: _formKey,
              child: Column(children: [
                Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: FutureBuilder<List<String>>(
                        future: characters,
                        builder: (BuildContext context,
                            AsyncSnapshot<List<String>> snapshot) {
                          if (!snapshot.hasData) {
                            // while data is loading:
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            final characters = snapshot.data;
                            return FormBuilderTypeAhead<String>(
                                name: 'selectedChar',
                                decoration: const InputDecoration(
                                    label: Text("Enter your character"),
                                    focusColor: Color(0xFF114A8C),
                                    hoverColor: Color(0xFF114A8C)),
                                itemBuilder: (context, character) {
                                  return ListTile(title: Text(character));
                                },
                                onChanged: (val) {
                                  selectChar(); // Selecciona el personaje en su tarjeta
                                },
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.containsElement(
                                      characters!,
                                      errorText: "Invalid character!")
                                ]),
                                suggestionsCallback: (query) {
                                  if (query.isNotEmpty) {
                                    var lowerCase = query.toLowerCase();
                                    return characters.where((character) {
                                      return character
                                          .toLowerCase()
                                          .contains(lowerCase);
                                    }).toList();
                                  } else {
                                    return characters;
                                  }
                                });
                          }
                        })),
                Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: GenshinCharaCard(
                        selectedCharacterModel, GICardStyles.large)),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Builder(
                    builder: (context) {
                      return ElevatedButton(
                        onPressed: () => submitChar(context),
                        style: const ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll<Color>(
                                Color(0xFF114A8C)),
                            foregroundColor:
                                WidgetStatePropertyAll<Color>(Colors.white)),
                        child: const Text('Submit Character'),
                      );
                    },
                  ),
                )
              ]),
            ),
          ),
        ));
  }
}
