import 'dart:convert';

import 'package:codable/codable.dart';
import 'package:dean_pong/models/boardDetails.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class DatabaseService {
  static const String _databaseBaseURL = "https://deanpong-b0c79.firebaseio.com/";
  String _authToken;

  Future<Response> updateBoardInDatabase(BoardDetails board) async {
    final String boardURL = "${_databaseBaseURL}Board.json${_addAuthSegment()}";
    final archive = KeyedArchive.archive(board);

    return await http.put(boardURL, body: json.encode(archive));
  }

  Future<Response> fetchBoardFromDatabase() async {
    final String boardURL = "${_databaseBaseURL}Board.json${_addAuthSegment()}";

    return await http.get(boardURL);
  }

  set authToken(String value) {
    _authToken = value;
  }

  Future<Response> setUserDetailsInDatabase(String userId, String userName) async {
    final String boardURL = "${_databaseBaseURL}UserInfo/${userId}.json${_addAuthSegment()}";

    return await http.put(boardURL, body: json.encode({
      'userName': userName,
    }));
  }

  String _addAuthSegment() {
    return "?auth=$_authToken";
  }

}