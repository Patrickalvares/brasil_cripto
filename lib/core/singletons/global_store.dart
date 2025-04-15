class GlobalStore {
  static final GlobalStore _instance = GlobalStore._internal();
  factory GlobalStore() => _instance;
  GlobalStore._internal();

  Map<String, dynamic> _userData = {};

  Map<String, dynamic> get userData => _userData;

  void setUserData(Map<String, dynamic> data) {
    _userData = data;
  }

  void updateUserData(Map<String, dynamic> data) {
    _userData.addAll(data);
  }

  void clearUserData() {
    _userData.clear();
  }

  void reset() {
    _userData.clear();
  }
}
