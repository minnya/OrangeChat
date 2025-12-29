import 'package:flutter/material.dart';

import '../../models/supabase/register.dart';

class InputEmail extends StatelessWidget {
  final _emailController = TextEditingController();
  final RegisterModel registerModel;

  InputEmail({super.key, required this.registerModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: TextFormField(
        style: const TextStyle(color: Colors.white70),
        autofillHints: const [AutofillHints.newUsername],
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          // add email validation
          if (value == null || value.isEmpty) {
            return 'Please enter your email address';
          }

          bool emailValid = RegExp(
                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
              .hasMatch(value);
          if (!emailValid) {
            return 'Please enter a valid email';
          }
          registerModel.email = value;

          return null;
        },
        decoration: const InputDecoration(
          labelText: 'Email',
          hintText: 'Enter your email',
          labelStyle: TextStyle(color: Colors.white30),
          hintStyle: TextStyle(color: Colors.white30),
          prefixIcon: Icon(
            Icons.email_outlined,
            color: Colors.white30,
          ),
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
