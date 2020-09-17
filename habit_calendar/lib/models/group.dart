import 'package:flutter/material.dart';

class Group {
  int id;
  String name;
  Color color;

  Group(this.id, this.name, this.color);

  Group.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        color = Color(json['color']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'color': color.value,
      };

  String toString() => 'id: $id, name: $name, color: $color';
}
