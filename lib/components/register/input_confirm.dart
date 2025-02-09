import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/supabase/register.dart';

class InputConfirm extends StatelessWidget{
  final controller = TextEditingController();
  final RegisterModel registerModel;

  InputConfirm({super.key, required this.registerModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: TextFormField(
        keyboardType: TextInputType.number,
        controller: controller,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(8),
        ],
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter confirmation code';
          }
          registerModel.confirmCode = value;
          return null;
        },
        decoration: const InputDecoration(
          labelText: 'Confirmation Code',
          hintText: 'Enter confirmation code',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}