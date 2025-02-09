import 'package:orange_chat/helpers/auth_helper.dart';
import 'package:orange_chat/models/supabase/states.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class StateModelHelper {
  final client = Supabase.instance.client;
  final uid = AuthHelper().getUID();

  Future<List<StateModel>> getCountries() async {
    List<Map<String, dynamic>> countries =
        await client.from("countries").select("*");
    List<StateModel> countryList =
        countries.map((map) => StateModel.fromMap(map)).toList();

    return countryList;
  }

  Future<List<StateModel>> getStates(String countryName) async {
    List<Map<String, dynamic>> countries = await client
        .from("view_states")
        .select("*")
        .eq("country_name", countryName);
    List<StateModel> stateList =
        countries.map((map) => StateModel.fromMap(map)).toList();

    return stateList;
  }
}
