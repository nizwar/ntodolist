import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ndialog/ndialog.dart';
import 'package:todolist/core/models/minUser.dart';
import 'package:todolist/core/providers/userProvider.dart';
import 'package:todolist/core/resources/myColors.dart';
import 'package:todolist/core/utils/navigations.dart';
import 'package:todolist/ui/components/customImage.dart';
import 'package:todolist/ui/components/loadingWidget.dart';
import 'package:todolist/ui/components/messageWidget.dart';

class FriendListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (context, sliver) {
        return [
          SliverAppBar(
            title: Text("Pilih Teman"),
            pinned: true,
            actions: [
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => _addFriendClick(context),
              )
            ],
          ),
        ];
      },
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
                  .map((e) => ListTile(
                        title: Text(e?.fullname ?? ""),
                        subtitle: Text(e?.email ?? ""),
                        leading: CircleAvatar(
                          child: CustomImage(url: e?.photo ?? ""),
                        ),
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

  void _addFriendClick(BuildContext context) {
    final controller = TextEditingController();
    NAlertDialog(
      title: Text("Masukan Email"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text("Masukan email temanmu!"),
          TextField(
            controller: controller,
            decoration: InputDecoration(labelText: "Email"),
            keyboardType: TextInputType.emailAddress,
          )
        ],
      ),
      actions: [
        FlatButton(
          color: accentColor,
          child: Text(
            "Undang",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () => _progAddFriend(context, controller),
        )
      ],
    ).show(context);
  }

  void _progAddFriend(BuildContext context, TextEditingController controller) async {
    closeScreen(context);
    var resp = await CustomProgressDialog.future(context, future: _addFriend(context, controller.text));
    if (resp != null)
      NAlertDialog(
        title: Text("Perhatian"),
        content: Text(resp),
        actions: [
          FlatButton(
            child: Text("Mengerti"),
            onPressed: () {
              closeScreen(context);
            },
          )
        ],
      ).show(context);
  }

  Future<String> _addFriend(BuildContext context, String email) async {
    var search = await FirebaseFirestore.instance.collection("users").where("email", isEqualTo: email).get();
    if (search.size == 0) return "Teman dengan email tersebut tidak ditemukan";
    try {
      FirebaseFirestore.instance.collection("friends").add(search.docs.first.data()
        ..addAll({
          "owner_uid": UserProvider.instance(context).user.uid,
        }));
    } catch (e) {
      return e.message;
    }
    return null;
  }
}
