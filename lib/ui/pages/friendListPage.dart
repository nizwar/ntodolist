import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todolist/core/models/minUser.dart';
import 'package:todolist/ui/components/customImage.dart';
import 'package:todolist/ui/components/loadingWidget.dart';
import 'package:todolist/ui/components/messageWidget.dart';

class FriendListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pilih Teman"),
      ),
      body: StreamBuilder<List<MinUser>>(
        stream: FirebaseFirestore.instance.collection("friends").where("uid").snapshots().map(
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
              children: snapshot.data
                  .map((e) => ListTile(
                        title: Text(e.fullname),
                        subtitle: Text(e.email),
                        leading: CircleAvatar(
                          child: CustomImage(url: e.photo),
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
}
