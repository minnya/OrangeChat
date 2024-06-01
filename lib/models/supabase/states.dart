import 'package:flutter/foundation.dart';

class StateModel{
  int countryId;
  int stateId;
  String countryName;
  String stateName;

  StateModel({
    required this.countryId,
    required this.stateId,
    required this.countryName,
    required this.stateName
});

  factory StateModel.fromMap(
      Map<String, dynamic> stateMap
      ){
    return StateModel(
        countryId: stateMap["id"]??stateMap["country_id"],
        countryName: stateMap["name"]??stateMap["country_name"],
        stateId: stateMap["state_id"]??0,
        stateName: stateMap["state_name"]??""
    );
  }
}