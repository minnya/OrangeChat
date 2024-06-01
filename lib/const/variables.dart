import 'package:orange_chat/helpers/auth_helper.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../helpers/remote_config.dart';

class ConstVariables{
  static String SUPABASE_HOSTNAME = "";
  static String SUPABASE_ANONKEY = "";
  static String APP_HOSTNAME = "";

  static Future<void> init()async{
    SUPABASE_HOSTNAME = await RemoteConfigHelper().get("SUPABASE_BASE_URL");
    SUPABASE_ANONKEY = await RemoteConfigHelper().get("SUPABASE_ANONKEY");
    APP_HOSTNAME = await RemoteConfigHelper().get("APP_BASE_URL");
  }

}