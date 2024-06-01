import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigHelper {

  Future<String> get(String param) async{
    final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
    remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: Duration.zero,
    ));
    await remoteConfig.fetchAndActivate();
    print("Remote Config: ${remoteConfig.getString(param)}");
    return remoteConfig.getString(param);
  }
}