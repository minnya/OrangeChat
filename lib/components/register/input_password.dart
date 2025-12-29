import 'package:flutter/material.dart';

import '../../models/supabase/register.dart';

class InputPassword extends StatefulWidget {
  final RegisterModel registerModel;
  const InputPassword({super.key, required this.registerModel});

  @override
  State<InputPassword> createState() => _InputEmailState();
}

class _InputEmailState extends State<InputPassword> {
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: TextFormField(
        style: const TextStyle(color: Colors.white70),
        autofillHints: const [AutofillHints.newPassword],
        controller: _passwordController,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter some text';
          }

          if (RegExp(r'^(?=.*[a-z])(?=.*\d).{8,}$').hasMatch(value) == false) {
            return '- at least 8 characters\n- contains lowercase letters\n- contains digits';
          }
          widget.registerModel.password = value;
          return null;
        },
        obscureText: !_isPasswordVisible,
        decoration: InputDecoration(
            labelText: 'Password',
            hintText: 'Enter your password',
            labelStyle: const TextStyle(color: Colors.white30),
            hintStyle: const TextStyle(color: Colors.white30),
            prefixIcon: const Icon(
              Icons.lock_outline_rounded,
              color: Colors.white30,
            ),
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: Icon(
                  _isPasswordVisible ? Icons.visibility_off : Icons.visibility),
              color: Colors.white30,
              onPressed: () => setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              }),
            )),
      ),
    );
  }
}
