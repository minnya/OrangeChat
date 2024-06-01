import 'package:orange_chat/models/supabase/place.dart';
import 'package:flutter/cupertino.dart';
import 'package:localstore/localstore.dart';

class FilterModel extends ChangeNotifier{
  String gender = "";
  int maxAge = 80;
  int minAge = 16;
  PlaceModel placeModel;

  FilterModel({
    required this.gender,
    required this.maxAge,
    required this.minAge,
    required this.placeModel,
  });

  factory FilterModel.fromMap(Map<String, dynamic>? map){
    print("Filter: $map");
    return FilterModel(
      gender: map?["gender"]??"",
      maxAge: map?["maxAge"]??80,
      minAge: map?["minAge"]??16,
      placeModel: PlaceModel(
          country: map?["country"]??"",
          prefecture: map?["prefecture"]??"",
      ),
    );
  }

  Map<String, dynamic> toMap(){

    Map<String, dynamic> filterMap={};
    if(gender.isNotEmpty) filterMap["gender"]= gender;
    if(maxAge!=80) filterMap["maxAge"]= maxAge;
    if(minAge!=16) filterMap["minAge"]= minAge;
    if(placeModel.country!.isNotEmpty) filterMap["country"] = placeModel.country;
    if(placeModel.prefecture!.isNotEmpty) filterMap["prefecture"] = placeModel.prefecture;

    return filterMap;
  }

  String getFilterString(){
    List<String> filters = [];
    if(gender.isNotEmpty) filters.add("gender.eq.$gender");
    if(maxAge!=80) filters.add("age.lte.$maxAge");
    if(minAge!=16) filters.add("age.gte.$minAge");
    if(placeModel.country!.isNotEmpty) filters.add("country.eq.${placeModel.country}");
    if(placeModel.prefecture!.isNotEmpty) filters.add("prefecture.eq.${placeModel.prefecture}");
    return filters.join(",");
  }

  static Future<FilterModel> load() async{
    DocumentRef localStoreInstance = Localstore.instance.collection("UserFilter").doc("Condition");
    Map<String, dynamic>? map = await localStoreInstance.get();
    return FilterModel.fromMap(map);
  }

  void save(){
    DocumentRef localStoreInstance = Localstore.instance.collection("UserFilter").doc("Condition");
    localStoreInstance.set(toMap());
  }

}