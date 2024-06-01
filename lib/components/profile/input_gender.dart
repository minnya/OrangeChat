import 'package:orange_chat/models/supabase/users.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/supabase/edit_users.dart';

class InputGender extends StatefulWidget{
  final EditUserModel editUserModel;

  const InputGender({super.key, required this.editUserModel});

  @override
  State<InputGender> createState() => _InputGenderState();
}

class _InputGenderState extends State<InputGender> {
  final TextEditingController _genderController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _genderController.text=widget.editUserModel.gender??"";

    return TextFormField(
      autovalidateMode: AutovalidateMode.always,
      readOnly: true,
      controller: _genderController,
      decoration: InputDecoration(
        labelText: 'Gender',
        hintText: "Not set",
        hintStyle: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.grey),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value){
        widget.editUserModel.gender = value;
        return null;
      },
      onTap: () {
        showDialog(context: context,
            builder: (BuildContext context) => SimpleDialog(
              children: <Widget>[
                SimpleDialogOption(
                  onPressed: () {
                    _genderController.text="";
                    Navigator.of(context).pop();
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.not_interested_outlined),
                      Text('Prefer not to say'),
                    ],
                  ),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    _genderController.text="male";
                    Navigator.of(context).pop();
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.boy_outlined),
                      Text('male'),
                    ],
                  ),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    _genderController.text="female";
                    Navigator.of(context).pop();
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.girl),
                      Text('female'),
                    ],
                  ),
                ),
              ],
            ));
      },
    );
  }
}