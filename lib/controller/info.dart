// Cấu trúc user info, và các phươnng thức get user info, dùng network_helper
class UserInfo {
  String _id;
  String _username;
  String _phone;
  String _email;
  String _password;

  UserInfo(
      {String id,
      String username,
      String phone,
      String email,
      String password}) {
    _id = id;
    _username = username;
    _phone = phone;
    _email = email;
    _password = password;
  }

  void setID(String id) {
    _id = id;
  }

  void setUsername(String username) {
    _username = username;
  }

  void setPhone(String phone) {
    _phone = phone;
  }

  void setEmail(String email) {
    _email = email;
  }

  void setPassword(String password) {
    _password = password;
  }

  String getID() {
    return _id;
  }

  String getName() {
    return _username;
  }

  String getPhone() {
    return _phone;
  }

  String getEmail() {
    return _email;
  }

  String getPassword() {
    return _password;
  }
}