import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/supabase/register.dart';

class InputUsername extends StatelessWidget{
  final _controller = TextEditingController();
  final RegisterModel registerModel;

  InputUsername({super.key, required this.registerModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: TextFormField(
        controller: _controller,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter username';
          }

          if (RegExp(r'^.{1,20}$').hasMatch(value)==false) {
            return 'Username must be up to 20 characters';
          }
          registerModel.username = value;
          return null;
        },
        decoration: const InputDecoration(
          labelText: 'Username',
          hintText: 'Enter your username',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}