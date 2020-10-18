import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ndialog/ndialog.dart';
import 'package:todolist/core/providers/userProvider.dart';
import 'package:todolist/core/utils/navigations.dart';
import 'package:todolist/core/utils/preferences.dart';
import 'package:todolist/ui/screens/onboardScreen.dart';
import 'core/resources/myColors.dart';
import 'ui/screens/mainScreen.dart';
import 'package:provider/provider.dart';

main() {
  return runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: primaryColor,
          accentColor: accentColor,
        ),
        home: Root(),
      ),
    ),
  );
}

class Root extends StatefulWidget {
  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  bool _ready;
  @override
  void initState() {
    Firebase.initializeApp().then((value) {
      initFuture();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (_ready ?? false)
        ? Consumer<UserProvider>(
            builder: (context, value, child) {
              if (value.user != null) {
                return MainScreen();
              } else {
                return OnBoardScreen();
              }
            },
          )
        : SplashScreen();
  }

  Future initFuture() async {
    Preferences preferences = await Preferences.instance();
    if (preferences.uid != null) {
      final resp = await UserProvider.autoLogin(context);
      if (resp != null)
        NAlertDialog(
          title: Text("Attention"),
          content: Text(resp),
          actions: [
            FlatButton(
              child: Text("Understand"),
              onPressed: () {
                closeScreen(context);
              },
            )
          ],
        ).show(context);
    }
    setState(() {
      _ready = true;
    });
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Image.asset(
            "assets/images/Clipboard.png",
            height: 200,
          ),
        ),
      ),
    );
  }
}
