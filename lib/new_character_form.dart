import 'dart:convert';
import 'dart:io';
import 'dart:async';

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
  var _formKey = GlobalKey<FormBuilderState>();
  Future<List<String>>? characters;

  @override
  void initState() {
    super.initState();

    characters = findAllUnusedCharacters();
  }



  void submitPup(BuildContext context) {
    if (_formKey.currentState!.saveAndValidate()) {
      var newCharacter = GenshinChara(_formKey.currentState!.value['selectedChar']);
      Navigator.of(context).pop(newCharacter);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text('That character doesn\'t exist!'),
      ));
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

    print(availableCharacters);

    return availableCharacters;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: const Text('Add a new character'),
          backgroundColor: const Color(0xFF0B479E),
        ),
        body: Container(
          color: const Color(0xFFABCAED),
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
                        builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
                          if (!snapshot.hasData) {
                            // while data is loading:
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            final characters = snapshot.data;
                            return FormBuilderTypeAhead<String>(
                                name: 'selectedChar',
                                decoration:
                                const InputDecoration(
                                    label: Text("Enter your character")),
                                itemBuilder: (context, character) {
                                  return ListTile(title: Text(character));
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
                  padding: const EdgeInsets.all(16.0),
                  child: Builder(
                    builder: (context) {
                      return ElevatedButton(
                        onPressed: () => submitPup(context),
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
