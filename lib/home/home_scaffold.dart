import 'package:flutter/material.dart';
import 'package:new_alameenhrworkflow/home/WebViewContainer.dart';
import 'package:new_alameenhrworkflow/home/welcome.dart';
import '../models/shared_pref.dart';
import 'package:new_alameenhrworkflow/models/user_data.dart';
import '../common/locator .dart';
import '../common/push_notification_service.dart';

/*
  const HomeScaffold({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Home'),
      ),
      body: const SafeArea(
          child: Center(
        child: Text('Logged'),
      )),
    );
  }
}*/

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SharedPref sharedPref = SharedPref();
  UserData model = UserData();
  final PushNotificationService _pushNotificationService =
      locator<PushNotificationService>();
  loadSharedPrefs() async {
    try {
      UserData user = UserData.fromJson(await sharedPref.read("user"));

      setState(() {
        model = user;
      });
    } catch (Excepetion) {}
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await _pushNotificationService.initialise();
  }

  @override
  Widget build(BuildContext context) {
    loadSharedPrefs();
    if (model.email == null) {
      return const MaterialApp(
        home: Welcome(),
      );
    } else {
      return MaterialApp(home: WebViewContainer(model.url, model.setcookie));
    }
  }
}
