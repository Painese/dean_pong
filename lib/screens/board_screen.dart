import 'package:flutter/cupertino.dart';

class BoardScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BoardScreenState();
  }

}

class _BoardScreenState extends State<BoardScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Board'),
    );
  }

}