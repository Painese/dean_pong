import 'package:codable/codable.dart';

class User extends Coding {
  String _id;
  String _name;

  @override
  void encode(KeyedArchive object) {
    object.encode("id", _id);
    object.encode("name", _name);
  }

  @override
  void decode(KeyedArchive object) {
    super.decode(object);

    _id = object.decode("id");
    _name = object.decode("name");
  }

}