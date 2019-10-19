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
  FirebaseService _fb = FirebaseService.instance;

  Future<void> initialize() async {
    print('Initialize called');
    final Response response = await _fb.fetchBoardFromDatabase();
    final jsonData = json.decode(response.body);
    final archive = KeyedArchive.unarchive(jsonData);

    _boardDetails = BoardDetails()..decode(archive);
    print('Initialize finished');
    notifyListeners();
  }

  /// If the boards state is equal to the new state, update the number of witnesses. Else, set the new state.
  /// If the boards value did not update, restore its previous local state.
  Future<void> setBoardState(BoardState newState) async {
    _saveCurrentBoardDetails();

    final isSameState = newState == _boardDetails.state;

    if (!isSameState) {
      _boardDetails.state = newState;
      _boardDetails.witnessesIds.clear();
      _boardDetails.currentPlayersIds.clear();
      return await _updateBoardInDatabase();
    }

  }

  Future<void> joinCurrentGame(String userId) async {
    if (_boardDetails.currentPlayersIds.contains(userId)) {
      print("User aready exists in current game");
      return;
    }

    _saveCurrentBoardDetails();

    _boardDetails.currentPlayersIds.add(userId);

    return await _updateBoardInDatabase();
  }

  Future<void> leaveCurrentGame(String userId) async {
    if (!_boardDetails.currentPlayersIds.contains(userId)) {
      print("User was not found in current game");
      return;
    }

    _saveCurrentBoardDetails();

    _boardDetails.currentPlayersIds.remove(userId);

    return await _updateBoardInDatabase();
  }

  Future<void> confirmCurrentBoardState(String userId) async {
    if(!_boardDetails.witnessesIds.contains(userId)) {
      _saveCurrentBoardDetails();
      _boardDetails.witnessesIds.add(userId);
      return await _updateBoardInDatabase();
    }
  }

  bool didUserConfirmBoardState(String userId) {
    return _boardDetails.witnessesIds.contains(userId);
  }

  /// Helper methods

  Future<void> _updateBoardInDatabase() async {
    try {
      final Response response = await _fb.updateBoardInDatabase(_boardDetails);

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

  bool isUserInBoard(String userId) {
    return boardDetails.currentPlayersIds.contains(userId);
  }
}