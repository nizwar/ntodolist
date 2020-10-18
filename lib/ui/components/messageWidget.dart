
import 'package:flutter/material.dart';

import 'customDivider.dart';

class MessageWidget extends StatelessWidget {
  const MessageWidget({
    Key key,
    @required this.title,
    @required this.subTitle,
  }) : super(key: key);

  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: ListView(
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        children: [
          Image.asset(
            "assets/images/Clipboard.png",
            height: 100,
          ),
          ColumnDivider(),
          Text(
            title ?? "",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline6.copyWith(fontWeight: FontWeight.bold),
          ),
          ColumnDivider(space: 5),
          Text(
            subTitle ?? "",
            textAlign: TextAlign.center,
            style: TextStyle(),
          ),
        ],
      ),
    );
  }
}
