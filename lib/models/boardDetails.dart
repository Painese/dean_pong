import 'package:codable/codable.dart';
import 'package:codable/cast.dart' as cast;
import 'boardState.dart';

class BoardDetails extends Coding {
  BoardState _state;
  List<String> _witnessesIds;
  List<String> _currentPlayersIds;

  /// Coding implementation

  @override
  Map<String, cast.Cast<dynamic>> get castMap => {
    "currentPlayersId": cast.List(cast.String)
  };

  @override
  void encode(KeyedArchive object) {
    object.encode("witnessesIds", _witnessesIds);
    object.encode("currentPlayersId", _currentPlayersIds);
    object.encode("state", _state.index);
  }

  @override
  void decode(KeyedArchive object) {
    super.decode(object);

    _witnessesIds = copyListFromDecodeObject(object, "witnessesIds");
    _currentPlayersIds = copyListFromDecodeObject(object, "currentPlayersId");

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

  List<T> copyListFromDecodeObject<T>(KeyedArchive object, String listId) {
    final List<T> list = object.decode(listId); // Get list from decode object.
    List<T> growableList;

    if(list == null) {
      growableList = List<T>();
    } else {
     growableList = List<T>.from(list, growable: true); // Copy list in order to make it a growable list.
    }

    return growableList;
  }

  BoardState get state => _state;

  set state(BoardState value) {
    _state = value;
  }

  List<String> get currentPlayersIds => _currentPlayersIds;

  int get numberOfWitnesses => _witnessesIds.length;

  List<String> get witnessesIds => _witnessesIds;

  /// Copy constructor
  BoardDetails.copy(BoardDetails boardDetails) {
    _state = boardDetails.state;

    if(boardDetails._witnessesIds != null) {
      _witnessesIds = List<String>.from(boardDetails._witnessesIds, growable: true);
    }

    if(boardDetails.currentPlayersIds != null) {
      _currentPlayersIds = List<String>.from(boardDetails.currentPlayersIds, growable: true);
    }
  }

  BoardDetails() {}

}