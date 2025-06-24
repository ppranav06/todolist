// User data model

class User{
  final String username;

  User({
  required this.username,
  });
  
  @override
  String toString(){
    return 'User($username)';
  }

  Map<String, String> toMap(){
    return {'username': username};
  }

  Map<String, dynamic> toJson(){
    return toMap();
  }
}