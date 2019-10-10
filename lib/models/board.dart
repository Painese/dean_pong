import 'dart:convert';
import 'package:codable/codable.dart';
import 'package:codable/cast.dart' as cast;
import 'package:dean_pong/services/firebaseService.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'boardState.dart';

class Board with ChangeNotifier {
  BoardDetails _boardDetails;
  BoardDetails _previousBoardDetails; // For undo purposes
  BoardDetails get boardDetails => _boardDetails;

  FirebaseService _fb = FirebaseService();

  Future<void> setBoard() async {
    final Response response = await _fb.fetchBoardFromDatabase();
    final jsonData = json.decode(response.body);
    final archive = KeyedArchive.unarchive(jsonData);
    _boardDetails = BoardDetails()..decode(archive);
    notifyListeners();
    print(boardDetails.numberOfWitnesses);
    print(boardDetails.state);
  }

  /// If the boards state is equal to the new state, update the number of witnesses. Else, set the new state.
  /// If the boards value did not update, restore its previous local state.
  Future<void> setBoardState(BoardState newState) async {
    _saveCurrentBoardDetails();

    final isSameState = newState == _boardDetails.state;

    if (isSameState) {
      _boardDetails.numberOfWitnesses++;
    } else {
      _boardDetails.state = newState;
    }

    try {
      final Response response = await _fb.updateBoardInDatabase(_boardDetails);
      print("FB response $response");
      print("FB parsed response ${json.decode(response.body)}");

      if (response.statusCode >= 400) {
        _undoLastBoardDetailsChange();
        throw Exception("Received error code from server ${response.statusCode}");
      }

      notifyListeners();
    } catch (error) {
      _undoLastBoardDetailsChange();
      throw error;
    }
  }

  void _saveCurrentBoardDetails() {
    _previousBoardDetails = BoardDetails.copy(boardDetails);
  }

  void _undoLastBoardDetailsChange() {
    _boardDetails = _previousBoardDetails;
  }
}

/// Board details

class BoardDetails extends Coding {
  BoardState _state;
  int _numberOfWitnesses;
  List<String> _currentPlayersIds;

  /// Coding implementation

  @override
  Map<String, cast.Cast<dynamic>> get castMap => {
    "currentPlayersId": cast.List(cast.String)
  };

  @override
  void encode(KeyedArchive object) {
    object.encode("numberOfWitnesses", _numberOfWitnesses);
    object.encode("currentPlayersId", _currentPlayersIds);
    object.encode("state", _state.index);
  }

  @override
  void decode(KeyedArchive object) {
    super.decode(object);

    _numberOfWitnesses = object.decode("numberOfWitnesses");
    _currentPlayersIds = object.decode("currentPlayersId");
    final stateInt = object.decode("state");

    if (stateInt == 0) {
      _state = BoardState.free;
    } else {
      _state = BoardState.free;
    }
  }

  BoardState get state => _state;

  set state(BoardState value) {
    _state = value;
  }

  List<String> get currentPlayersIds => _currentPlayersIds;

  set currentPlayersIds(List<String> value) {
    _currentPlayersIds = value;
  }

  int get numberOfWitnesses => _numberOfWitnesses;

  set numberOfWitnesses(int value) {
    _numberOfWitnesses = value;
  }

  /// Copy constructor
  BoardDetails.copy(BoardDetails boardDetails) {
     _numberOfWitnesses =  boardDetails.numberOfWitnesses;
     _state = boardDetails.state;

     if(boardDetails.currentPlayersIds != null) {
       _currentPlayersIds = List<String>();
      List.copyRange(_currentPlayersIds , 0, boardDetails.currentPlayersIds);
    }
  }

  BoardDetails() {}

}