import 'package:flutter/material.dart';

class Card extends StatelessWidget {
  var data;
  Card(this.data);
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      color: Colors.blue,
      child: Center(
        child: Text('年级：${data.name}，id号：${data.id}'),
      ),
    );
  }
}