import 'package:orange_chat/models/supabase/filter.dart';
import 'package:flutter/material.dart';

class GenderList extends StatefulWidget{
  final FilterModel userFilter;
  const GenderList({super.key, required this.userFilter});

  @override
  State<GenderList> createState() => _GenderListState();
}

class _GenderListState extends State<GenderList> {
  var selectedTags = <String>[];
  final options = [
    'male',
    'female',
  ];
  @override
  Widget build(BuildContext context) {

    if(widget.userFilter.gender!="") selectedTags.add(widget.userFilter.gender);

    return Container(
      padding: const EdgeInsets.all(8),
      alignment: Alignment.centerLeft,
      child: Wrap(
        spacing: 16,
        children: options.map((tag) {
          final isSelected = selectedTags.contains(tag);
          return InkWell(
            onTap: () {
              if (isSelected) {
                selectedTags.removeWhere((element)=> element == tag);
              } else {
                selectedTags.add(tag);
              }
              setState(() {});
              // フィルターモデルを更新
              if(selectedTags.length==1) {
                widget.userFilter.gender = selectedTags.first;
              } else {
                widget.userFilter.gender = "";
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                border: Border.all(
                  width: 1,
                  color: Theme.of(context).colorScheme.primary
                ),
                color: isSelected ? Theme.of(context).colorScheme.primary : null,
              ),
              child: Text(
                tag,
                style: Theme.of(context).textTheme.labelMedium!.copyWith(color: isSelected ? Colors.white : Theme.of(context).colorScheme.primary,),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}