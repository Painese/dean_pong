import 'package:dean_pong/models/boardDetails.dart';
import 'package:dean_pong/services/databaseServiceDir/databaseService.dart';
import 'package:http/http.dart';

class FirebaseService {
  DatabaseService _databaseService = DatabaseService();

  /// Singleton implementation

  static final FirebaseService instance = FirebaseService ._internal();

  factory FirebaseService() {
    return instance;
  }

  FirebaseService._internal();

  /// API

  Future<Response> updateBoardInDatabase(BoardDetails boardDetails) async {
    return _databaseService.updateBoardInDatabase(boardDetails);
  }

  Future<Response> fetchBoardFromDatabase() async {
    return _databaseService.fetchBoardFromDatabase();
  }

  Future<Response> setUserDetailsInDatabase(String userId, String userName) async {
    return _databaseService.setUserDetailsInDatabase(userId, userName);
  }

  set authToken(String value) {
    // Update other services
    _databaseService.authToken = value;
  }
}