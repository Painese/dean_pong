import 'dart:convert';

import 'package:codable/codable.dart';
import 'package:dean_pong/models/boardDetails.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class DatabaseService {
  static const String _databaseBaseURL = "https://deanpong-b0c79.firebaseio.com/";

  Future<Response> updateBoardInDatabase(BoardDetails board) async {
    final String boardURL = "${_databaseBaseURL}Board.json";
    final archive = KeyedArchive.archive(board);

    return await http.put(boardURL, body: json.encode(archive));
  }

  Future<Response> fetchBoardFromDatabase() async {
    final String boardURL = "${_databaseBaseURL}Board.json";

    return await http.get(boardURL);
  }
}