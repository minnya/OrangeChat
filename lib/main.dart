
import 'package:orange_chat/bottom_nav.dart';
import 'package:orange_chat/const/variables.dart';
import 'package:orange_chat/views/404.dart';
import 'package:orange_chat/views/authenticate/email-verified.dart';
import 'package:orange_chat/views/authenticate/reset-password-2.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await ConstVariables.init();
  await Supabase.initialize(
    url: ConstVariables.SUPABASE_HOSTNAME,
    anonKey: ConstVariables.SUPABASE_ANONKEY,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle.merge(
      child: MaterialApp(
        // initialRoute: "/app",
        onGenerateRoute: (RouteSettings setting){
          Widget destinationPage=const Scaffold();
          switch(setting.name){
            case "/email-verified": destinationPage = const EmailVerificationPage();
            case "/reset-password": destinationPage = const ResetPasswordPage2();
            case "/app": destinationPage = const SimpleBottomNavigation();
            default: destinationPage = const NotFoundPage();
          }
          return MaterialPageRoute(builder: (context)=>destinationPage);
        },
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
          useMaterial3: true,
          appBarTheme: AppBarTheme(
            titleTextStyle: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        home: const SimpleBottomNavigation(),
      ),
    );
  }
}
