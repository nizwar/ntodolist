import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist/core/providers/userProvider.dart';
import 'package:todolist/core/utils/navigations.dart';
import 'package:todolist/ui/components/customCard.dart';
import 'package:todolist/ui/components/customImage.dart';
import 'package:todolist/ui/components/loadingWidget.dart';
import 'package:todolist/ui/components/messageWidget.dart';
import 'package:todolist/ui/screens/profileDetailScreen.dart';

class BerandaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final streamTask = FirebaseFirestore.instance
        .collection("todo")
        .where(
          "user",
          isEqualTo: UserProvider.instance(context).user.email,
        )
        .where("friends", arrayContains: UserProvider.instance(context).user.email)
        .snapshots();

    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        SliverAppBar(
          backgroundColor: Colors.red,
          elevation: 0,
          expandedHeight: 200,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: EdgeInsets.only(),
            background: Center(
              child: Container(
                margin: EdgeInsets.only(top: 70),
                height: 200,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.red,
                      Colors.orange,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: CustomCard(
                  margin: EdgeInsets.all(30),
                  padding: EdgeInsets.all(10),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Today Reminder!", style: Theme.of(context).textTheme.headline6),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          title: Consumer<UserProvider>(
            builder: (context, value, child) => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text("Halo ${value.user.fullname}!", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                Text("Hari ini kamu punya !", style: TextStyle(color: Colors.white, fontSize: 12)),
              ],
            ),
          ),
          actions: [
            Consumer<UserProvider>(
              builder: (context, value, child) => IconButton(
                icon: CustomImage(
                  borderRadius: BorderRadius.circular(50),
                  url: value.user.photo,
                  height: 30,
                  width: 30,
                ),
                onPressed: () => _profileClick(context),
              ),
            ),
          ],
        ),
      ],
      body: StreamBuilder<QuerySnapshot>(
        stream: streamTask,
        builder: (context, snapshot) {
          if (!snapshot.hasData && snapshot.connectionState == ConnectionState.waiting) return LoadingWidget();
          if (snapshot.hasData) {
            if (snapshot.data.size == 0) {
              return MessageWidget(title: "Tidak ada TASK!", subTitle: "Saat ini kamu belum memiliki task, ayo buat sekarang!");
            }
            return Container(
              child: Text(snapshot.data.docs.first.toString()),
            );
          } else {
            return MessageWidget(title: "Gangguan!", subTitle: "Tidak dapat mengambil informasi task saat ini!");
          }
        },
      ),
    );
  }

  void _profileClick(BuildContext context) {
    startScreen(context, ProfileDetailScreen());
  }
}
