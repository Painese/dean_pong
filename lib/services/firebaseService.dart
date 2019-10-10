import 'package:dean_pong/models/board.dart';
import 'package:dean_pong/services/databaseServiceDir/databaseService.dart';
import 'package:http/http.dart';

class FirebaseService {
  DatabaseService _databaseService = DatabaseService();

  Future<Response> updateBoardInDatabase(BoardDetails boardDetails) async {
    return _databaseService.updateBoardInDatabase(boardDetails);
  }

  Future<Response> fetchBoardFromDatabase() async {
    return _databaseService.fetchBoardFromDatabase();
  }
}