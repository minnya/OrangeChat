String? validatePassword(value){
  // if (value == null || value.isEmpty) {
  //   return 'Please enter some text';
  // }

  if (RegExp(r'^(?=.*[a-z])(?=.*\d).{8,}$').hasMatch(value)==false) {
    return '- at least 8 characters\n- contains lowercase letters\n- contains digits';
  }
  return null;
}