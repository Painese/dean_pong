import 'package:dean_pong/models/boardDetails.dart';
import 'package:dean_pong/models/boardState.dart';
import 'package:dean_pong/providers/auth.dart';
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
  String myUserId;
  bool didLoad = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if(!didLoad) {
      didLoad = true;
      myUserId = Provider.of<Auth>(context, listen: false).userId;
    }
  }

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
    return Consumer<Board>(
      builder: (ctx, board, _) {
        return Center(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text('Status: '),
                  CircleAvatar(
                    child: Center(child: Text(board.boardDetails.numberOfWitnesses.toString())),
                    backgroundColor: _getColorForBoardStatus(board),
                    radius: 20,
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  Text('Active players ids: ${board.boardDetails.currentPlayersIds}'), // CURRENT PLAYERS IDs
                ],
              ),
              Row(
                children: <Widget>[
                  RaisedButton(
                    child: Text(_getJoinOrLeaveButtonText(board)),
                    onPressed: () {
                      _joinOrLeaveBoard(board);
                    },
                  ),
                  RaisedButton(
                    child: Text('Confirm board state'),
                    onPressed: () {
                      _confirmCurrentBoardState(board);
                    },
                  ),
                ],
              ),
              FlatButton(
                child: Text(_getToggleBoardStateText(board)),
                onPressed: () {
                  _toggleBoardState(board);
                },
              )
            ],
          ),
        );
      },
    );
  }

  /// Actions
  // TODO: respond to errors in the following async board actions.
  void _joinOrLeaveBoard(Board board) {
    if(board.isUserInBoard(myUserId)) {
      board.leaveCurrentGame(myUserId);
    } else {
      board.joinCurrentGame(myUserId);
    }
  }

  void _confirmCurrentBoardState(Board board) {
    board.confirmCurrentBoardState();
  }

  void _toggleBoardState(Board board) {
    BoardState newBoardState;

    if(board.boardDetails.state == BoardState.free) {
      newBoardState = BoardState.matchInProgress;
    } else {
      newBoardState = BoardState.free;
    }

    board.setBoardState(newBoardState);
  }

  Color _getColorForBoardStatus(Board board) {
    Color color;

    if (board.boardDetails.numberOfWitnesses <= 1) {
      color = Colors.yellow;
    } else if(board.boardDetails.state == BoardState.free) {
      color = Colors.green;
    } else {
      color = Colors.red;
    }

    return color;
  }

  String _getToggleBoardStateText(Board board) {
    String text;

    if(board.boardDetails.state == BoardState.free) {
      text = 'Clear board';
    } else {
      text = 'Mark board as busy';
    }

    return text;
  }

  String _getJoinOrLeaveButtonText(Board board) {
    String text;

    if(board.isUserInBoard(myUserId)) {
      text = 'Leave';
    } else {
      text = 'Join';
    }

    return text;
  }
}