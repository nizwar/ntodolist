import 'package:flutter/material.dart';
import 'package:todolist/core/models/model.dart';

class Tag extends Model {
    Tag({
        this.title,
        this.color,
    });

    String title;
    Color color;

    factory Tag.fromJson(Map<String, dynamic> json) => Tag(
        title: json["title"] == null ? null : json["title"],
        color: json["color"] == null ? null : json["color"],
    );

    Map<String, dynamic> toJson() => {
        "title": title == null ? null : title,
        "color": color == null ? null : color,
    };
}
