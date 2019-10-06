import 'package:dean_pong/services/databaseServiceDir/databaseService.dart';

class FirebaseService {
  DatabaseService _databaseService = DatabaseService();

  void testDB() {
    _databaseService.testPostingToFirebase();
  }
  
}