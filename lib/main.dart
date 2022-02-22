import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

//import 'home/home_scaffold.dart';
import 'common/locator .dart';
import 'home/home_scaffold.dart';
//import 'login/login_scaffold.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(onBackgroundMessageHandler);
  runApp(const HomePage());
}

Future<void> onBackgroundMessageHandler(RemoteMessage message) async {
  print("Handling a background message ${message.data}");
  //You need to do everything in here
  //If you need to do anything with firebase you also need to call
  //await Firebase.initializeApp();
}
  
/*class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (context) => const LoginScaffold(),
        '/home': (context) => const HomeScaffold(),
      },
      initialRoute: '/',
    );
  }
}*/
