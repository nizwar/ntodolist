import 'package:flutter/material.dart';
import 'package:ndialog/ndialog.dart';
import 'package:todolist/core/providers/userProvider.dart';
import 'package:todolist/core/resources/myColors.dart';
import 'package:todolist/core/utils/navigations.dart';
import 'package:todolist/ui/components/customDivider.dart';

class OnBoardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          padding: EdgeInsets.all(20),
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          children: [
            Hero(
              tag: "intro",
              child: Image.asset(
                "assets/images/Clipboard.png",
                height: 200,
              ),
            ),
            Text("NTodo List", style: Theme.of(context).textTheme.headline6.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            ColumnDivider(),
            Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris pellentesque erat in blandit luctus.", textAlign: TextAlign.center),
            ColumnDivider(),
            Center(
              child: _signInButton(context),
            )
          ],
        ),
      ),
    );
  }

  Widget _signInButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: GreenShadow, blurRadius: 15, offset: Offset(0, 0))],
        gradient: LinearGradient(
          colors: [GreenLight, GreenDark],
        ),
        color: Colors.white,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _loginClick(context),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Image.asset("assets/images/google.png", height: 20, width: 20),
                ),
                RowDivider(),
                Text(
                  "SIGN IN",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _loginClick(BuildContext context) async {
    final resp = await CustomProgressDialog.future(context, future: UserProvider.login(context));
    if (resp != null)
      NAlertDialog(title: Text("Attention"), content: Text(resp.toString()), actions: [
        FlatButton(
            child: Text("Ok!"),
            onPressed: () {
              closeScreen(context);
            })
      ]).show(context);
  }
}
