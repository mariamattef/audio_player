import 'package:audio_player_song/app_text_field.dart/app_text_field.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';

class DropDownList extends StatefulWidget {
  const DropDownList({super.key});

  @override
  State<DropDownList> createState() => _DropDownListState();
}

class _DropDownListState extends State<DropDownList> {
  TextEditingController country = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        AppTextField(
          cities: [
            SelectedListItem(name: 'Egypt'),
            SelectedListItem(name: 'Syria'),
            SelectedListItem(name: 'Lebnan'),
            SelectedListItem(name: 'America'),
          ],
          textEditingController: country,
          title: 'title',
          hint: 'hint',
          isCitySelected: true,
        ),
      ],
    );
  }
}
