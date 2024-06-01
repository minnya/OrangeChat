import 'package:orange_chat/models/supabase/users.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/supabase/edit_users.dart';

class InputAge extends StatelessWidget{
  final EditUserModel editUserModel;
  const InputAge({super.key, required this.editUserModel});

  @override
  Widget build(BuildContext context) {

    return TextFormField(
      keyboardType: TextInputType.number,
      initialValue: editUserModel.age,
      decoration: InputDecoration(
          labelText: 'Age',
          hintText: "Not set",
        hintStyle: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.grey),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) {
        try {
          if(value==""){
            editUserModel.age = value;
            return null;
          }
          final int val = int.parse(value!);
          if (val < 16 || val > 80) {
            return 'Please enter a valid age between 16 and 80.';
          }else{
            editUserModel.age = value;
          }
        } catch (e) {
          return "Please enter a valid number";
        }
        return null;
      },
    );
  }
}