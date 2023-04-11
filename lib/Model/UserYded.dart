class UserYded {
  late String _email;
  final String _name;
  final int _records;
  final int _points;

  UserYded({
    required String email,
    required String name,
    required int records,
    required int points,
  })  : _email = email,
        _name = name,
        _points = points,
        _records = records;

  String get email => _email;
  String get name => _name;
  int get points => _points;
  int get records => _records;

  set setEmail(String email) => _email = email;

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'points': points,
      'records': records,
    };
  }
}