import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ndialog/ndialog.dart';
import 'package:todolist/core/models/minUser.dart';
import 'package:todolist/core/providers/userProvider.dart';
import 'package:todolist/core/resources/arrays.dart';
import 'package:todolist/core/resources/myColors.dart';
import 'package:todolist/core/utils/navigations.dart';
import 'package:todolist/ui/screens/pickFriend.dart';

import '../components/customDivider.dart';
import '../components/customImage.dart';

class TaskFormScreen extends StatefulWidget {
  final ScrollController scrollController;

  const TaskFormScreen({Key key, this.scrollController}) : super(key: key);
  @override
  _TaskFormScreenState createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final TextEditingController _etTitle = TextEditingController();
  String _tag = tags.first.title, _date, _time;

  List<MinUser> _friends = [];

  @override
  void initState() {
    _date = DateFormat.yMMMMd().format(DateTime.now());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_time == null) _time = TimeOfDay.now().format(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Tambah Task"),
        elevation: 0,
      ),
      body: ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        controller: widget.scrollController ?? null,
        children: [
          TextField(
            controller: _etTitle,
            autofocus: true,
            decoration: InputDecoration(
              labelText: "Judul Task!",
              border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: primaryColor)),
              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade200)),
            ),
          ),
          ColumnDivider(),
          Text(
            "Tag",
            style: TextStyle(fontSize: 13),
          ),
          ColumnDivider(space: 5),
          SizedBox(
            height: 50,
            child: _listOfTags(),
          ),
          ColumnDivider(),
          Text(
            "Tanggal",
            style: TextStyle(fontSize: 13),
          ),
          ColumnDivider(space: 5),
          FlatButton(
            shape: StadiumBorder(side: BorderSide(color: Colors.grey, width: 1)),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [Expanded(child: Text(_date ?? "Pick date")), Icon(Icons.keyboard_arrow_down)],
            ),
            onPressed: _pickDate,
          ),
          ColumnDivider(),
          Text(
            "Waktu",
            style: TextStyle(fontSize: 13),
          ),
          ColumnDivider(space: 5),
          FlatButton(
            shape: StadiumBorder(side: BorderSide(color: Colors.grey, width: 1)),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [Expanded(child: Text(_time ?? "Pick time")), Icon(Icons.keyboard_arrow_down)],
            ),
            onPressed: _pickTime,
          ),
          ColumnDivider(),
          Text(
            "Lakukan Dengan Teman",
            style: TextStyle(fontSize: 13),
          ),
          ColumnDivider(space: 5),
          SizedBox(
            height: 50,
            child: _listOfFriends(),
          ),
          Divider(height: 30),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: FlatButton(
                    shape: StadiumBorder(),
                    color: accentColor,
                    child: Text("+ Tambahkan", style: TextStyle(color: Colors.white)),
                    onPressed: _addTask,
                  ),
                ),
              )
            ],
          ),
          ColumnDivider(),
        ],
      ),
    );
  }

  void _addTask() async {
    var future = FirebaseFirestore.instance.collection("todo").add({
      "user": UserProvider.instance(context).user.email,
      "title": _etTitle.text,
      "tag": _tag,
      "date": _date,
      "time": _time,
      "success": false,
      "friends": Map.fromIterable(_friends.map((e) => e.toJson()), key: (item) => item["email"], value: (item) => item),
    });

    DocumentReference resp = await CustomProgressDialog.future<DocumentReference>(context, future: future);
    if (resp.id != null) closeScreen(context);
  }

  void _pickTime() async {
    final picked = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null)
      setState(() {
        _time = picked.format(context);
      });
  }

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        Duration(days: 10000),
      ),
    );

    if (picked != null)
      setState(() {
        _date = DateFormat.yMMMMd().format(picked);
      });
  }

  Widget _listOfTags() {
    return ListView(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      children: tags
          .map((e) => Container(
                margin: EdgeInsets.only(right: 10),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _tag = e.title;
                    });
                  },
                  child: Container(
                    height: 30,
                    child: _tag == e.title
                        ? Center(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: _tag == e.title ? e.color : Colors.transparent,
                                boxShadow: [_tag == e.title ? BoxShadow(blurRadius: 5, color: e.color) : BoxShadow(blurRadius: 0, color: Colors.transparent)],
                              ),
                              child: Text(
                                e.title,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                        : Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(color: e.color, shape: BoxShape.circle),
                              ),
                              RowDivider(space: 3),
                              Text(e.title),
                            ],
                          ),
                  ),
                ),
              ))
          .toList(),
    );
  }

  Widget _listOfFriends() {
    return ListView(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      children: _friends
          .map<Widget>(
            (e) => Container(
              height: 50,
              width: 50,
              margin: EdgeInsets.only(right: 10),
              child: FlatButton(
                padding: EdgeInsets.only(),
                child: CustomImage(
                  url: e.photo,
                ),
                onPressed: () {
                  setState(() {
                    _friends.removeWhere((element) => element.email == e.email);
                  });
                },
              ),
            ),
          )
          .toList()
          .cast<Widget>()
            ..add(SizedBox(
              height: 50,
              width: 50,
              child: FlatButton(
                padding: EdgeInsets.only(),
                shape: CircleBorder(side: BorderSide(color: primaryColor)),
                child: Icon(Icons.add),
                onPressed: _addFriend,
              ),
            )),
    );
  }

  void _addFriend() async {
    var resp = await startScreen<List<MinUser>>(
        context,
        PickFriendScreen(
          picked: _friends,
        ));
    if (resp != null || resp.length > 0) {
      _friends = resp;
      setState(() {});
    }
  }
}
