import 'package:orange_chat/models/supabase/place.dart';
import 'package:csc_picker/dropdown_with_search.dart';
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
          await showDialog(
              context: context,
              builder: (BuildContext cotext) => SearchDialog(
                    placeHolder: labelText,
                    title: labelText,
                    items: list,
                itemStyle: Theme.of(context).textTheme.bodySmall,
                  )).then((value) {
            setPlace(value);
          });
        });
  }

  void setPlace(String placeValue){
    if (widget.isState) {
      widget.placeModel.prefecture = placeValue;
    } else if (widget.placeModel.country != placeValue) {
      widget.placeModel.country = placeValue ?? "";
      widget.placeModel.prefecture = "";
    }
    _controller.text = placeValue ?? "";
  }
}
