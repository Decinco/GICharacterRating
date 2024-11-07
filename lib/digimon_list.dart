import 'package:digimon/digimon_card.dart';
import 'package:flutter/material.dart';
import 'digimon_model.dart';

class DigimonList extends StatelessWidget {
  final List<Digimon> digimons;
  const DigimonList(this.digimons, {super.key});

  @override
  Widget build(BuildContext context) {
    return _buildList(context);
  }

  ListView _buildList(context) {
    return ListView.builder(
      itemCount: digimons.length,
      // ignore: avoid_types_as_parameter_names
      itemBuilder: (context, int) {
        return DigimonCard(digimons[int]);
      },
    );
  }
}
