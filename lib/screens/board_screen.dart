import 'package:dean_pong/providers/board.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BoardScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BoardScreenState();
  }

}

class _BoardScreenState extends State<BoardScreen> {
  @override
  Widget build(BuildContext context) {
    final Board board = Provider.of<Board>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Board'),
      ),
      body: FutureBuilder(
          future: board.initialize(),
          builder: (cx, boardResultSnapshot) {
            return boardResultSnapshot.connectionState == ConnectionState.waiting? Center(child: CircularProgressIndicator(),) : _createBoardBody();
          },
        ),
    );
  }

  Widget _createBoardBody() {
    return Center(child: Text('Board'));
  }
}