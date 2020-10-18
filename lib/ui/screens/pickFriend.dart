import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todolist/core/models/minUser.dart';
import 'package:todolist/core/providers/userProvider.dart';
import 'package:todolist/core/resources/myColors.dart';
import 'package:todolist/core/utils/navigations.dart'; 
import 'package:todolist/ui/components/loadingWidget.dart';
import 'package:todolist/ui/components/messageWidget.dart';

class PickFriendScreen extends StatefulWidget {
  final List<MinUser> picked;

  const PickFriendScreen({Key key, this.picked}) : super(key: key);

  @override
  _PickFriendScreenState createState() => _PickFriendScreenState();
}

class _PickFriendScreenState extends State<PickFriendScreen> {
  List<MinUser> picked = [];
  @override
  void initState() {
    picked = widget.picked;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pick Friend"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        width: MediaQuery.of(context).size.width - 30,
        height: 50,
        child: FlatButton(
          onPressed: () {
            closeScreen(context, picked);
          },
          child: Text(
            "Tambahkan",
            style: TextStyle(color: Colors.white),
          ),
          color: accentColor,
          shape: StadiumBorder(),
        ),
      ),
      body: StreamBuilder<List<MinUser>>(
        stream: FirebaseFirestore.instance.collection("friends").where("owner_uid", isEqualTo: UserProvider.instance(context).user.uid).snapshots().map(
              (event) => event.docs
                  .map(
                    (e) => MinUser.fromJson(
                      e.data(),
                    ),
                  )
                  .toList()
                  .cast(),
            ),
        builder: (context, snapshot) {
          if (!snapshot.hasData && snapshot.connectionState == ConnectionState.waiting) return LoadingWidget();
          if (snapshot.hasData) {
            if (snapshot.data.length == 0) {
              return MessageWidget(title: "Tidak ada teman!", subTitle: "Saat ini kamu belum memiliki teman");
            }
            return ListView(
              padding: EdgeInsets.all(10),
              children: snapshot.data
                  .map((e) => CheckboxListTile(
                        title: Text(e?.fullname ?? ""),
                        subtitle: Text(e?.email ?? ""),
                        value: picked.map((e) => e.email).contains(e.email),
                        onChanged: (value) {
                          if (value) {
                            setState(() {
                              picked.add(e);
                            });
                          } else {
                            setState(() {
                              picked.removeWhere((element) => element.email == e.email);
                            });
                          }
                        },
                      ))
                  .toList()
                  .cast(),
            );
          } else {
            return MessageWidget(title: "Gangguan!", subTitle: "Tidak dapat mengambil informasi task saat ini!");
          }
        },
      ),
    );
  }
}
