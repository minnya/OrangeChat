import 'package:flutter/cupertino.dart';

class ScreenSize {
  static Size get({required BuildContext context}){
    double width = MediaQuery.of(context).size.width;
    if(width<600){
      return Size.small;
    }else if(width<900){
      return Size.medium;
    }else{
      return Size.large;
    }
  }
}

enum Size{
  small,
  medium,
  large,
}