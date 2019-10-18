import 'package:codable/codable.dart';
import 'package:codable/cast.dart' as cast;
import 'boardState.dart';

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

    if(_currentPlayersIds == null) {
      _currentPlayersIds = List<String>();
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
//      _currentPlayersIds = List<String>();
      currentPlayersIds = new List<String>.from(boardDetails.currentPlayersIds);

//      for(String playerId in boardDetails.currentPlayersIds) {
//        currentPlayersIds.add(playerId);
//      }
    }
  }

  BoardDetails() {}

}