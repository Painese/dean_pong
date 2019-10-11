import 'dart:convert';
import 'package:codable/codable.dart';
import 'package:dean_pong/models/boardDetails.dart';
import 'package:dean_pong/services/firebaseService.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../models/boardState.dart';

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