import 'package:orange_chat/models/supabase/place.dart';
import 'package:flutter/material.dart';

import '../../helpers/supabase/state_model_helper.dart';

class InputPlace extends StatefulWidget {
  final PlaceModel placeModel;
  final bool isState;

  const InputPlace({
    super.key,
    required this.placeModel,
    this.isState = false,
  });

  @override
  State<InputPlace> createState() => _InputPlaceState();
}

class _InputPlaceState extends State<InputPlace> {
  final TextEditingController _controller = TextEditingController();
  String labelText = "";

  @override
  void initState() {
    super.initState();
    if (widget.isState == true) {
      labelText = "State";
      _controller.text = widget.placeModel.prefecture ?? "";
    } else {
      labelText = "Country";
      _controller.text = widget.placeModel.country ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        readOnly: true,
        controller: _controller,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: "Not set",
          hintStyle: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.grey),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: IconButton(
            icon: Icon(Icons.clear, color: Theme.of(context).colorScheme.outline,),
            onPressed: (){
              setPlace("");
            },
          )
        ),
        validator: (value) {
          if (value == "" && widget.isState == false) {
            return "Please enter country";
          }
          return null;
        },
        onTap: () async {
          List<String> list = [];
          if (widget.isState) {
            list = (await StateModelHelper().getStates(widget.placeModel.country!))
                .map((map) => map.stateName)
                .toList();
          } else {
            list = (await StateModelHelper().getCountries())
                .map((map) => map.countryName)
                .toList();
          }
          final result = await showDialog<String>(
              context: context,
              builder: (BuildContext dialogContext) => _SearchDialog(
                    placeholder: labelText,
                    title: labelText,
                    items: list,
                    itemStyle: Theme.of(context).textTheme.bodySmall,
                  ));
          if (result != null) {
            setPlace(result);
          }
        });
  }

  void setPlace(String placeValue){
    if (widget.isState) {
      widget.placeModel.prefecture = placeValue;
    } else if (widget.placeModel.country != placeValue) {
      widget.placeModel.country = placeValue;
      widget.placeModel.prefecture = "";
    }
    _controller.text = placeValue;
  }
}

class _SearchDialog extends StatefulWidget {
  final String placeholder;
  final String title;
  final List<String> items;
  final TextStyle? itemStyle;

  const _SearchDialog({
    required this.placeholder,
    required this.title,
    required this.items,
    this.itemStyle,
  });

  @override
  State<_SearchDialog> createState() => _SearchDialogState();
}

class _SearchDialogState extends State<_SearchDialog> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _filtered = [];

  @override
  void initState() {
    super.initState();
    _filtered = widget.items;
    _searchController.addListener(() {
      final query = _searchController.text.toLowerCase();
      setState(() {
        _filtered = widget.items
            .where((item) => item.toLowerCase().contains(query))
            .toList();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(widget.title,
                style: Theme.of(context).textTheme.titleMedium),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: widget.placeholder,
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                isDense: true,
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 300,
            child: ListView.builder(
              itemCount: _filtered.length,
              itemBuilder: (context, index) {
                return ListTile(
                  dense: true,
                  title: Text(_filtered[index], style: widget.itemStyle),
                  onTap: () => Navigator.of(context).pop(_filtered[index]),
                );
              },
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(null),
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }
}
