import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist/core/providers/userProvider.dart';
import 'package:todolist/core/resources/myColors.dart';
import 'package:todolist/ui/components/customDivider.dart';
import 'package:todolist/ui/components/customImage.dart';

class ProfileDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profil Kamu"),
      ),
      body: Consumer<UserProvider>(
        builder: (context, value, child) => ListView(
          padding: EdgeInsets.all(20),
          children: [
            Center(
              child: CustomImage(
                url: value?.user?.photo ?? "",
                height: 80,
                width: 80,
                borderRadius: BorderRadius.circular(80),
              ),
            ),
            ColumnDivider(),
            Text(
              value?.user?.fullname ?? "",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              value?.user?.email ?? "",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
