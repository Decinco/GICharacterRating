import 'package:digimon/genshinChara_card.dart';
import 'package:digimon/genshinChara_model.dart';
import 'package:flutter/material.dart';

class GenshinCharaList extends StatelessWidget {
  final List<GenshinChara> characters;
  const GenshinCharaList(this.characters, {super.key});

  @override
  Widget build(BuildContext context) {
    return _buildList(context);
  }

  ListView _buildList(context) {
    return ListView.builder(
      itemCount: characters.length,
      // ignore: avoid_types_as_parameter_names
      itemBuilder: (context, int) {
        return GenshinCharaCard(characters[int], GICardStyles.list);
      },
    );
  }
}
